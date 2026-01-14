library(stars) |> suppressMessages()

test_that("OData products can be listed", {
  skip_if_offline()
  skip_on_cran()
  expect_type({
    dse_odata_products(expand = c("Attributes", "Assets", "Locations"))$Id
  }, "character")
})

test_that("OData product nodes can be listed", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    nodes <- dse_odata_product_nodes("c8ed8edb-9bef-4717-abfd-1400a57171a4",
                                     recursive = TRUE)
    nrow(nodes) > 1
  })
})

test_that("OData product details can be listed", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    id <- "c8ed8edb-9bef-4717-abfd-1400a57171a4"
    details <- dse_odata_products(Id == "c8ed8edb-9bef-4717-abfd-1400a57171a4")
    details$Id == id
  })
})

test_that("OData quicklook can be downloaded", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    tf <- tempfile(fileext = ".jpg")
    on.exit({ unlink(tf) })
    dse_odata_quicklook("91822f33-b15c-5b60-aa39-6d9f6f5c773b", tf)
    file.exists(tf) && file.size(tf) > 0
  })
})

test_that("OData attributes can be listed", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    attribs <- dse_odata_attributes()
    nrow(attribs) > 0 &&
      all(names(attribs) %in% c("Collection", "AttributeName", "AttributeValueType"))
  })
})

test_that("OData file can be downloaded through https", {
  skip_if_offline()
  skip_if_not(dse_has_client_info())
  skip_on_cran()
  expect_no_error({
    resp <-
      dse_odata_download_path(
        product     = "2f497806-0101-5eea-83fa-c8f68bc56b0c",
        node_path   =
          paste("DEM1_SAR_DTE_90_20101213T034716_20130408T035028_ADS_000000_5033.DEM",
                "Copernicus_DSM_30_S09_00_E026_00", "DEM",
                "Copernicus_DSM_30_S09_00_E026_00_DEM.dt1", sep = "/"),
        destination = tempdir()
      ) |>
      suppressMessages()
    on.exit({unlink(resp$body)})
    sp <- read_stars(resp$body)
  })
})

test_that("OData zipped product can be downloaded through s3", {
  skip_if_offline()
  skip_if_not(dse_has_s3_secret())
  skip_on_cran()
  expect_no_error({
    fn <-
      dse_odata_download(
      dse_odata_products(Name == "S1C_AUX_PP2_V20241204T000000_G20251024T110034.SAFE"),
      destination = tempdir()) |>
      suppressMessages()
    on.exit({ unlink(fn) })
  })
})

test_that("OData zipped product can be downloaded through https", {
  skip_if_offline()
  skip_if_not(dse_has_client_info())
  skip_on_cran()
  expect_no_error({
    resp <-
      dse_odata_download_path(
        product     = "ce4576eb-975b-40ff-8319-e04b00d8d444",
        destination = tempdir()) |>
      suppressMessages()
    unlink(resp$body)
  })
})

test_that("Bursts data can be listed", {
  skip_if_offline()
  skip_on_cran()
  expect_type({
    bursts <- dse_odata_bursts(ParentProductId == "879d445c-2c67-5b30-8589-b1f478904269")
    bursts$Id
  }, "character")
})
