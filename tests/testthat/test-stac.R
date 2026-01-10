test_that("STAC collections are obtained", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    col <- dse_stac_collections("sentinel-2-l2a")
    col$id == "sentinel-2-l2a"
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

