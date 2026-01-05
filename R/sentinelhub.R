
# https://documentation.dataspace.copernicus.eu/APIs/SentinelHub/ApiReference.html
# https://shapps.dataspace.copernicus.eu/requests-builder/
# https://documentation.dataspace.copernicus.eu/APIs/SentinelHub/ApiReference/openapi.v1.yaml
# https://github.com/eu-cdse/sentinel-hub-custom-scripts

#' @include account.R
NULL

.sh_catalog_url <- paste0(.sh_api_url, "/catalog/1.0.0")

.dse_sh_collections <- function(...) {
  collections <- 
    .sh_catalog_url |>
    paste("collections", sep = "/") |>
      httr2::request() |>
      httr2::req_perform() |>
      httr2::resp_body_json()
  links <- collections$links |> .simplify()
  collections <- collections$collections |> .simplify()
  attr(collections, "links") <- links
  collections
}

#' List Sentinel hub collections
#' 
#' TODO
#' 
#' @param collection TODO
#' @param ... Ignored
#' @inheritParams dse_usage
#' @returns TODO
#' @examples
#' if (interactive()) {
#'   dse_sh_collections()
#'   if (dse_has_client_info()) {
#'     qt <- dse_sh_querytables("sentinel-2-l1c")
#'   }
#' }
#' @include helpers.R
#' @export
dse_sh_collections <- memoise::memoise(.dse_sh_collections)

.dse_sh_queryables <- function(collection, ..., token = dse_access_token()) {
  .sh_catalog_url |>
    paste("/collections/%s/queryables", sep ="/") |>
    sprintf(collection) |>
    httr2::request() |>
    .add_token(token) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' TODO
#' 
#' TODO
#' @param collection TODO
#' @param ... TODO
#' @inheritParams dse_usage
#' @returns TODO
#' @examples
#' #TODO
#' @rdname dse_sh_collections
#' @export
dse_sh_queryables <- memoise::memoise(.dse_sh_queryables)

.dse_sh_process <- function(
    input, output, evalscript, destination,
    ..., token = dse_access_token()) {
  
  data <- 
    .sh_api_url |>
    paste("process", sep = "/") |>
    httr2::request() |>
    httr2::req_method("POST") |>
    httr2::req_body_json(
      list(
        input = input,
        output = output,
        evalscript = evalscript
      ), auto_unbox = TRUE
    ) |>
    .add_token(token) |>
    # httr2::req_headers(`Content-Type` = "application/json; charset=utf8") |> #TODO
    httr2::req_perform() |>
    httr2::resp_body_raw()
  writeBin(data, destination)
}

#' Process satelite data and download result
#' 
#' TODO
#' @param input TODO
#' @param output TODO
#' @param evalscript TODO
#' @param destination TODO
#' @param ... TODO
#' @inheritParams dse_usage
#' @examples
#' input <- list(
#'   bounds = list(bbox = c(5.261, 52.680, 5.319, 52.715)),
#'   data = list(
#'     list(
#'       dataFilter = list(
#'         timeRange = list(from = "2025-06-21T00:00:00Z", to = "2025-07-21T00:00:00Z")
#'       ),
#'       type = "sentinel-2-l2a"
#'     )
#'   )
#' )
#' output <- list(
#'   width = 512, height = 515.09, responses = list(
#'     list(
#'       identifier = "default",
#'       format = list(type = "image/tiff")
#'     )
#'   )
#' )
#' 
#' evalscript <- paste(
#'   "//VERSION=3",
#'   "function setup() {",
#'   "return {",
#'   "input: [\"B02\", \"B03\", \"B04\"],",
#'   "output: { bands: 3 }",
#'   "};",
#'   "}",
#'   "function evaluatePixel(sample) {",
#'   "return [2.5 * sample.B04, 2.5 * sample.B03, 2.5 * sample.B02];",
#'   "}",
#'   sep = "\n")
#' fl <- tempfile(fileext = ".tiff")
#' if (interactive() && dse_has_client_info()) {
#'   dse_sh_process(input, output, evalscript, fl) #TODO
#' }
#' @export
dse_sh_process <- memoise::memoise(.dse_sh_process)
