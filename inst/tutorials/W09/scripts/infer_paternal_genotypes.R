infer_paternal_genotypes <- function(geno_input, mother_id, offspring_ids) {
  # helper: convert genlight to numeric matrix if necessary
  convert_to_matrix <- function(x) {
    if (inherits(x, "genlight")) {
      # try as.matrix.genlight (adegenet; returns 0/1/2/NA)
      m <- tryCatch(as.matrix(x), error = function(e) NULL)
      if (is.null(m)) {
        # fallback: try slot extraction
        if (!is.null(x@gen)) m <- as.matrix(x@gen) else stop("Can't convert genlight to matrix.")
      }
      # ensure numeric
      m <- apply(m, 2, function(col) as.numeric(col))
      rownames(m) <- indNames(x)
      return(m)
    } else if (is.matrix(x) || is.data.frame(x)) {
      m <- as.matrix(x)
      mode(m) <- "numeric"
      return(m)
    } else stop("geno_input must be a genlight object or numeric matrix/data.frame")
  }

  geno <- convert_to_matrix(geno_input)
  if (is.character(mother_id)) mother_row <- which(rownames(geno) == mother_id) else mother_row <- mother_id
  if (is.character(offspring_ids)) offspring_rows <- which(rownames(geno) %in% offspring_ids) else offspring_rows <- offspring_ids

  if (length(mother_row) != 1) stop("mother_id not found or ambiguous")
  if (length(offspring_rows) < 1) stop("No offspring specified/found")

  mom <- geno[mother_row, , drop = FALSE]
  off <- geno[offspring_rows, , drop = FALSE]

  # Mendelian probability function: P(offspring genotype | mom, dad)
  # mom, dad, off are coded 0,1,2 (NA allowed).
  offspring_prob <- function(mg, dg) {
    # return vector of probabilities for offspring genotypes 0,1,2
    # compute gamete distributions:
    maternal_gametes <- switch(as.character(mg),
                               "0" = c(`0`=1, `1`=0),
                               "1" = c(`0`=0.5, `1`=0.5),
                               "2" = c(`0`=0, `1`=1),
                               NULL = c(`0`=NA, `1`=NA)
    )
    paternal_gametes <- switch(as.character(dg),
                               "0" = c(`0`=1, `1`=0),
                               "1" = c(`0`=0.5, `1`=0.5),
                               "2" = c(`0`=0, `1`=1),
                               NULL = c(`0`=NA, `1`=NA)
    )
    if (any(is.na(maternal_gametes)) || any(is.na(paternal_gametes))) return(c(NA, NA, NA))
    # offspring genotype = sum of allele values (0 or 1) -> possible genotypes 0,1,2
    # compute probabilities:
    p0 <- maternal_gametes["0"] * paternal_gametes["0"]           # 0 + 0
    p1 <- maternal_gametes["0"] * paternal_gametes["1"] +
      maternal_gametes["1"] * paternal_gametes["0"]           # 0+1 or 1+0
    p2 <- maternal_gametes["1"] * paternal_gametes["1"]           # 1+1
    return(c(p0, p1, p2))
  }

  nL <- ncol(geno)
  results <- data.frame(
    SNP = colnames(geno),
    inferred_father = rep(NA_integer_, nL),
    top_loglik = rep(NA_real_, nL),
    second_loglik = rep(NA_real_, nL),
    delta_loglik = rep(NA_real_, nL),
    stringsAsFactors = FALSE
  )

  # iterate loci
  for (j in seq_len(nL)) {
    mg <- mom[1, j]
    off_g <- off[, j]

    # if all offspring missing or mother missing -> can't infer
    if (is.na(mg) || all(is.na(off_g))) {
      next
    }

    # compute log-likelihood of genotype data for each candidate father genotype (0,1,2)
    candidate_g <- 0:2
    logliks <- numeric(length(candidate_g))
    for (k in seq_along(candidate_g)) {
      dg <- candidate_g[k]
      # product over offspring: use log-sum, treat 0 probabilities as tiny to avoid -Inf if needed
      lk <- 0
      valid <- TRUE
      for (o in seq_along(off_g)) {
        og <- off_g[o]
        if (is.na(og)) next
        probs <- offspring_prob(mg, dg)
        p_og <- probs[og + 1]  # og in 0..2 -> index og+1
        if (is.na(p_og) || p_og == 0) {
          # incompatible (zero probability) -> mark as extremely unlikely
          lk <- lk + log(1e-300)  # tiny floor
        } else {
          lk <- lk + log(p_og)
        }
      } # offspring loop
      logliks[k] <- lk
    }

    # choose best father genotype (highest loglik)
    ord <- order(logliks, decreasing = TRUE)
    best <- candidate_g[ord[1]]
    second <- candidate_g[ord[2]]

    results$inferred_father[j] <- best
    results$top_loglik[j] <- logliks[ord[1]]
    results$second_loglik[j] <- logliks[ord[2]]
    results$delta_loglik[j] <- logliks[ord[1]] - logliks[ord[2]]
  }

  return(results)
}
