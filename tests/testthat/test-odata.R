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