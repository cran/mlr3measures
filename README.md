# mlr3measures

Package website: [release](https://mlr3measures.mlr-org.com/) | [dev](https://mlr3measures.mlr-org.com/dev)

[![R build status](https://github.com/mlr-org/mlr3measures/workflows/R-CMD-check/badge.svg)](https://github.com/mlr-org/mlr3measures/actions)
[![CRAN Status Badge](https://www.r-pkg.org/badges/version-ago/mlr3measures)](https://cran.r-project.org/package=mlr3measures)
[![Cran Checks](https://cranchecks.info/badges/worst/mlr3measures)](https://cran.r-project.org/web/checks/check_results_mlr3measures.html)
[![codecov](https://codecov.io/gh/mlr-org/mlr3measures/branch/master/graph/badge.svg)](https://codecov.io/gh/mlr-org/mlr3measures)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)

Implements multiple performance measures for supervised learning.
Includes over 40 measures for regression and classification.
Additionally, meta information about the performance measures can be queried, e.g. what the best and worst possible performances scores are.
Internally, [checkmate](https://CRAN.R-project.org/package=checkmate) is used to check arguments efficiently - no other runtime dependencies.

The [function reference](https://mlr3measures.mlr-org.com/reference/index.html) gives an encompassing overview over implemented measures.

Note that explicitly loading this package is not required if you want to use any of these measures in [mlr3](https://mlr3.mlr-org.com).
Also note that we advise against attaching the package via `library()` to avoid namespace clashes.
Instead, load the namespace via `requireNamespace()` and use the `::` operator.
