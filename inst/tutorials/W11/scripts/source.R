lm_eqn <-
  function(df,
           manteltest) {

    r = manteltest$statistic
    pp = manteltest$signif

    m <- lm(Dgen ~ Dgeo, df)
    eq <-
      substitute(
        italic(y) == a + b %.% italic(x) * "," ~ ~ italic(R) ^ 2 ~ "=" ~ r2 * "," ~ ~
          italic(p) ~ "=" ~ pp,
        list(
          a = format(unname(coef(m)[1]),
                     digits = 2),
          b = format(unname(coef(m)[2]), digits = 2),
          r2 = format(summary(m)$r.squared, digits = 3),
          pp = format(pp, digits = 3)
        )
      )
    as.character(as.expression(eq))
  }
