# Process Satellite Data and Download Result

TODO

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

  TODO

- output:

  TODO

- evalscript:

  TODO

- destination:

  A file name to store the downloaded image.

- ...:

  TODO

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
