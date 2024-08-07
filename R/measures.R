#' @title Measure Registry
#'
#' @description
#' The [environment()] `measures` keeps track of all measures in this package.
#' It stores meta information such as minimum, maximum or if the
#' measure must be minimized or maximized.
#' The following information is available for each measure:
#' * `id`: Name of the measure.
#' * `title`: Short descriptive title.
#' * `type`: `"binary"` for binary classification, `"classif"` for binary or multi-class classification,
#'   `"regr"` for regression and `"similarity"` for similarity measures.
#' * `lower`: lower bound.
#' * `upper`: upper bound.
#' * `predict_type`: prediction type the measure operates on.
#'   `"response"` corresponds to class labels for classification and the numeric response for regression.
#'   `"prob"` corresponds to class probabilities, provided as a matrix with class labels as column names.
#'   `"se"` corresponds to to the vector of predicted standard errors for regression.
#' * `minimize`: If `TRUE` or `FALSE`, the objective is to minimize or maximize the measure, respectively.
#'   Can also be `NA`.
#' * `obs_loss`: Name of the function which is called to calculate the (unaggregated) loss per observation.
#' * `trafo`: Optional `list()` of length 2, containing a transformation `"fn"` and its derivative `"deriv"`.
#' * `aggregated`: If `TRUE`, this function aggregates the losses to a single numeric value.
#'   Otherwise, a vector of losses is returned.
#' * `sample_weights`: If `TRUE`, it is possible calculate a weighted measure.
#'
#' @export
#' @examples
#' names(measures)
#' measures$tpr
measures = new.env(parent = emptyenv())

# adds items to registry
add_measure = function(obj, title, type, lower, upper, minimize, obs_loss = NA_character_, trafo = NA_character_, aggregated = TRUE) {
  id = deparse(substitute(obj))

  ptype = intersect(names(formals(obj)), c("response", "prob", "se"))
  if (length(ptype) == 0L) {
    ptype = NA_character_
  }

  if (!identical(trafo, NA_character_)) {
    assert_list(trafo, types = "function", len = 2L)
    assert_permutation(names(trafo), c("fn", "deriv"))
    assert_true(!is.na(obs_loss))
  }

  assign(id, list(
    id = id,
    title = assert_string(title),
    type = assert_choice(type, c("binary", "classif", "regr", "similarity")),
    lower = assert_number(lower),
    upper = assert_number(upper),
    predict_type = ptype,
    minimize = assert_flag(minimize, na.ok = TRUE),
    obs_loss = assert_string(obs_loss, na.ok = TRUE),
    aggregated = assert_flag(aggregated),
    sample_weights = "sample_weights" %in% names(formals(obj)),
    trafo = trafo
  ), envir = measures)
}
