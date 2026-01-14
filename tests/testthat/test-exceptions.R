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

test_that("Non existing stac filter argument will produce warning", {
  skip_if_offline()
  expect_warning({
    dse_stac_search_request(foobar = NA)
  }, "Ignoring unknown filter arguments")
})

test_that("Files cannot be downloaded via STAC when authentication is missing", {
  skip_if_offline()
  expect_error({
    fn <-
      dse_stac_download(
        id = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
        asset = "B01",
        destination = tempdir(),
        s3_key = "",
        s3_secret = "",
        token = NULL
      )
  }, "Need authentication")
})

test_that("Quicklook cannot be downloaded if it doesn't exist", {
  skip_if_offline()
  skip_on_cran()
  expect_error({
    dse_odata_quicklook( "ce4576eb-975b-40ff-8319-e04b00d8d444", tempfile())
  }, "does not have a 'quicklook'")
})