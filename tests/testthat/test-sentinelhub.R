library(stars) |> suppressMessages()

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