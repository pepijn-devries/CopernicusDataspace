test_that("Access token can be obtained", {
  skip_if_offline()
  skip_if_not(dse_has_client_info())
  expect_no_error({
    token <- dse_access_token()
  })
})

test_that("Public access token can be obtained", {
  skip_if_offline()
  skip_if_not(dse_has_password())
  expect_no_error({
    token <- dse_public_access_token()
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

test_that("GDAL token can be set", {
  skip_if_not(dse_has_client_info())
  expect_true({
    dse_set_gdal_token()
  })
})

test_that("Token can be decrypted", {
  skip_if_offline()
  skip_if_not(dse_has_client_info())
  skip_if_not_installed("jose")
  expect_equal({
    token_info <-
      dse_access_token() |>
      dse_get_token_details()
    token_info$header$alg
  }, "RS256")
})

test_that("Secrets can be set", {
  skip_if_offline()
  skip_if_not(dse_has_password())
  skip_if_not(dse_has_client_info())
  skip_if_not(dse_has_s3_secret())
  expect_no_error({
    dse_set_username(dse_get_username())
    dse_set_password(dse_get_password())
    dse_set_client_id(dse_get_client_id())
    dse_s3_set_key(dse_s3_get_key())
    dse_s3_set_secret(dse_s3_get_secret())
  })
})