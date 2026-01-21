# Process Satellite Data and Download Result

Users can request raw satellite data, simple band combinations such as
false colour composites, calculations of simple remote sensing indices
like NDVI, or more advanced processing such as calculation of Leaf area
index (LAI).

## Usage

``` r
dse_sh_process(
  input,
  output,
  evalscript,
  destination,
  ...,
  token = dse_access_token()
)
```

## Arguments

- input:

  A named `list` specifying the input satellite data to be processed
  with `evalscript` to an image. A correctly formatted `list` can be
  created with
  [`dse_sh_prepare_input()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_prepare_.md).

- output:

  A named `list` specifying the how to present the output image, create
  with `evalscript`. A correctly formatted `list` can be created with
  [`dse_sh_prepare_output()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_prepare_.md).

- evalscript:

  A `character` string containing a piece of JavaScript, that will be
  run on the Sentinel Hub server. It is used to translate satellite data
  to pixel data in a georeferenced image. For more information on
  setting up such a script please consult [the API
  documentation](https://docs.sentinel-hub.com/api/latest/evalscript/).
  You can also use
  [`dse_sh_get_custom_script()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_get_custom_script.md)
  to obtain ready-to-go scripts from the SentinelHub repository.

- destination:

  A file name to store the downloaded image.

- ...:

  Ignored

- token:

  For authentication, many of the Dataspace Ecosystem uses an access
  token. Either provide your access token, or obtain one automatically
  with
  [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  (default). Without a valid token you will likely get an "access
  denied" error.

## Value

A `httr2_response` class object containing the location of the
downloaded file at its `destination`.

## Details

Use
[`dse_sh_use_requests_builder()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_use_requests_builder.md)
if you want to use the graphical user interface at [Sentinel Requests
Builder](https://apps.sentinel-hub.com/requests-builder/). to define a
request.

## References

- <https://docs.sentinel-hub.com/api/latest/api/process/>

- <https://apps.sentinel-hub.com/requests-builder/>

- <https://custom-scripts.sentinel-hub.com/>

- <https://github.com/sentinel-hub/custom-scripts>

- <https://docs.sentinel-hub.com/api/latest/evalscript/>

## Examples

``` r
if (interactive() && dse_has_client_info()) {

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
  ## send request and download result:
  dse_sh_process(input, output, evalscript, fl)

  if (requireNamespace("stars")) {
    library(stars)
    enkhuizen <- read_stars(fl) |> suppressWarnings()
    plot(enkhuizen, rgb = 1:3, axes = TRUE, main = "Enkhuizen")
  }
}
```
