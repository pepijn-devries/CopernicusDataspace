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

  TODO

- ...:

  TODO

- token:

  For authentication, many of the Dataspace Ecosystem uses an access
  token. Either provide your access token, or obtain one automatically
  with
  [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  (default). Without a valid token you will likely get an "access
  denied" error.

## Examples

``` r
input <- list(
  bounds = list(bbox = c(5.261, 52.680, 5.319, 52.715)),
  data = list(
    list(
      dataFilter = list(
        timeRange = list(from = "2025-06-21T00:00:00Z", to = "2025-07-21T00:00:00Z")
      ),
      type = "sentinel-2-l2a"
    )
  )
)
output <- list(
  width = 512, height = 515.09, responses = list(
    list(
      identifier = "default",
      format = list(type = "image/tiff")
    )
  )
)

evalscript <- paste(
  "//VERSION=3",
  "function setup() {",
  "return {",
  "input: [\"B02\", \"B03\", \"B04\"],",
  "output: { bands: 3 }",
  "};",
  "}",
  "function evaluatePixel(sample) {",
  "return [2.5 * sample.B04, 2.5 * sample.B03, 2.5 * sample.B02];",
  "}",
  sep = "\n")
fl <- tempfile(fileext = ".tiff")
if (interactive() && dse_has_client_info()) {
  dse_sh_process(input, output, evalscript, fl) #TODO
}
```
