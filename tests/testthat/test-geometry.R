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

test_that("Returned OData geometries intersect with request", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    bbox <-
      sf::st_bbox(
        c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
        crs = 4326)
    shape <- st_as_sfc(bbox)
    
    result1 <-
      dse_odata_products_request() |>
      st_intersects(bbox) |>
      dplyr::collect()
    result2 <-
      dse_odata_products_request() |>
      st_intersects(shape) |>
      dplyr::collect()
    
    test_fun <- \(z) {
      lapply(z, \(y) {
        coords <-
          do.call(rbind, lapply(y[[1]], unlist))
        coords[,1][coords[,1] < -180] <- -180
        geom <- sf::st_polygon(list(coords)) |>
          sf::st_sfc(crs = 4326)
        sf_use_s2(FALSE)
        st_intersects(shape, geom, sparse = FALSE) |>
          c() |>
          all()
      }) |>
        unlist() |>
        all()
    }
    # Test can only handle polygons, just skip in case of anything else
    if (any(result1$GeoFootprint.type != "Polygon") || 
        any(result2$GeoFootprint.type != "Polygon"))
      return(TRUE)
    test_fun(result1$GeoFootprint.coordinates) &&
      test_fun(result2$GeoFootprint.coordinates) 
  })
})