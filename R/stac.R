## https://stac.dataspace.copernicus.eu/v1/api.html

#' @include tidyverse.R
#' @include helpers.R
#' @include account.R
#' @include req_perform.R
NULL

.stac_base_url <- "https://stac.dataspace.copernicus.eu/v1"

.stac_get <- function(endpoint = "") {
  .stac_base_url |>
    paste(endpoint, sep = "/") |>
    httr2::request() |>
    httr2::req_error(body = .stac_error) |>
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
    if ("code" %in% names(details))
      return (sprintf("%s: %s", details$code, details$description))
    loc <- lapply(details$detail, \(x) do.call(paste, c(x$loc, sep = "/"))) |> unlist()
    msg <- lapply(details$detail,`[[`, "msg") |> unlist()
    cbind(loc, msg) |> apply(1, paste, collapse = ": ", simplify = FALSE) |> unlist()
  } else {
    return("No error details returned by server")
  }
}

#' Obtain Information About the STAC Client
#' 
#' Returns information about the STAC client used in the Data Space Ecosystem
#' @param ... Ignored
#' @returns Returns a `data.frame` with the requested information
#' @examples
#' if (interactive()) {
#'   dse_stac_client()
#' }
#' @export
dse_stac_client <- memoise::memoise(.dse_stac_client)

.dse_stac_collections <- function(collection, ...) {
  arg <- "collections"
  if (!missing(collection)) arg <- paste(arg, collection, sep = "/")
  result  <- .stac_get(arg)
  if (any(names(result) == "collections")) {
    attribs <- result[names(result) != "collections"]
    result  <- result$collections |> .simplify(do_unnest = FALSE)
    attr(result, "request") <- attribs
  } else {
    result <- .simplify(result, do_unnest = FALSE)
  }
  result
}

#' Get a Summary of all Data Space Ecosystem Collections
#' 
#' Use the STAC API to get a summary of all collections available
#' from the interface.
#' @param collection A specific collection for which to obtain summary information.
#' If missing (default), all collections are returned.
#' @param ... Ignored
#' @returns Returns a `data.frame` with the requested information
#' @examples
#' if (interactive()) {
#'   dse_stac_collections()
#'   dse_stac_collections("sentinel-2-l2a")
#' }
#' @export
dse_stac_collections <- memoise::memoise(.dse_stac_collections)

.dse_stac_api_specs <- function(...) .stac_get("api")

.get_schema <- function(ref, api) {
  ref <- gsub("#", "api", ref)
  ref <- gsub("/", "$", ref)
  rlang::parse_expr(ref) |> rlang::eval_tidy()
}

.dse_fix_list <- function(target, source, api) {
  lapply(names(target), \(nm) {
    types <- target[[nm]]$anyOf |> .simplify()
    if (is.null(source[[nm]]) && "null" %in% types$type) {
      if ("array" %in% types$type) {
        itms_nm  <- c("prefixItems", "items")
        itms_nm  <- itms_nm[itms_nm %in% names(types)]
        itms_idx <- which(types$type == "array")
        itms <- do.call(c, types[[itms_nm]])
        if (!any(c("$ref", "type") %in% names(itms))) {
          return(rep(NA, length(types)))
        } else {
          if ("string" %in% itms)
            return(NA) else {
              return(NA)
            }
        }
      } else {
        ## object e.g. intersects
        return(NA)
      }
    } else {
      target[[nm]] <- source[[nm]]
      if (grepl("date", nm)) {
        target[[nm]] <- lubridate::as_datetime(target[[nm]], tz = "")
        target[[nm]] <- lubridate::format_ISO8601(target[[nm]], usetz = TRUE)
      }
      if ("integer" %in% types$type) target[[nm]] <-   as.integer(target[[nm]])
      if ("number"  %in% types$type) target[[nm]] <-   as.numeric(target[[nm]])
      if ("string"  %in% types$type) target[[nm]] <- as.character(target[[nm]])
      if ("object"  %in% types$type) {
        schema <-
          .get_schema(types$additionalProperties[[1]]$propertyNames[["$ref"]], api)
        target[[nm]] <- .dse_fix_list(schema, target[[nm]], api)
      }
      if ("array" %in% types$type) target[[nm]] <- as.list(target[[nm]]) else {
        if (length(target[[nm]]) > 1)
          rlang::abort(c(x = sprintf("'%s' should have a length of 1 not %i",
                                     nm, length(target[[nm]]))))
      }
      return(target[[nm]])
    }
  })
}

.dse_stac_search_filter <- function(...) {
  api_props <- dse_stac_api_specs()
  filt <- api_props$components$schemas$SearchPostRequest$properties
  args <- list(...)
  if (any(!names(args) %in% names(filt)))
    rlang::warn(sprintf("Ignoring unknown filter arguments: %s",
                        sprintf("'%s'", names(args)[!names(args) %in% names(filt)]) |>
                          paste(collapse = ", ")))
  result <- .dse_fix_list(filt, args, api_props)
  names(result) <- names(filt)
  result[["filter-lang"]] <- "cql2-json"
  result[["filter-crs"]] <- "EPSG:4326"
  class(result) <- union("stac_search", class(result))
  result
}

#' TODO
#' 
#' TODO
#' @param ... TODO
#' @returns TODO
#' @examples
#' # TODO
#' library(dplyr)
#' 
#' if (interactive()) {
#'   dse_stac_search_request() |>
#'     collect()
#' }
#' @export
dse_stac_search_request <- function(collections, ids, ...) {
  
  filt <- .dse_stac_search_filter(...)
  filt$intersects <- NULL #TODO
  filt$bbox <- NULL #TODO
  result <-
    .stac_base_url |>
    paste("search", sep = "/") |>
    httr2::request() |>
    httr2::req_method("POST") |>
    httr2::req_body_json(filt) |>
    httr2::req_error(body = .stac_error)
  class(result) <- union("stac_request", class(result))
  result
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
}

.dse_stac_queryables <- function(collection, ...) {
  result <-
    .stac_base_url |>
    paste("collections", collection, "queryables", sep = "/") |>
    httr2::request() |>
    httr2::req_error(body = .stac_error) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Get Queryables for a STAC collection
#' 
#' When searching through a collection with [dse_stac_search_request()], it
#' can be helpful to know which elements can be used to filter the search
#' results (using [dplyr::filter()]). Calling [dse_stac_queryables()] tells
#' you which aspects are available for querying and expected formats.
#' @param collection Name of the collection for which to get the queryables.
#' @param ... Ignored
#' @returns Returns a named list with information about elements that can be used
#' to query the `collection`
#' @examples
#' if (interactive()) {
#'   dse_stac_queryables("sentinel-1-grd")
#' }
#' @export
dse_stac_queryables <- memoise::memoise(.dse_stac_queryables)