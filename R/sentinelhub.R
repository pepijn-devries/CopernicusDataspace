
# https://documentation.dataspace.copernicus.eu/APIs/SentinelHub/ApiReference.html
# https://shapps.dataspace.copernicus.eu/requests-builder/
# https://documentation.dataspace.copernicus.eu/APIs/SentinelHub/ApiReference/openapi.v1.yaml

#' @include helpers.R
#' @include account.R
NULL

.sh_catalog_url <- paste0(.sh_api_url, "/catalog/1.0.0")

.sh_error <- function(resp) {
  if (grepl("text/html", resp$headers$`content-type`)) {
    resp |>
      httr2::resp_body_html() |>
      xml2::xml_find_all("//pre") |>
      xml2::xml_text()
  } else if (grepl("application/json", resp$headers$`content-type`)) {
    result <-
      resp |>
      httr2::resp_body_json()
    result$description
  } else {
    "Details unknown"
  }
}

.dse_sh_collections <- function(...) {
  collections <- 
    .sh_catalog_url |>
    paste("collections", sep = "/") |>
    httr2::request() |>
    httr2::req_error(body = .sh_error) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  links <- collections$links |> .simplify()
  collections <- collections$collections |> .simplify()
  attr(collections, "links") <- links
  collections
}

#' List Sentinel Hub Collections
#' 
#' List collections that are available from the Sentinel Hub.
#' 
#' @param ... Ignored
#' @returns Returns a `data.frame` with information about the
#' collections available from the Sentinel Hub
#' @examples
#' if (interactive()) {
#'   dse_sh_collections()
#' }
#' @include helpers.R
#' @export
dse_sh_collections <- memoise::memoise(.dse_sh_collections)

