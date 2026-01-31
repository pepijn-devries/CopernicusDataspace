#' @include tidyverse.R
NULL

.odata_url <- "https://catalogue.dataspace.copernicus.eu/odata/v1"
.odata_s3_endpoint <- "https://eodata.dataspace.copernicus.eu"

## Template used by roxygen for documentation:
.roxygen_account <- function() {
  paste(
    "## Creating an Account",
    "First step is creating an account. You can create one by visiting the",
    "[login page](https://identity.dataspace.copernicus.eu/auth/realms/CDSE/account/#/personal-info)",
    "and click \"register\". Fill out the form and follow the instructions.",
    sep = "\n"
  )
}

.dse_access_token <- function(client_id     = dse_client_id(),
                              client_secret = dse_client_secret(), ...) {
  access_token <-
    "https://identity.dataspace.copernicus.eu/auth/realms/CDSE/protocol/openid-connect/token" |>
    httr2::request() |>
    httr2::req_body_form(
      client_id = client_id,
      client_secret = client_secret,
      grant_type = "client_credentials"
    ) |>
    httr2::req_method("POST") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Client Information and Access Token for the Data Space Store API
#' 
#' To regulate server traffic, the Data Space Ecosystem uses user accounts to regulate
#' and ensure fair usage. These functions will get you a token and information about
#' your usage.
#' 
#' Before you can use most of the Data Space Ecosystem services, you need to create
#' an account and register as a client. This will let you retrieve an access token,
#' that can be used for authentication purposes in API requests. It is also used to
#' manage your usage and rate limiting (see also [dse_usage()] and
#' [dse_user_statistics()]).
#' 
#' Note that [Amazon Simple Storage Service (s3)](https://aws.amazon.com/s3/)
#' has separate authentication requirements. See [dse_s3()] for details.
#' 
#' `r .roxygen_account()`
#' 
#' ## Registering Client
#' In order to register a client, visit the
#' [Sentinel Dashboard](https://shapps.dataspace.copernicus.eu/dashboard/) and
#' go to "User settings". There you will have the option to create an OAuth client.
#' Follow the instructions, and make sure to safely copy the client id and secret.
#' The latter is only displayed once. More detailed instructions are provided by the
#' [API documentation](https://documentation.dataspace.copernicus.eu/APIs/SentinelHub/Overview/Authentication.html#registering-oauth-client)
#' 
#' ## Client Details as Environment Variables
#' When you share R code, you probably don't want to share your account details.
#' You can avoid using your `client_id` and `client_secret` in your script by
#' setting them as environment variable. You can do this yourself manually by
#' calling `dse_client_id()<-` and `dse_client_secret()<-` at the start of each session.
#' 
#' You can also define them in your `.Rprofile` file with
#' `Sys.setenv(CDSE_API_CLIENTID = "<your id>")` and
#' `Sys.setenv(CDSE_API_CLIENTSECRET = "<your secret>")`. This way,
#' they are set each time you start a new R session.
#' 
#' The environment variables are used by default by `dse_access_token()`, so you
#' don't have to specify the client details as arguments.
#' 
#' ## Obtain Token and Validity
#' After completing the previous two steps, your are now set to obtain an access
#' token with `dse_access_token()`.
#' 
#' Repeatedly requesting an access token may invoke rate limiting measures.
#' Therefore, this package uses caching to temporarily store the access token
#' during each R session. Calling `dse_access_token()` will therefore only
#' contact the server once for a token for each unique combination of `client_id`
#' and `client_server`. After that, the cached result will be reused during the session
#' 
#' There is a catch: the token provided by the server is only valid for a limited
#' time (usually 30 minutes). So, when the token has expired, you need to wipe the
#' cache. You can do so by calling `memoise::forget(dse_access_token)` or restarting
#' the R session.
#' @param client_id ID of the client registered under your account.
#' @param client_secret Secret provided for the client registered under your account.
#' @param value Assignment value for setting `client_id` or `client_secret` as
#' environment variable. Once set, it will persist for the remainder of the
#' R session.
#' @param ... Ignored
#' @seealso [dse_usage()]
#' @seealso [dse_user_statistics()]
#' @references <https://documentation.dataspace.copernicus.eu/APIs/SentinelHub/Overview/Authentication.html>
#' @returns In case of `dse_client_id()` and `dse_client_secret()`, you can get (or
#' set) client details as environment variables. This way, they will persist
#' throughout your R session.
#' 
#' The function `dse_has_client_info()` returns a `logical` value, indicating
#' whether client details (id and secret) are available as environmental variable.
#' Note that if this function returns `TRUE`, it doesn't guarantee that the details
#' are valid (just that they are available).
#' 
#' In case of `dse_access_token()` a named `list` is returned, containing the
#' access token (named `"token"`) and some additional meta information.
#' @examples
#' if (interactive() && dse_has_client_info()) {
#'   token <- dse_access_token()
#' }
#' @export
dse_access_token <- memoise::memoise(.dse_access_token) # Using memoise to avoid rate limiting errors

#' @rdname dse_access_token
#' @export
dse_client_id <- function(...) {
  Sys.getenv("CDSE_API_CLIENTID")
}

#' @rdname dse_access_token
#' @export
`dse_client_id<-` <- function(..., value) {
  Sys.setenv(CDSE_API_CLIENTID = as.character(value))
}

#' @rdname dse_access_token
#' @export
dse_client_secret <- function(...) {
  Sys.getenv("CDSE_API_CLIENTSECRET")
}

#' @rdname dse_access_token
#' @export
`dse_client_secret<-` <- function(..., value) {
  Sys.setenv(CDSE_API_CLIENTSECRET = as.character(value))
}

#' @rdname dse_access_token
#' @export
dse_has_client_info <- function(...) {
  dse_client_id() != "" && dse_client_secret() != ""
}

#' Setup Amazon Simple Storage Service for the Data Space Ecosystem
#' 
#' using [Amazon Simple Storage Service (s3)](https://aws.amazon.com/s3/) in the
#' Data Space Ecosystem requires a key and secret. These functions help you managing
#' these details and setting up an s3 client.
#' 
#' Working with s3 in the Data Space Ecosystem requires you to create an account,
#' then register an s3 key as described below. Note that the SentinelHub requires
#' a different authentication method. See [dse_access_token()] for more details on that.
#' 
#' `r .roxygen_account()`
#' 
#' ## Registering a s3 Key
#' Now that you have an account, you should visit the
#' [s3-credentials page](https://eodata-s3keysmanager.dataspace.copernicus.eu/panel/s3-credentials),
#' and log in with your account details. By clicking "add credential", you can
#' create a new key and secret. Store them in a safe place, as the secret is only
#' shown once. You can pass the key and secret as `s3_key` and `s3_secret` arguments
#' to functions requesting them. You can also store them as environment variables
#' such that they persist throughout the R session and don't have to be passed as
#' arguments (see below).
#' 
#' ## S3 Key and Secret as Environment Variables
#' When you share R code, you probably don't want to share your account details.
#' You can avoid using your `s3_key` and `s3_secret` in your script by
#' setting them as environment variable. You can do this yourself manually by
#' calling `dse_s3_key()<-` and `dse_s3_secret()<-` at the start of each session.
#' 
#' You can also define them in your `.Rprofile` file with
#' `Sys.setenv(CDSE_API_S3ID = "<your key>")` and
#' `Sys.setenv(CDSE_API_S3SECRET = "<your secret>")`. This way,
#' they are set each time you start a new R session.
#' @references <https://documentation.dataspace.copernicus.eu/APIs/S3.html>
#' @param region [AWS Region](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)
#' used in instantiating the client
#' @param ... Ignored
#' @param s3_key,s3_secret The s3 key and secret registered under your Data Space
#' Ecosystem account
#' @param value Replacement value for the `s3_key` or `s3_secret`.
#' @returns [dse_s3()] returns a client for the Data Space Ecosystem s3 service.
#' For more details see [paws::s3()].
#' 
#' [dse_s3_key()] and [dse_s3_secret()] will return the requested s3 details
#' if set as environment variable (see details).
#' 
#' [dse_has_s3_secret()] returns a logical value indicating whether s3 details
#' (key and secret) are set. It will not determine whether the details are valid.
#' @examples
#' if (interactive() && dse_has_s3_secret()) {
#'   my_s3 <- dse_s3()
#'   my_s3$get_object(Bucket = "", Key = "") |> summary()
#' }
#' @export
dse_s3 <- function(region = "us-east-1",
                   ..., s3_key = dse_s3_key(), s3_secret = dse_s3_secret()) {
  paws::s3(
    credentials = list(
      creds = list(
        access_key_id     = s3_key,
        secret_access_key = s3_secret
      )
    ),
    endpoint = .odata_s3_endpoint,
    region   = region
  )
}

#' @rdname dse_s3
#' @export
dse_has_s3_secret <- function() {
  dse_s3_key() != "" && dse_s3_secret() != ""
}

#' @rdname dse_s3
#' @export
dse_s3_key <- function(...) {
  Sys.getenv("CDSE_API_S3ID")
}

#' @rdname dse_s3
#' @export
`dse_s3_key<-` <- function(..., value) {
  Sys.setenv(CDSE_API_S3ID = as.character(value))
}

#' @rdname dse_s3
#' @export
dse_s3_secret <- function(...) {
  Sys.getenv("CDSE_API_S3SECRET")
}

#' @rdname dse_s3
#' @export
`dse_s3_secret<-` <- function(..., value) {
  Sys.setenv(CDSE_API_S3SECRET = as.character(value))
}

#' Set Copernicus Data Space Ecosystem Access Token for GDAL Driver
#' 
#' This function sets system environment variables, such
#' that the GDAL library can access the Copernicus Data Space
#' Ecosystem https storage. Note that these settings can be used
#' by any package depending on the GDAL library. Most notably:
#' `stars`, `terra`, and `gdalraster`.
#' @inheritParams dse_usage
#' @returns Returns a `logical` value. `TRUE` if all variables
#' were successfully set. `FALSE` otherwise.
#' @examples
#' if (interactive() && dse_has_client_info() &&
#'     requireNamespace("stars")) {
#'   uri <-
#'     dse_stac_get_uri(
#'       "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
#'       "B01", type = "odata")
#'    
#'   dse_set_gdal_token()
#'
#'   ## As this URI is zipped, it need to be downloaded.
#'   ## But you can access it directly:
#'   jp2 <- stars::read_stars(uri)
#' }
#' @export
dse_set_gdal_token  <- function(token = dse_access_token()) {
  Sys.setenv(GDAL_HTTP_AUTH = "BEARER") &&
    Sys.setenv(GDAL_HTTP_BEARER = token$access_token)
}
