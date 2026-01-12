library(sf)
library(dplyr)

test_that("Returned STAC geometries intersect with request" {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    bbox <-
      sf::st_bbox(
        c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
        crs = 4326)
    shape <- st_as_sfc(bbox)
    
    result <-
      dse_stac_search_request() |>
      st_intersects(bbox) |>
      dplyr::collect()
    
    result$bbox |> lapply(\(y) {
      y <- unlist(y)
      names(y) <- c("xmin", "ymin", "xmax", "ymax")
      y <- st_bbox(y, crs = 4326)
      test1 <-
        st_intersects(y, bbox, sparse = FALSE) |>
        c() |>
        all()
      test2 <-
        st_intersects(y, shape, sparse = FALSE) |>
        c() |>
        all()
      test1 && test2
    }) |>
      unlist() |>
      all()
  })
})