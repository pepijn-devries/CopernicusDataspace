test_that("Invalid URI does not start S3 download", {
  expect_error({
    dse_s3_download("foobar", tempdir())
  }, "Not a valid S3 URI")
})

test_that("Non existing collections err", {
  skip_if_offline()
  expect_error({
    dse_stac_collections("foobar")
  }, "NotFoundError")
})
