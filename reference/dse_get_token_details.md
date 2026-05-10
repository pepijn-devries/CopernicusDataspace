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

## Examples

``` r
if (interactive() && dse_has_client_info()) {
  dse_get_token_details()
}
```
