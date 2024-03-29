test_that("transect_phys works", {

  expect_message(transect_phys("hi"))
  expect_message(transect_phys(faithful))

  test <- transect_phys(test_transect) # manual download
  expect_equal(ncol(test), 6)
  expect_equal(typeof(test[[2]]), "double")
  expect_equal(names(test)[2], "frequency")

  skip_if_offline()

  test_raw <- download_transect(4492) # normal database
  test <- transect_phys(test_raw)
  expect_equal(ncol(test), 6)
  expect_equal(typeof(test[[2]]), "double")
  expect_equal(names(test)[2], "frequency")

  test_raw <- download_transect(7025) # custom database
  test <- transect_phys(test_raw)
  expect_equal(ncol(test), 6)
  expect_equal(typeof(test[[2]]), "double")
  expect_equal(names(test)[2], "frequency")

  test_raw <- download_transect(6444) # includes omernik
  test <- transect_phys(test_raw)
  expect_equal(ncol(test), 6)
  expect_equal(typeof(test[[2]]), "double")
  expect_equal(names(test)[2], "frequency")

})
