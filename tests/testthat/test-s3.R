test_that("URI to s3 works", {
  expect_true({
    startsWith(
      dse_s3_uri_to_vsi("s3://"),
      "/vsis3"
    )
  })
})

test_that("GDAL s3 authentication can be set up", {
  skip_if_not(dse_has_s3_secret())
  expect_true({
    dse_s3_set_gdal_options()
  })
})