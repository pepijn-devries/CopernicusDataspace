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
