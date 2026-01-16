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
