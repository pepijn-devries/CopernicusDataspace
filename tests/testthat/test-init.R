test_that("Methods can be registered", {
  skip_on_cran()
  expect_no_error({
    CopernicusDataspace:::register_all_s3_methods()
  })
})