test_that("autotest", {
  learner = mlr3::lrn("clust.hclust")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("Learner properties are respected", {
  task = tsk("usarrests")
  learner = lrn("clust.hclust")
  expect_learner(learner, task)

  # test on multiple paramsets
  parset_list = list(
    list(k = 3L),
    list(k = 5L),
    list(k = 3L, method = "centroid")
  )

  for (i in seq_along(parset_list)) {
    parset = parset_list[[i]]
    learner$param_set$values = parset

    p = suppressWarnings(learner$train(task)$predict(task), classes = "predictionUselessWarning")
    expect_prediction_clust(p)

    if ("complete" %in% learner$properties) {
      expect_prediction_complete(p, learner$predict_type)
    }
    if ("exclusive" %in% learner$properties) {
      expect_prediction_exclusive(p, learner$predict_type)
    }
    if ("fuzzy" %in% learner$properties) {
      expect_prediction_fuzzy(p)
    }
  }
})
