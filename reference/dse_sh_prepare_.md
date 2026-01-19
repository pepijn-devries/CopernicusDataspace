# Prepare Input and Output Fields for Sentinel Hub Request

[`dse_sh_process()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_process.md)
requires a named `list` for `input` and `output` settings. The functions
documented here produce those lists required by such a process request.

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
  output_format = "tiff",
  bbox,
  ...
)
```

## Arguments

- bounds:

  A bounding box or geometry (classes `sf::bbox`,
  [`sf::sf`](https://r-spatial.github.io/sf/reference/sf.html),
  [`sf::sfc`](https://r-spatial.github.io/sf/reference/sfc.html))
  defining the boundaries of the output image.

- time_range:

  A `vector` of two date-time values, specifying the time range for
  satellite data to include in the process.

- collection_name:

  A collection name. defaults to `"sentinel-2-l2a"` to ensure you get
  Sentinel-2 L2A data.

- id:

  An identifier. Not documented by the API reference material.

- max_cloud_coverage:

  Maximum cloud cover to be included in the process. Value between 0 and
  100 (default) percent.

- mosaicking_order:

  Sets the order of overlapping tiles from which the output result is
  mosaicked. Should be any of `"default"`, `"mostRecent"`,
  `"leastRecent"`, or `"leastCC"`. See also [the API
  documentation](https://docs.sentinel-hub.com/api/latest/data/sentinel-2-l2a/#mosaickingorder).

- upsampling, downsampling:

  Specify the interpolation technique when the output resolution is
  smaller or larger respectively than the available source data. See
  also [the API
  documentation](https://docs.sentinel-hub.com/api/latest/data/sentinel-2-l2a/#processing-options).

- harmonize_values:

  A `logical` value indicating whether units are harmonised as indicated
  in [the API
  documentation](https://docs.sentinel-hub.com/api/latest/data/sentinel-2-l2a/#harmonize-values).

- ...:

  Ignored

- width, height:

  Size of the output image in pixels. These are ignored if `bbox` is
  specified.

- output_format:

  File format for the output file. Should be one of `"tiff"` (default),
  `"jpeg"`, `"png"`, or `"json"`.

- bbox:

  You can optionally provide a bounding box (i.e., a copy of `bounds`)
  to calculate width and height with fixed aspect ratio. Width will be
  512 be definition, the height is choosen such that it matches with the
  bounding box

## Value

A named `list` that can be used as `input` and `output` argument to
[`dse_sh_process()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_process.md).

## References

- <https://apps.sentinel-hub.com/requests-builder/>

## See also

[`dse_sh_process()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_process.md)

## Examples

``` r
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

library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is TRUE
shape <- st_bbox(c(xmin = 5.261, ymin = 52.680,
                   xmax = 5.319, ymax = 52.715), crs = 4326) |>
           st_as_sfc()
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
