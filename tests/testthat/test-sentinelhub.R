library(stars) |> suppressMessages()
library(lubridate) |> suppressMessages()
library(dplyr) |> suppressMessages()

test_that("Custum Eval Scripts can be listed", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    cs <- dse_sh_custom_scripts()
    nrow(cs) > 0 && typeof(cs$relUrl) == "character"
  })
})

test_that("Custom Eval Script can be retrieved", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    dse_sh_get_custom_script("/sentinel-2/true_color/") |>
      startsWith("//VERSION=3")
  })
})

test_that("Queryables for sentinel hub collection can be obtained", {
  skip_if_offline()
  skip_if_not(dse_has_client_info())
  skip_on_cran()
  expect_true({
    qt <- dse_sh_queryables("sentinel-2-l1c")
    is.list(qt) && length(qt) > 1
  })
})

test_that("SentinelHub Collections can be listed", {
  skip_if_offline()
  skip_on_cran()
  expect_true({
    cl <- dse_sh_collections()
    nrow(cl) > 0 && typeof(cl$id) == "character"
  })
})

test_that("Sentinel Hub request produces proper map", {
  skip_if_offline()
  skip_on_cran()
  skip_if_not(dse_has_client_info())
  skip_if({
    usage <- dse_usage()
    ratio <-
      usage[["remaining"]] |> as.numeric() |> sum() /
      usage[["configuration"]] |> as.numeric() |> sum()
    # Skip if half my monthly quota is already consumed
    ratio < 0.5
  })
  expect_true({
    bounds <- c(5.261, 52.680, 5.319, 52.715)
    
    ## prepare input data
    input <-
      dse_sh_prepare_input(
        bounds = bounds,
        time_range = c("2025-06-01 UTC", "2025-07-01 UTC")
      )
    
    ## prepare ouput format
    output <- dse_sh_prepare_output(bbox = bounds)
    
    ## retrieve processing script
    evalscript <- dse_sh_get_custom_script("/sentinel-2/l2a_optimized/")
    
    fl <- tempfile(fileext = ".tiff")
    on.exit({unlink(fl)})
    ## send request and download result:
    dse_sh_process(input, output, evalscript, fl)
    
    enkhuizen <- read_stars(fl) |> suppressWarnings()
    all(dim(enkhuizen) == c(512, 508, 4)) &&
      any(!is.na(enkhuizen[[1]]))
  })
})

test_that("Sentinel Hub request produces proper map with Requests Builder", {
  skip_if_offline()
  skip_on_cran()
  skip_if_not(dse_has_client_info())
  skip_if({
    usage <- dse_usage()
    ratio <-
      usage[["remaining"]] |> as.numeric() |> sum() /
      usage[["configuration"]] |> as.numeric() |> sum()
    # Skip if half my monthly quota is already consumed
    ratio < 0.5
  })
  expect_true({

    requests_builder <-
      system.file("requests-builder.txt", package = "CopernicusDataspace") |>
      readLines(warn = FALSE) |>
      paste(collapse = "\n")
    
    fl <- tempfile(fileext = ".tiff")
    dse_sh_use_requests_builder(requests_builder, destination = fl)
    on.exit({unlink(fl)})

    enkhuizen <- read_stars(fl) |> suppressWarnings()
    all(dim(enkhuizen) == c(512, 509, 3)) &&
      any(!is.na(enkhuizen[[1]]))
  })
})

test_that("SentinelHub features are correctly listed", {
  skip_if_offline()
  skip_on_cran()
  skip_if_not(dse_has_client_info())
  expect_true({
    rng <- as_datetime(c("2025-01-01 UTC", "2025-01-07 UTC"))
    features <-
      dse_sh_features(
        collection = "sentinel-2-l2a",
        bbox       = c(5.261, 52.680, 5.319, 52.715),
        datetime   = rng)
    
    dt <-
      features$properties.datetime |>
      as_datetime()
    all(between(dt, rng[[1]], rng[[2]])) &&
      all(features$collection == "sentinel-2-l2a")
  })
})

test_that("SentinelHub search produces correct results", {
  skip_if_offline()
  skip_on_cran()
  skip_if_not(dse_has_client_info())
  expect_true({
    dt <- as_datetime(c("2025-01-01 UTC", "2025-01-31 UTC"))
    result <-
      dse_sh_search_request(
        collection = "sentinel-2-l2a",
        bbox       = c(5.261, 52.680, 5.319, 52.715),
        datetime   = dt
      ) |>
      filter(`eo:cloud_cover` <= 10) |>
      collect()
    
    all(between(
      as_datetime(result$properties.datetime),
      dt[[1]], dt[[2]])) &&
      all(result$`properties.eo:cloud_cover` <= 10)
  })
})
