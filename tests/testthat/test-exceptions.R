library(sf) |> suppressMessages()

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
        asset_id = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
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

test_that("Invalid OData request produce meaningfull errors", {
  skip_if_offline()
  skip_on_cran()
  expect_error({
    dse_odata_products(foo == "bar")
  }, "Invalid field")
})

test_that("OData files cannot be downloaded without token", {
  skip_if_offline()
  skip_on_cran()
  expect_error({
    dse_odata_download_path(
      product     = "ce4576eb-975b-40ff-8319-e04b00d8d444",
      destination = tempdir(),
      token       = NULL)
  }, "Ensure that you have specified a token")
})

test_that("`node_path` only works if it has one element", {
  skip_if_offline()
  skip_on_cran()
  expect_error({
    dse_odata_product_nodes("c8ed8edb-9bef-4717-abfd-1400a57171a4",
                            node_path = c("", ""))
  }, "should only have one element")
})

test_that("st_intersects warns when adding multiple bboxes to stac request", {
  expect_warning({
    bbox <-
      st_bbox(
        c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
        crs = 4326)

    dse_stac_search_request() |>
      st_intersects(bbox) |>
      st_intersects(bbox)
  }, "Replacing previously defined bbox")
})

test_that("st_intersects warns when adding bbox after shape to stac request", {
  expect_warning({
    bbox <-
      st_bbox(
        c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
        crs = 4326)
    shape <- st_as_sfc(bbox)
    
    dse_stac_search_request() |>
      st_intersects(shape) |>
      st_intersects(bbox) |>
      suppressMessages()
  }, "mutually exclusive")
})

test_that("st_intersects warns when adding shape after bbox to stac request", {
  expect_warning({
    bbox <-
      st_bbox(
        c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
        crs = 4326)
    shape <- st_as_sfc(bbox)
    
    dse_stac_search_request() |>
      st_intersects(bbox) |>
      st_intersects(shape) |>
      suppressMessages()
  }, "mutually exclusive")
})

test_that("Non existing assets produce error on STAC", {
  skip_if_offline()
  skip_on_cran()
  expect_error({
    dse_stac_download("foo", "bar", "foobar")
  }, "Asset not found")
})

test_that("Warning is thrown when collection id cannot be guessed", {
  expect_warning({
    dse_stac_guess_collection("foobar")
  }, "Couldn't guess")
})