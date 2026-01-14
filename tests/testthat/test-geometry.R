library(sf) |> suppressMessages()
library(dplyr) |> suppressMessages()

test_that("Returned STAC geometries intersect with request", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    bbox <-
      sf::st_bbox(
        c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
        crs = 4326)
    shape <- st_as_sfc(bbox)
    
    result1 <-
      dse_stac_search_request() |>
      st_intersects(bbox) |>
      dplyr::collect()
    result2 <-
      dse_stac_search_request() |>
      st_intersects(shape) |>
      dplyr::collect()
    
    test_fun <- \(z) {
      lapply(z, \(y) {
        y <- unlist(y)
        names(y) <- c("xmin", "ymin", "xmax", "ymax")
        y <- st_bbox(y, crs = 4326) |> st_as_sfc()
        st_intersects(shape, y, sparse = FALSE) |>
          c() |>
          all()
      }) |>
        unlist() |>
        all()
    }
    test_fun(result1$bbox) && test_fun(result2$bbox) 
  })
})