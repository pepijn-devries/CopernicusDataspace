library(dplyr) |> suppressMessages()
library(stars) |> suppressMessages()

test_that("STAC collections are obtained", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    col <- dse_stac_collections("sentinel-2-l2a")
    col$id == "sentinel-2-l2a"
  })
})

test_that("STAC client info is obtained", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    cl <- dse_stac_client()
    cl$id == "cdse-stac"
  })
})

test_that("STAC queryables are obtained", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    qr <- dse_stac_queryables("sentinel-1-grd")
    qr$properties$id$type == "string"
  })
})

test_that("STAC collections can be searched", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    result <-
      dse_stac_search_request("sentinel-1-grd") |>
      filter(`sat:orbit_state` == "ascending") |>
      arrange("id") |>
      collect()
    all(result$`properties.sat:orbit_state` == "ascending")
  })
})

test_that("Files can be downloaded via STAC S3", {
  skip_if_offline()
  skip_if_not(dse_has_s3_secret())
  expect_no_error({
    fn <-
      dse_stac_download(
        id = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
        asset = "B01",
        destination = tempdir()
      )
    tile <- read_stars(fn)
  })
})

test_that("Files can be downloaded via STAC https", {
  skip_if_offline()
  skip_if_not(dse_has_client_info())
  expect_no_error({
    fn <-
      dse_stac_download(
        id = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
        asset = "B01",
        s3_key = "", s3_secret = "",
        destination = tempdir()
      )
    tile <- read_stars(fn)
  })
})