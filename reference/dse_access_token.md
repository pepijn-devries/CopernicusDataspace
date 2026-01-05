# Client Information and Access Token for the Data Space Store API

To regulate server traffic, the Data Space Ecosystem uses user accounts
to regulate and ensure fair usage. These functions will get you a token
and information about your usage.

## Usage

``` r
dse_access_token(
  client_id = dse_client_id(),
  client_secret = dse_client_secret(),
  ...
)

dse_client_id(...)

dse_client_id(...) <- value

dse_client_secret(...)

dse_client_secret(...) <- value

dse_has_client_info(...)
```

## Arguments

- client_id:

  ID of the client registered under your account.

- client_secret:

  Secret provided for the client registered under your account.

- ...:

  Ignored

- value:

  Assignment value for setting `client_id` or `client_secret` as
  environment variable. Once set, it will persist for the remainder of
  the R session.

## Value

In case of `dse_client_id()` and `dse_client_secret()`, you can get (or
set) client details as environment variables. This way, they will
persist throughout your R session.

The function `dse_has_client_info()` returns a `logical` value,
indicating whether client details (id and secret) are available as
environmental variable. Note that if this function returns `TRUE`, it
doesn't guarantee that the details are valid (just that they are
available).

In case of `dse_access_token()` a named `list` is returned, containing
the access token (named `"token"`) and some additional meta information.

## Details

Before you can use most of the Data Space Ecosystem services, you need
to create an account and register as a client. This will let you
retrieve an access token, that can be used for authentication purposes
in API requests. It is also used to manage your usage and rate limiting
(see also
[`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)
and
[`dse_user_statistics()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)).

Note that [Amazon Simple Storage Service
(s3)](https://aws.amazon.com/s3/) has separate authentication
requirements. See
[`dse_s3()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
for details.

### Creating an Account

First step is creating an account. You can create one by visiting the
[login
page](https://identity.dataspace.copernicus.eu/auth/realms/CDSE/account/#/personal-info)
and click "register". Fill out the form and follow the instructions.

### Registering Client

In order to register a client, visit the [Sentinel
Dashboard](https://shapps.dataspace.copernicus.eu/dashboard/) and go to
"User settings". There you will have the option to create an OAuth
client. Follow the instructions, and make sure to safely copy the client
id and secret. The latter is only displayed once. More detailed
instructions are provided by the [API
documentation](https://documentation.dataspace.copernicus.eu/APIs/SentinelHub/Overview/Authentication.html#registering-oauth-client)

### Client Details as Environment Variables

When you share R code, you probably don't want to share your account
details. You can avoid using your `client_id` and `client_secret` in
your script by setting them as environment variable. You can do this
yourself manually by calling `dse_client_id()<-` and
`dse_client_secret()<-` at the start of each session.

You can also define them in your `.Rprofile` file with
`Sys.setenv(CDSE_API_CLIENTID = "<your id>")` and
`Sys.setenv(CDSE_API_CLIENTSECRET = "<your secret>")`. This way, they
are set each time you start a new R session.

The environment variables are used by default by `dse_access_token()`,
so you don't have to specify the client details as arguments.

### Obtain Token and Validity

After completing the previous two steps, your are now set to obtain an
access token with `dse_access_token()`.

Repeatedly requesting an access token may invoke rate limiting measures.
Therefore, this package uses caching to temporarily store the access
token during each R session. Calling `dse_access_token()` will therefore
only contact the server once for a token for each unique combination of
`client_id` and `client_server`. After that, the cached result will be
reused during the session

There is a catch: the token provided by the server is only valid for a
limited time (usually 30 minutes). So, when the token has expired, you
need to wipe the cache. You can do so by calling
`memoise::forget(dse_access_token)` or restarting the R session.

## References

<https://documentation.dataspace.copernicus.eu/APIs/SentinelHub/Overview/Authentication.html>

## See also

[`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)

[`dse_user_statistics()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)

## Examples

``` r
if (interactive() && dse_has_client_info()) {
  token <- dse_access_token()
}
```
