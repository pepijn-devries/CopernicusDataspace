#' @include helpers.R
NULL

.sh_api_url     <- "https://sh.dataspace.copernicus.eu/api/v1"
.accounting_url <- paste0(.sh_api_url, "/accounting")

#' Get Dataspace Account Information
#' 
#' In order to guarantee good performance for all users, the Sentinel Hub applies
#' [rate limiting](https://docs.sentinel-hub.com/api/latest/api/overview/rate-limiting/).
#' This policy enforces monthly quotas to your usage. To check your quota and current
#' usage, you can call `dse_usage()` or `dse_user_statistics()`.
#' @param range Specify a time range for which to obtain user statistics.
#' The API expects a string starting with a capitalised time unit (`"DAYS"`, `"HOURS"`),
#' followed by a dash ("-") and an integer value specifying the length of the period.
#' Default is `"DAYS-31"`.
#' @param resolution Specifying a temporal resolution for the user statistics.
#' should be one of `"DAILY"` (default), `"MONTHLY"`, or `"HOURLY"`.
#' @param ... Ignored
#' @param token For authentication, many of the Dataspace Ecosystem uses
#' an access token. Either provide your access token, or obtain one automatically
#' with [dse_access_token()] (default). Without a valid token you will likely get
#' an "access denied" error.
#' @returns A `data.frame` with requested information for the user associated with
#' the provided `token`.
#' @examples
#' if (interactive() && dse_has_client_info()) {
#'   dse_usage()
#'   dse_user_statistics()
#' }
#' @seealso [dse_access_token()]
#' @export
dse_usage <- function(..., token = dse_access_token()) {
  result <-
    .accounting_url |>
    paste("usage", sep = "/") |>
    httr2::request() |>
    .add_token(token) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  nm <- names(result)
  result |>
    .simplify() |>
    dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric)) |>
    dplyr::mutate(qualifier = nm) |>
    dplyr::relocate("qualifier")
}

#' @rdname dse_usage
#' @export
dse_user_statistics <- function(
    range = "DAYS-31",
    resolution = "DAILY",
    token = dse_access_token()) {
  
  .res_args   <- c("HOURLY", "DAILY", "MONTHLY")
  .range_args <- c("SECONDS", "MINUTES", "HOURS", "DAYS")
  resolution  <- match.arg(toupper(resolution), .res_args)
  range       <- toupper(range)
  range_check <- strsplit(range, "-")[[1]]
  as.integer(range_check[[2]]) ## produces warnings/errors if second part isn't integer
  range_check <- match.arg(range_check[[1]], .range_args)
  
  .accounting_url |>
    paste("statistics/requests/statistics", sep = "/") |>
    httr2::request() |>
    httr2::req_url_query(range = range, resolution = resolution) |>
    .add_token(token) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    .simplify()
}