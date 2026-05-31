# kioloa2 — dartR / dartRverse Workshop

Interactive teaching materials for the **dartRverse** conservation-genomics workshop. Each session is a self-contained [`learnr`](https://rstudio.github.io/learnr/) tutorial (interactive R code chunks rendered with `runtime: shiny_prerendered`), with its own data, images, and styling.

## Demo

<!--
  ▶ TO ADD THE VIDEO (one-time, via github.com — not from the CLI):
  1. Open this README in the GitHub web editor (the ✏️ pencil on the repo page).
  2. Click on the line below this comment to place the cursor there.
  3. Drag-and-drop  figures/crawl_3.mp4  onto that line.
     GitHub uploads it to its CDN and replaces this placeholder with a
     URL like  https://github.com/user-attachments/assets/XXXXXXXX
     which renders as an inline video player. Nothing is committed to the repo.
  4. Commit the README edit.
-->


https://github.com/user-attachments/assets/d0be8724-9ef9-40ee-9312-22d77c76b8da


> 📹 _Workshop demo video — drop `crawl_3.mp4` here in the GitHub web editor (see the HTML comment above)._

## Getting started

```r
install.packages("dartRverse")
library(dartRverse)
```

Open any session's `.Rmd` in RStudio and click **Run Document** to launch the interactive tutorial, or browse the rendered site (published from the `gh-pages` branch via GitHub Pages).

## Sessions

| # | Topic | Presenter(s) |
|---|---|---|
| — | Getting Started with dartR | The dartR Team |
| W01 | Pop Gen in Conservation and Restoration | Laura Bertola & Kate Rick |
| W02 | dartR Intro | Arthur Georges, Ching-Ching Lau & Diana Robledo |
| W03 | Sex-Linked Markers | Diana Robledo & Floriaan Devloo-Delva |
| W04 | Genetic Structure | Bill Sherwin, Floriaan Devloo-Delva & Laura Bertola |
| W05 | Calling SNPs | Renee Catullo |
| W06 | Small Populations | Diana Robledo & Peter Unmack |
| W07 | Effective Population Size | Robin Waples, Luis Mijangos & Bernd Gruber |
| W08 | Genetic Structure of Wild Populations to Inform Management | Craig Moritz & Arthur Georges |
| W09 | Hidden dartR Powers | Bernd Gruber, Luis Mijangos & Arthur Georges |
| W10 | Natural Selection & Adaptation | Luciano Beheregaray & Chris Brauer |
| W11 | Landscape Genetics | Robyn Shaw, Cynthia Riginos & Zoe Meziere |
| W12 | AI in PopGen & Research | Jonathan Ting, Darya Vanichkina & Celine Frere |
| W13 | Sequencing Technologies | Andrzej Kilian |
| W14 | Simulations | Bernd Gruber & Luis Mijangos |
| W15 | SNPs that Matter | Elise Furlan, Bernd Gruber & collaborators |
| W16 | dartRverse (relatedness & parentage) | The dartR Team |
| W17 | OneDArT | Andrzej Kilian & Luis Mijangos |

## Repository layout

```
inst/tutorials/
  getting-started/   intro eBook
  W01/ … W17/        one folder per session: WNN.Rmd + data/ images/ css/ references.bib
docs/                rendered Quarto site (served from gh-pages)
```

Tutorial assets (data, images, CSS, bibliography) are scoped **inside each session's folder**, not shared at the repo root.

## Authoring & rendering

Two long-lived branches with distinct jobs (see `howto.txt`):

- **`main`** — author and test the session `.Rmd` files here, then commit.
- **`gh-pages`** — holds the Quarto site (`_quarto.yml`, `index.qmd`, `schedule.qmd`, …). Merge `main`, run `quarto::quarto_render()`, commit, and push to publish.

Always author/test on `main`; render and publish on `gh-pages`.

## License

MIT.
