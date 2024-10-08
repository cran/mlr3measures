#' @title Multiclass AUC Scores
#'
#' @details
#' Multiclass AUC measures.
#'
#' * *AUNU*: AUC of each class against the rest, using the uniform class
#'   distribution. Computes the AUC treating a `c`-dimensional classifier
#'   as `c` two-dimensional 1-vs-rest classifiers, where classes are assumed to have
#'   uniform distribution, in order to have a measure which is independent
#'   of class distribution change (Fawcett 2001).
#' * *AUNP*: AUC of each class against the rest, using the a-priori class
#'   distribution. Computes the AUC treating a `c`-dimensional classifier as `c`
#'   two-dimensional 1-vs-rest classifiers, taking into account the prior probability of
#'   each class (Fawcett 2001).
#' * *AU1U*: AUC of each class against each other, using the uniform class
#'   distribution. Computes something like the AUC of `c(c - 1)` binary classifiers
#'   (all possible pairwise combinations). See Hand (2001) for details.
#' * *AU1P*: AUC of each class against each other, using the a-priori class
#'   distribution. Computes something like AUC of `c(c - 1)` binary classifiers
#'   while considering the a-priori distribution of the classes as suggested
#'   in Ferri (2009). Note we deviate from the definition in
#'   Ferri (2009) by a factor of `c`.
#' * *MU*: Multiclass AUC as defined in Kleinman and Page (2019).
#'   This measure is an average of the pairwise AUCs between all classes.
#'   The measure was tested against the Python implementation by [Ross Kleinman](https://github.com/kleimanr/auc_mu).
#' @templateVar mid mauc_aunu
#' @template classif_template
#'
#' @references
#' `r format_bib("fawcett_2001", "ferri_2009", "hand_2001", "kleinman_2019")`
#'
#' @inheritParams classif_params
#' @template classif_example
#' @export
mauc_aunu = function(truth, prob, na_value = NaN, ...) {
  assert_classif(truth, prob = prob)
  if (length(unique(truth)) != nlevels(truth)) {
    warning("Measure is undefined if there isn't at least one sample per class.")
    return(na_value)
  }

  mean(onevrestauc(prob, truth))
}

#' @rdname mauc_aunu
#' @export
mauc_aunp = function(truth, prob, na_value = NaN, ...) {
  assert_classif(truth, prob = prob)
  if (nlevels(truth) <= 1L) {
    # we multiply AUCs of empty classes with 0. The limit expression actually results
    # in 0 for those, so aunp *is* defined if at least two classes are present.
    warning("Measure is undefined if there isn't at least one sample for at least two classes.")
    return(na_value)
  }

  sum(vapply(levels(truth), function(lvl) mean(truth == lvl), FUN.VALUE = NA_real_) * onevrestauc(prob, truth))
}

#' @rdname mauc_aunu
#' @export
mauc_au1u = function(truth, prob, na_value = NaN, ...) {
  assert_classif(truth, prob = prob)
  if (length(unique(truth)) != nlevels(truth)) {
    warning("Measure is undefined if there isn't at least one sample per class.")
    return(na_value)
  }

  sum(colAUC(prob, truth)) / (nlevels(truth) * (nlevels(truth) - 1L))
}

#' @rdname mauc_aunu
#' @export
mauc_au1p = function(truth, prob, na_value = NaN, ...) {
  assert_classif(truth, prob = prob)
  if (length(unique(truth)) != nlevels(truth)) {
    warning("Measure is undefined if there isn't at least one sample per class.")
    return(na_value)
  }

  m = colAUC(prob, truth)
  weights = table(truth) / length(truth)
  sum(c(m + t(m)) * c(weights)) / (2L * (nlevels(truth) - 1L))
}

