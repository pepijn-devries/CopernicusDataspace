# Setup Amazon Simple Storage Service for the Data Space Ecosystem

using [Amazon Simple Storage Service (s3)](https://aws.amazon.com/s3/)
in the Data Space Ecosystem requires a key and secret. These functions
help you managing these details and setting up an s3 client.

## Usage

``` r
dse_has_s3_secret()

dse_s3_get_key(...)

dse_s3_set_key(value, ...)

dse_s3_get_secret(...)

dse_s3_set_secret(value, ...)
```

## Arguments

- ...:

  Ignored

- value:

  Replacement value for the `s3_key` or `s3_secret`.

## Value

`dse_s3_get_key()` and `dse_s3_get_secret()` will return the requested
s3 details if set as environment variable (see details).

`dse_has_s3_secret()` returns a logical value indicating whether s3
details (key and secret) are set. It will not determine whether the
details are valid.

## Details

Working with s3 in the Data Space Ecosystem requires you to create an
account, then register an s3 key as described below. Note that the
SentinelHub requires a different authentication method. See
[`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
for more details on that.

### Creating an Account

First step is creating an account. You can create one by visiting the
[login
page](https://identity.dataspace.copernicus.eu/auth/realms/CDSE/account/#/personal-info)
and click "register". Fill out the form and follow the instructions.

### Registering a s3 Key

Now that you have an account, you should visit the [s3-credentials
page](https://eodata-s3keysmanager.dataspace.copernicus.eu/panel/s3-credentials),
and log in with your account details. By clicking "add credential", you
can create a new key and secret. Store them in a safe place, as the
secret is only shown once. You can pass the key and secret as `s3_key`
and `s3_secret` arguments to functions requesting them. You can also
store them as environment variables such that they persist throughout
the R session and don't have to be passed as arguments (see below).

### S3 Key and Secret as Environment Variables

When you share R code, you probably don't want to share your account
details. You can avoid using your `s3_key` and `s3_secret` in your
script by setting them as environment variable. You can do this yourself
manually by calling `dse_s3_set_key()` and `dse_s3_set_secret()` at the
start of each session.

You can also define them in your `.Rprofile` file with
`Sys.setenv(CDSE_API_S3ID = "<your key>")` and
`Sys.setenv(CDSE_API_S3SECRET = "<your secret>")`. This way, they are
set each time you start a new R session.

## References

<https://documentation.dataspace.copernicus.eu/APIs/S3.html>

## See also

Other authentication:
[`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md),
[`dse_get_token_details()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_get_token_details.md),
[`dse_set_gdal_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_set_gdal_token.md),
[`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)

Other s3:
[`dse_s3_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_download.md),
[`dse_s3_set_gdal_options()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_set_gdal_options.md),
[`dse_s3_uri_to_vsi()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_uri_to_vsi.md)

Other authentication:
[`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md),
[`dse_get_token_details()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_get_token_details.md),
[`dse_set_gdal_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_set_gdal_token.md),
[`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)

Other s3:
[`dse_s3_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_download.md),
[`dse_s3_set_gdal_options()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_set_gdal_options.md),
[`dse_s3_uri_to_vsi()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_uri_to_vsi.md)

Other authentication:
[`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md),
[`dse_get_token_details()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_get_token_details.md),
[`dse_set_gdal_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_set_gdal_token.md),
[`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)

Other s3:
[`dse_s3_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_download.md),
[`dse_s3_set_gdal_options()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_set_gdal_options.md),
[`dse_s3_uri_to_vsi()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_uri_to_vsi.md)

Other authentication:
[`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md),
[`dse_get_token_details()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_get_token_details.md),
[`dse_set_gdal_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_set_gdal_token.md),
[`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)

Other s3:
[`dse_s3_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_download.md),
[`dse_s3_set_gdal_options()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_set_gdal_options.md),
[`dse_s3_uri_to_vsi()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_uri_to_vsi.md)

Other authentication:
[`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md),
[`dse_get_token_details()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_get_token_details.md),
[`dse_set_gdal_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_set_gdal_token.md),
[`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)

Other s3:
[`dse_s3_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_download.md),
[`dse_s3_set_gdal_options()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_set_gdal_options.md),
[`dse_s3_uri_to_vsi()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_uri_to_vsi.md)
