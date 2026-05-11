# Decode Access Token

This function decodes an access token and returns a named `list` with
information from the token.

## Usage

``` r
dse_get_token_details(token = dse_access_token())
```

## Arguments

- token:

  A token obtained with
  [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  or
  [`dse_public_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md).

## Value

A named `list` with token info

## See also

Other authentication:
[`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md),
[`dse_has_s3_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md),
[`dse_set_gdal_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_set_gdal_token.md),
[`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)

## Examples

``` r
if (interactive() && dse_has_client_info()) {
  dse_get_token_details()
}
```