#' @rdname mauc_aunu
#' @export
mauc_mu = function(truth, prob, na_value = NaN, ...) {
  assert_classif(truth, prob = prob)

  if (length(unique(truth)) != nlevels(truth)) {
    warning("Measure is undefined if there isn't at least one sample per class.")
    return(na_value)
  }

  n_classes = nlevels(truth)

  # partition matrix
  a = matrix(1, n_classes, n_classes) - diag(n_classes)
  rownames(a) = levels(truth)

  # iterate over all pairwise combinations of classes
  pairwise_combinations = combn(levels(truth), 2, simplify = FALSE)
  aucs = mlr3misc::map_dbl(pairwise_combinations, function(pair) {
    # subset predictions to instances where the true class is one of the two paired classes
    class_i = pair[1]
    preds_i = prob[truth == class_i, , drop = FALSE]
    n_i = nrow(preds_i)
    class_j = pair[2]
    preds_j = prob[truth == class_j, , drop = FALSE]
    n_j = nrow(preds_j)

    # calculate pairwise scores
    temp_preds = rbind(preds_i, preds_j)
    temp_labels = c(rep(0, n_i), rep(1, n_j))
    v = a[class_i, ] - a[class_j, ]
    scores = temp_preds %*% v

    # calculate binary auc
    i = which(temp_labels == 1)
    n_pos = length(i)
    n_neg = length(temp_labels) - n_pos

    r = rank(scores, ties.method = "average")
    (mean(r[i]) - (as.numeric(n_pos) + 1) / 2) / as.numeric(n_neg)
  })

  sum(aucs * 1 / length(aucs))
}

#' @include measures.R
add_measure(mauc_aunu, "Average 1 vs. rest multiclass AUC", "classif", 0, 1, FALSE)
add_measure(mauc_aunp, "Weighted average 1 vs. rest multiclass AUC", "classif", 0, 1, FALSE)
add_measure(mauc_au1u, "Average 1 vs. 1 multiclass AUC", "classif", 0, 1, FALSE)
add_measure(mauc_au1p, "Weighted average 1 vs. 1 multiclass AUC", "classif", 0, 1, FALSE)
add_measure(mauc_mu, "Multiclass mu AUC", "classif", 0, 1, FALSE)

# returns a numeric length nlevel(truth), with one-vs-rest AUC
onevrestauc = function(prob, truth) {
  ntotal = nrow(prob)
  vapply(levels(truth), function(cls) {
    nrest = sum(truth != cls)
    if (nrest == ntotal) {
      # this class has no members. What happened?
      #  - If we were called by mauc_aunu --> this does never happen, because we return(NA) if there are empty classes
      #  - If we were called by mauc_aunp --> this value gets multiplied with 0 and should result in 0
      # therefore we don't want to return Inf here, but a final value that does not matter in the end
      return(0)
    }

    r = rank(c(prob[truth == cls, cls], prob[truth != cls, cls]), ties.method = "average")
    # simplify the following:
    # (sum(r[seq_len(nrest)]) - nrest * (nrest + 1) / 2) / (nrest * (ntotal - nrest))
    (mean(r[seq_len(ntotal - nrest)]) - (ntotal - nrest + 1) / 2) / nrest
  }, FUN.VALUE = NA_real_)
}

# calculates \cite{hand_2001} pairwise asymmetric(!) AUC matrix
colAUC = function(prob, truth) {
  prob = as.matrix(prob) # turn numeric vector to column if necessary
  truth = as.factor(truth) # turn logical to factor

  # conditional_auc[i, j] is A(i | j) as defined in \cite{hand_2001}:
  # "the probability that a randomly drawn member of class j will have a
  # lower estimated probability of belonging to class i than a randomly
  # drawn member of class i"
  conditional_auc = matrix(0, nlevels(truth), nlevels(truth))
  rownames(conditional_auc) = levels(truth)
  colnames(conditional_auc) = levels(truth)
  for (i in levels(truth)) {
    ni = sum(truth == i) # avoid integer overflow
    for (j in levels(truth)) {
      if (i == j) next
      nj = sum(truth == j) # avoid integer overflow
      r = rank(c(prob[truth == i, i], prob[truth == j, i]), ties.method = "average")
      # simplify the following:
      # conditional_auc[i, j] = (sum(r[seq_len(nj)]) - nj * (nj + 1) / 2) / (ni * nj)
      conditional_auc[i, j] = (mean(r[seq_len(ni)]) - (ni + 1) / 2) / nj
    }
  }

  conditional_auc
}
