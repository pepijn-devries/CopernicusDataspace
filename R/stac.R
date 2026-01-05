## https://stac.dataspace.copernicus.eu/v1/api.html

#' @include helpers.R
#' @include account.R
NULL

.stac_base_url <- "https://stac.dataspace.copernicus.eu/v1"

.stac_get <- function(endpoint = "") {
  .stac_base_url |>
    paste(endpoint, sep = "/") |>
    httr2::request() |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

.dse_stac_client <- function(...) {
  .stac_get("") |>
    .simplify2()
}

.stac_error <- function(resp) {
  if (httr2::resp_content_type(resp) == "application/json") {
    details <-
      resp |>
      httr2::resp_body_json()
    loc <- lapply(details$detail, \(x) do.call(paste, c(x$loc, sep = "/"))) |> unlist()
    msg <- lapply(details$detail,`[[`, "msg") |> unlist()
    cbind(loc, msg) |> apply(1, paste, collapse = ": ", simplify = FALSE) |> unlist()
  } else {
    return("No error details returned by server")
  }
}

#' TODO
#' 
#' TODO
#' @param ... Ignored
#' @examples
#' if (interactive()) {
#'   dse_stac_client()
#' }
#' @export
dse_stac_client <- memoise::memoise(.dse_stac_client)

.dse_stac_collections <- function(...) {
  result  <- .stac_get("collections")
  attribs <- result[names(result) != "collections"]
  result  <- result$collections |> .simplify()
  attr(result, "request") <- attribs
  result
}

#' TODO
#' 
#' TODO
#' @param ... Ignored
#' @examples
#' if (interactive()) {
#'   dse_stac_collections()
#' }
#' @export
dse_stac_collections <- memoise::memoise(.dse_stac_collections)

.dse_stac_search_filter <- function(...) {
  filt <-
    .stac_get("api")$components$schemas$SearchPostRequest$properties
  ##TODO replace elements with dots
  filt
}

#' TODO
#' 
#' TODO
#' @param ... TODO
#' @inheritParams dse_usage
#' @returns TODO
#' @examples
#' if (interactive()) {
#'   dse_stac_search_filter() #TODO
#'   dse_stac_search() #TODO
#' }
#' @export
dse_stac_search <- function(..., token = dse_access_token()) {

  filt <- .dse_stac_search_filter(...)
  filt$intersects <- NULL #TODO
  browser() #TODO
  items <-
    .stac_base_url |>
    paste("search", sep = "/") |>
    httr2::request() |>
    httr2::req_method("POST") |>
    httr2::req_body_json(filt) |>
    httr2::req_error(body = .stac_error) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  .stac_items(items)

}

#' TODO
#' 
#' TODO
#' @param ... TODO
#' @param destination TODO
#' @inheritParams dse_usage
#' @returns TODO
#' @examples
#' if (interactive() && dse_has_client_info()) {
#'   dse_stac_download(destination = tempdir()) #TODO
#' }
#' @export
dse_stac_download <- function(..., destination, token = dse_access_token()) {
  browser() #TODO
  items <- dse_stac_search(..., token)
  s3 <- items$assets[[1]]$href
#  aws.s3::get_bucket(measurement_url[[1]])
}
