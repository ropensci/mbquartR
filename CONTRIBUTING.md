# Contributing to mbquartR

All suggestions are welcomed, big and small, on how to make this package
more robust, functional, and user friendly. Please read the contributing
guide below and follow it the best you can.

By participating in this project, you agree to abide by the following
[code of conduct](https://ropensci.org/code-of-conduct/).

## Fixing typos

You can fix typos, spelling mistakes, or grammatical errors in the
documentation directly using the GitHub web interface, as long as the
changes are made in the *source* file. This generally means you’ll need
to edit [roxygen2
comments](https://roxygen2.r-lib.org/articles/roxygen2.html) in an `.R`,
not a `.Rd` file. You can find the `.R` file that generates the `.Rd` by
reading the comment in the first line.

## Bigger changes

If you want to make a bigger change, it’s a good idea to first file an
issue and make sure the author agrees that it’s needed. If you’ve found
a bug, please file an issue that illustrates the bug with a minimal
[reprex](https://www.tidyverse.org/help/#reprex) if you can (this will
also help you write a unit test, if needed).

### Pull request process

- Fork the package and clone onto your computer. If you haven’t done
  this before, we recommend using
  `usethis::create_from_github("alex-koiter/mbquartR", fork = TRUE)`.

- Install all development dependencies with
  `devtools::install_dev_deps()`, and then make sure the package passes
  R CMD check by running `devtools::check()`. If R CMD check doesn’t
  pass cleanly, it’s a good idea to ask for help before continuing.

- Create a Git branch for your pull request (PR). We recommend using
  `usethis::pr_init("brief-description-of-change")`.

- Make your changes, commit to git, and then create a PR by running
  `usethis::pr_push()`, and following the prompts in your browser. The
  title of your PR should briefly describe the change. The body of your
  PR should contain `Fixes #issue-number`.

### Code style

- New code should try and follow the [tidyverse style
  guide](https://style.tidyverse.org/index.html)

- Use [roxygen2](https://cran.r-project.org/package=roxygen2), with
  [Markdown
  syntax](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd-formatting.html),
  for documentation.

- Use [testthat](https://cran.r-project.org/package=testthat) for unit
  tests. Contributions with test cases included are easier to accept.
