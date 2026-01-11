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

test_that("Roxygen function produces text", {
  testthat::expect_type({
    CopernicusDataspace:::.roxygen_account()
  }, "character")
})

test_that("Client usage is reported correctly", {
  skip_if_offline()
  skip_if_not(dse_has_client_info())
  expect_true({
    usg <- dse_usage()
    is.data.frame(usg) && all(c("consumed", "remaining") %in% names(usg))
  })
})

test_that("User statistics are reported", {
  skip_if_offline()
  skip_if_not(dse_has_client_info())
  expect_true({
    ustats <- dse_user_statistics()
    is.data.frame(ustats) && all(c("API", "CATALOG") %in% names(ustats))
  })
})