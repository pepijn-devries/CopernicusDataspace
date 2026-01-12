test_that("OData products can be listed", {
  skip_if_offline()
  skip_on_cran()
  expect_type({
    dse_odata_products(c("Attributes", "Assets", "Locations"))$Id
  }, "character")
})
