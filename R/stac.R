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

.dse_fix_list <- function(target, source, api) {
  lapply(names(target), \(nm) {
    print(nm) #TODO
    types <- target[[nm]]$anyOf |> .simplify()
    if (is.null(source[[nm]]) && "null" %in% types$type) {
      if ("array" %in% types$type) {
        itms_nm  <- c("prefixItems", "items")
        itms_nm  <- itms_nm[itms_nm %in% names(types)]
        itms_idx <- which(types$type == "array")
        itms <- types[[itms_nm]]
        if (!any(c("$ref", "type") %in% names(itms))) {
          types <- itms |>
            lapply(\(x) {
              lapply(x, `[[`, "anyOf") |>
                lapply(\(y) {
                  gsub("number|integer", "as.numeric", unlist(y)) |>
                    unique()
                }) |>
                unlist()
            })
          types <- types[[1]]
          target[[nm]] <- rep(NA, length(types)) #TODO check type!
        } else {
          if ("string" %in% itms)
            target[[nm]] <- NA else {
              target[[nm]] <- NA #TODO other types? or always NA?
            }
        }
      } else {
        ## object e.g. intersects
        target[[nm]] <- NA
      }
    } else {
      browser() #TODO
    }
  })
}

.dse_stac_search_filter <- function(...) {
  api_props <- .stac_get("api")
  filt <- api_props$components$schemas$SearchPostRequest$properties
  ##TODO replace elements with dots
  args <- list(...)
  result <- .dse_fix_list(filt, args, api_props)
  names(result) <- names(filt)
  result
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
  filt$bbox <- NULL #TODO
  jsonlite::toJSON(filt, pretty = TRUE) # TODO for debugging
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