.dse_sh_queryables <- function(collection, ..., token = dse_access_token()) {
  .sh_catalog_url |>
    paste("collections/%s/queryables", sep ="/") |>
    sprintf(collection) |>
    httr2::request() |>
    httr2::req_error(body = .sh_error) |>
    .add_token(token) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' List Queryable Fields on Sentinel Hub
#' 
#' Return queryable fields for a specific collection on Sentinel Hub.
#' This is useful information when composing a query with
#' [dse_sh_prepare_input()]. Use [dse_sh_collections()] to list
#' available collections.
#' @param collection Collection id for which to obtain queryable fields.
#' @param ... Ignored.
#' @inheritParams dse_usage
#' @returns Returns a named `list`, with information about queryable
#' fields for the specified `collection`.
#' @examples
#' if (interactive() && dse_has_client_info()) {
#'   dse_sh_queryables("sentinel-2-l1c")
#' }
#' @export
dse_sh_queryables <- memoise::memoise(.dse_sh_queryables)

.dse_sh_process <- function(
    input, output, evalscript, destination,
    ..., token = dse_access_token()) {
  
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
    httr2::req_perform(path = destination)
}

#' Process Satellite Data and Download Result
#' 
#' TODO
#' @param input TODO
#' @param output TODO
#' @param evalscript TODO
#' @param destination A file name to store the downloaded image.
#' @param ... TODO
#' @returns A `httr2_response` class object containing the
#' location of the downloaded file at its `destination`.
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
#' evalscript <- dse_sh_get_custom_script("/sentinel-2/l2a_optimized/")
#' 
#' if (interactive() && dse_has_client_info()) {
#'   fl <- tempfile(fileext = ".tiff")
#'   dse_sh_process(input, output, evalscript, fl) #TODO
#'   
#'   if (requireNamespace("stars")) {
#'     library(stars)
#'     enkhuizen <- read_stars(fl) |> suppresWarnings()
#'     plot(enkhuizen, rgb = 1:3, axes = TRUE, main = "Enkhuizen")
#'   }
#' }
#' @export
dse_sh_process <- memoise::memoise(.dse_sh_process)

.dse_sh_custom_scripts <- function(...) {
  result <-
    "https://custom-scripts.sentinel-hub.com/custom-scripts/assets/js/search-data.json" |>
    httr2::request() |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    lapply(tibble::as_tibble) |>
    dplyr::bind_rows() |>
    dplyr::select(-"url") |>
    dplyr::filter(endsWith(.data$relUrl, "/")) |>
    dplyr::select("title", "relUrl")
  nodes <- outer(result$relUrl, result$relUrl, startsWith)
  diag(nodes) <- FALSE
  nodes <- apply(nodes, 1, which) |> unlist() |> unique()
  result[-nodes,]
}

#' List Custom JavaScripts for Processing Sentinel Hub Data
#' 
#' Custom Eval Scripts, that can be used in Sentinel Hub requests,
#' for processing data. This functions lists scripts available
#' from <https://github.com/sentinel-hub/custom-scripts>. They
#' can be retrieved with [dse_sh_get_custom_script()].
#' @references
#'  * <https://custom-scripts.sentinel-hub.com/>
#'  * <https://github.com/sentinel-hub/custom-scripts>
#' @param ... Ignored
#' @returns Returns a `data.frame` with custom scripts, containing
#' a column with a title and one with a relative URL.
#' @examples
#' if (interactive()) {
#'   dse_sh_custom_scripts()
#' }
#' @export
dse_sh_custom_scripts <- memoise::memoise(.dse_sh_custom_scripts)

.dse_sh_get_custom_script <- function(rel_url) {
  "https://raw.githubusercontent.com/sentinel-hub/custom-scripts/refs/heads/main%sscript.js" |>
    sprintf(rel_url) |>
    httr2::request() |>
    httr2::req_perform() |>
    httr2::resp_body_string()
}

#' Retrieve Custom JavaScripts to be Used by Sentinel Hub
#' 
#' Sentinel Hub uses JavaScripts to process satellite images.
#' There is a repository with such custom scripts. They can be
#' listed with [dse_sh_custom_scripts()]. Use the relative URL
#' (relUrl) from that list to obtain the actual script with this
#' function.
#' @param rel_url A relative URL found with [dse_sh_custom_scripts()].
#' @returns A `character` string containing JavaScript code. This
#' script can be used with [dse_sh_process()]
#' @examples
#' if (interactive()) {
#'   dse_sh_get_custom_script("/sentinel-2/tonemapped_natural_color/")
#' }
#' @export
dse_sh_get_custom_script <-
  memoise::memoise(.dse_sh_get_custom_script)

#' TODO
#' 
#' TODO
#' @param bounds TODO
#' @param data_filter TODO
#' @param data_type TODO
#' @returns TODO
#' @examples
#' # TODO
#' library(sf)
#' 
#' shape <- st_bbox(c(xmin = 5.261, ymin = 52.680,
#'                    xmax = 5.319, ymax = 52.715), crs = 4326) |>
#'            st_as_sfc()
#' dse_sh_prepare_input(
#'   bounds = c(5.261, 52.680, 5.319, 52.715)
#' )
#' dse_sh_prepare_input(
#'   bounds = shape
#' )
#' @references
#'  * <https://apps.sentinel-hub.com/requests-builder/>
#' @export
dse_sh_prepare_input <-
  function(
    bounds,
    data_filter,
    data_type = "sentinel-2-l2a"
  ) {
    result = list()
    if (is.numeric(bounds) && !inherits(bounds, "bbox")) {
      if (!rlang::is_named(bounds)) {
        names(bounds) <- c("xmin", "ymin", "xmax", "ymax")
        bounds <- sf::st_bbox(bounds, crs = 4326)
      }
    }
    if (inherits(bounds, "bbox")) {
      bounds <-
        sf::st_as_sfc(bounds) |>
        sf::st_transform(4326) |>
        sf::st_bbox()
      result$bounds <- list(bbox = unname(as.numeric(bounds)))
    } else {
      result$bounds <- list(geometry = .sfc_to_geojson(bounds))
    }
    result
  }