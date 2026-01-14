# Download Data Space Ecosystem Products Through OData API

Use
[`dse_odata_products()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md)
or
[`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md),
[`dse_odata_bursts()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md)
or
[`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md)
to find a product or burst information. Use this function to download
the product(s) or burst information.

## Usage

``` r
dse_odata_download(
  request,
  destination,
  ...,
  s3_key = dse_s3_key(),
  s3_secret = dse_s3_secret()
)
```

## Arguments

- request:

  A request containing products or burst data that you wish to download.
  Use
  [`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md)
  or
  [`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md)
  to formulate product or burst specifications.

- destination:

  A `character` string specifying the directory path, where to store
  downloaded products

- ...:

  Arguments passed to
  [`dse_s3()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md).

- s3_key, s3_secret:

  The s3 key and secret registered under your Data Space Ecosystem
  account

## Value

A vector of downloaded file names stored at `destination`

## Examples

``` r
if (interactive() && dse_has_s3_secret()) {
  dse_odata_download(
    dse_odata_products(Name == "S1C_AUX_PP2_V20241204T000000_G20251024T110034.SAFE"),
    destination = tempdir())
  dse_odata_download(
    dse_odata_products(
      Name ==
        "S1A_IW_OCN__2SDH_20250707T210608_20250707T210625_059983_07739B_893E.SAFE"),
    destination = tempdir())
  dse_odata_download(
    dse_odata_products(
      Id %in% c("c8ed8edb-9bef-4717-abfd-1400a57171a4",
                "86288a07-560c-364f-b8ce-669d95f06fa0")),
    destination = tempdir())
}
```
