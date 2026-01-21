# Using SentinelHub

## Generic Workflow

TODO

## Data Exploration

``` r
library(CopernicusDataspace)
library(stars)
#> Loading required package: abind
#> Loading required package: sf
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is TRUE
```

## Data Downloading

TODO

``` r
if (dse_has_client_info()) {
  bounds <- c(5.261, 52.680, 5.319, 52.715)

  ## prepare input data:
  input <-
    dse_sh_prepare_input(
      bounds = bounds,
      time_range = c("2025-06-01 UTC", "2025-07-01 UTC")
    )

  ## prepare ouput format:
  output <- dse_sh_prepare_output(bbox = bounds)

  ## retrieve processing script:
  evalscript <- dse_sh_get_custom_script("/sentinel-2/l2a_optimized/")

  ## destination file:
  fl <- tempfile(fileext = ".tiff")
  
  ## send request and download result:
  dse_sh_process(input, output, evalscript, fl)
}
#> <httr2_response>
#> POST https://sh.dataspace.copernicus.eu/api/v1/process
#> Status: 200 OK
#> Content-Type: image/tiff
#> Body: On disk /tmp/RtmpyEcptJ/file222f324e5b25.tiff (484658 bytes)
```

## Eval Scripts

[Eval Scripts](https://docs.sentinel-hub.com/api/latest/evalscript/)
TODO

``` r
if (dse_has_client_info()) {
  evalscript <-
    dse_sh_get_custom_script("/sentinel-2/simple_water_bodies_mapping-swbm/")
  
  ## destination file:
  fl_waterbody <- tempfile(fileext = ".tiff")
  
  ## send request and download result:
  dse_sh_process(input, output, evalscript, fl_waterbody)

  ## read and plot result:
  waterbodies <- read_stars(fl_waterbody) |> suppressWarnings()
  plot(waterbodies, rgb = 1:3, main = "Water bodies")
}
```

![](SentinelHub_files/figure-html/water-bodies-1.png)

This maps shows water bodies in blue. In this particular case, it does a
decent job, however some greenhouses show up as water bodies (i.e.,
false-positives). It must be noted that here the script was just used as
is, and might need some tweaking of parameters for better performance.

``` r
if (dse_has_client_info()) {
  evalscript <-
    dse_sh_get_custom_script("/sentinel-2/land_use_with_linear_discriminant_analysis/")
  
  ## destination file:
  fl_landuse <- tempfile(fileext = ".tiff")
  
  ## send request and download result:
  dse_sh_process(input, output, evalscript, fl_landuse)

  ## read and plot result:
  landuse <- read_stars(fl_landuse) |> suppressWarnings()
  plot(landuse, rgb = 1:3, main = "Land use")
}
```

![](SentinelHub_files/figure-html/land-use-1.png)
