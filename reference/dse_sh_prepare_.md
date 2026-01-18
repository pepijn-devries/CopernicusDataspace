# Prepare Input and Output Fields for Sentinel Hub Request

TODO

## Usage

``` r
dse_sh_prepare_input(
  bounds,
  time_range,
  collection_name = "sentinel-2-l2a",
  id = NA,
  max_cloud_coverage = 100,
  mosaicking_order = "default",
  upsampling = "default",
  downsampling = "default",
  harmonize_values = FALSE,
  ...
)

dse_sh_prepare_output(
  width = 512,
  height = 512,
  output_identifier = "default",
  output_format = "image/tiff",
  bbox,
  ...
)
```

## Arguments

- bounds:

  TODO

- time_range:

  TODO

- collection_name:

  TODO

- id:

  TODO

- max_cloud_coverage:

  Maximum cloud cover to be included in the process. Value between 0 and
  100 (default) percent.

- mosaicking_order:

  TODO

- upsampling:

  TODO

- downsampling:

  TODO

- harmonize_values:

  TODO

- ...:

  TODO

- width:

  TODO

- height:

  TODO

- output_identifier:

  TODO

- output_format:

  TODO

- bbox:

  description

## Value

TODO

## References

- <https://apps.sentinel-hub.com/requests-builder/>

## See also

[`dse_sh_process()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_process.md)

## Examples

``` r
# TODO
library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is TRUE

shape <- st_bbox(c(xmin = 5.261, ymin = 52.680,
                   xmax = 5.319, ymax = 52.715), crs = 4326) |>
           st_as_sfc()
dse_sh_prepare_input(
  bounds = c(5.261, 52.680, 5.319, 52.715),
  time_range = c("2025-06-01 UTC", "2025-07-01 UTC")
)
#> $bounds
#> $bounds$bbox
#> [1]  5.261 52.680  5.319 52.715
#> 
#> 
#> $data
#> $data[[1]]
#> $data[[1]]$type
#> [1] "sentinel-2-l2a"
#> 
#> $data[[1]]$dataFilter
#> $data[[1]]$dataFilter$timeRange
#> $data[[1]]$dataFilter$timeRange$from
#> [1] "2025-06-01T00:00:00+0000"
#> 
#> $data[[1]]$dataFilter$timeRange$to
#> [1] "2025-07-01T00:00:00+0000"
#> 
#> 
#> $data[[1]]$dataFilter$maxCloudCoverage
#> [1] 100
#> 
#> 
#> $data[[1]]$processing
#> $data[[1]]$processing$harmonizeValues
#> [1] FALSE
#> 
#> 
#> 
#> 
dse_sh_prepare_input(
  bounds = shape,
  time_range = c("2025-06-01 UTC", "2025-07-01 UTC")
)
#> $bounds
#> $bounds$geometry
#> NULL
#> 
#> 
#> $data
#> $data[[1]]
#> $data[[1]]$type
#> [1] "sentinel-2-l2a"
#> 
#> $data[[1]]$dataFilter
#> $data[[1]]$dataFilter$timeRange
#> $data[[1]]$dataFilter$timeRange$from
#> [1] "2025-06-01T00:00:00+0000"
#> 
#> $data[[1]]$dataFilter$timeRange$to
#> [1] "2025-07-01T00:00:00+0000"
#> 
#> 
#> $data[[1]]$dataFilter$maxCloudCoverage
#> [1] 100
#> 
#> 
#> $data[[1]]$processing
#> $data[[1]]$processing$harmonizeValues
#> [1] FALSE
#> 
#> 
#> 
#> 

dse_sh_prepare_output(bbox = shape)
#> $width
#> [1] 512
#> 
#> $height
#> [1] 509.6204
#> 
#> $responses
#> $responses[[1]]
#> $responses[[1]]$identifier
#> [1] "default"
#> 
#> $responses[[1]]$format
#> $responses[[1]]$format$type
#> [1] "image/tiff"
#> 
#> 
#> 
#> 
```
