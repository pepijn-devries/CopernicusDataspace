# Setup Amazon Simple Storage Service for the Data Space Ecosystem

using [Amazon Simple Storage Service (s3)](https://aws.amazon.com/s3/)
in the Data Space Ecosystem requires a key and secret. These functions
help you managing these details and setting up an s3 client.

## Usage

``` r
dse_s3(
  region = "us-east-1",
  ...,
  s3_key = dse_s3_key(),
  s3_secret = dse_s3_secret()
)

dse_has_s3_secret()

dse_s3_key(...)

dse_s3_key(...) <- value

dse_s3_secret(...)

dse_s3_secret(...) <- value
```

## Arguments

- region:

  [AWS
  Region](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)
  used in instantiating the client

- ...:

  Ignored

- s3_key, s3_secret:

  The s3 key and secret registered under your Data Space Ecosystem
  account

- value:

  Replacement value for the `s3_key` or `s3_secret`.

## Value

`dse_s3()` returns a client for the Data Space Ecosystem s3 service. For
more details see
[`paws::s3()`](https://paws-r.r-universe.dev/paws/reference/s3.html).

`dse_s3_key()` and `dse_s3_secret()` will return the requested s3
details if set as environment variable (see details).

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
manually by calling `dse_s3_key()<-` and `dse_s3_secret()<-` at the
start of each session.

You can also define them in your `.Rprofile` file with
`Sys.setenv(CDSE_API_S3ID = "<your key>")` and
`Sys.setenv(CDSE_API_S3SECRET = "<your secret>")`. This way, they are
set each time you start a new R session.

## References

<https://documentation.dataspace.copernicus.eu/APIs/S3.html>

## Examples

``` r
if (interactive() && dse_has_s3_secret()) {
  my_s3 <- dse_s3()
  my_s3$get_object(Bucket = "", Key = "") |> summary()
}
```
