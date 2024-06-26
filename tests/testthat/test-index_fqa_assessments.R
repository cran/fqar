test_that("index_fqa_assessments works", {

  expect_error(index_fqa_assessments(1.5))
  expect_error(index_fqa_assessments("hi"))

  empty_output <- index_fqa_assessments(-40000)
  expect_equal(nrow(empty_output), 0)
  expect_equal(ncol(empty_output), 5)
  expect_equal(memoise::has_cache(index_fqa_assessments_internal)(-40000), FALSE)

  assessments <- suppressMessages(index_fqa_assessments(2))

  expect_equal(ncol(assessments), 5)
  expect_equal(names(assessments),
               c("id", "assessment", "date", "site", "practitioner"))
  expect_equal(class(assessments[[1]]), "numeric")
  expect_equal(class(assessments[[3]]), "Date")
  expect_equal(class(assessments[[5]]), "character")
})
