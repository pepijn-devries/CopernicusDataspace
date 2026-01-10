test_that("Access token can be obtained", {
  skip_if_offline()
  skip_if_not(dse_has_client_info())
  expect_no_error({
    token <- dse_access_token()
  })
})

test_that("Access S3 client can be initiated", {
  skip_if_offline()
  skip_if_not(dse_has_s3_secret())
  expect_no_error({
    ds3 <- dse_s3()
    ds3$get_bucket_location("")
  })
})