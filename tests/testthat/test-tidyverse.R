library(dplyr) |> suppressMessages()
library(lubridate) |> suppressMessages() |> suppressWarnings()

test_that("Complex stac request works with tidy verbs", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    d1 <- "2025-01-01 UTC"
    d2 <- "2025-01-02 UTC"
    n <- 5
    result <-
      dse_stac_search_request("sentinel-1-grd") |>
      ## The order of the filters can break the request.
      ## I think this is a problem caused by the parser on the
      ## server. Check with Copernicus
      filter(datetime >= d1 & datetime <= d2) |>
      filter(`sat:orbit_state` == "ascending") |>
      arrange(desc("datetime")) |>
      slice_head(n = n) |>
      select(.data$`properties.sat:orbit_state`, .data$properties.datetime) |>
      select(c("properties.constellation", "properties.view:incidence_angle")) |>
      collect()
    all(as_datetime(result$properties.datetime) >=
          as_datetime(d1)) &&
      all(as_datetime(result$properties.datetime) <=
            as_datetime(d2)) &&
      all(result$`properties.sat:orbit_state` == "ascending") &&
      nrow(result) == n
  })
})

test_that("Complex stac request works with tidy verbs", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    d1 <- "2025-01-01 UTC"
    d2 <- "2025-01-02 UTC"
    n <- 5
    result <-
      dse_odata_products_request() |>
      filter(`ContentDate/Start` >= d1 & `ContentDate/Start` <= d2) |>
      filter(Online == TRUE) |>
      arrange(desc("ContentDate/Start")) |>
      slice_head(n = n) |>
      select(.data$Id, .data$Name) |>
      select(c("ContentDate/Start", "Online")) |>
      collect()
    
    all(as_datetime(result$ContentDate.Start) >=
          as_datetime(d1)) &&
      all(as_datetime(result$ContentDate.Start) <=
            as_datetime(d2)) &&
      all(result$Online == "TRUE") &&
      nrow(result) == n
  })
})

test_that("Tidyverse operators work on sentinel_request", {
  skip_if_offline()
  skip_if_not(dse_has_client_info())
  expect_true({
    result <-
      dse_sh_search_request(
        collection = "sentinel-2-l2a",
        bbox       = c(5.261, 52.680, 5.319, 52.715),
        datetime   = c("2020-01-01 UTC", "2025-01-31 UTC")
      ) |>
      filter(`eo:cloud_cover` <= 10) |>
      slice_head(n = 5) |>
      ## Note that `select` is always merged with
      ## ["id", "type", "geometry", "bbox", "links", "assets", "properties.datetime"]
      ## as per API specs
      select(`properties.eo:cloud_cover`,
             `properties.proj:geometry.type`) |>
      collect()
    nrow(result) == 5 &&
      all(as.numeric(result$`properties.eo:cloud_cover`) <= 10)
  })
})

test_that("Specifying multiple slices, produces warning", {
  expect_warning({
    dse_sh_search_request(
      collection = "sentinel-2-l2a",
      bbox       = c(5.261, 52.680, 5.319, 52.715),
      datetime   = c("2020-01-01 UTC", "2025-01-31 UTC")
    ) |>
      slice_head(n=5) |>
      slice_head(n=3)
  }, "Previously")
})