#' @include init.R
NULL

#' Filter OData and STAC Requests Using Geometries
#' 
#' Filters OData and STAC rows that intersect with spatial feature `y`.
#' @param x Either an `odata_request` class object, generated with
#' [dse_odata_products_request()]/[dse_odata_bursts_request()]; or
#' a `stac_request` generated with [dse_stac_search_request()].
#' @param y A spatial geometry of either class `sf` (see [sf::st_as_sf()]) or
#' `sfc` (see [sf::st_as_sfc()]). It
#' will always be transformed to WGS 84 projection (EPSG:4326).
#' @param sparse Argument inherited from generic definition. Ignored in this context
#' @param ... Ignored
#' @returns Returns an object of the same class as `x`, with the geometry filter added
#' to it.
#' @examples
#' if (interactive()) {
#'   bbox <-
#'     sf::st_bbox(
#'       c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
#'       crs = 4326) |>
#'       sf::st_as_sfc()
#' 
#'   dse_odata_products_request() |>
#'     dplyr::filter(
#'       `ContentDate/Start` > "2025-01-01") |>
#'     sf::st_intersects(bbox) |>
#'     dplyr::collect()
#'
#'   dse_stac_search_request() |>
#'     st_intersects(bbox) |>
#'     dplyr::collect()
#' }
#' @rdname geometry
#' @name st_intersects
#' @export st_intersects.odata_request
st_intersects.odata_request <-
  function (x, y, sparse = FALSE, ...) {
    x$odata$geoms <- c(x$odata$geoms, list(y))
    x
  }

.translate_geoms <- function(geom) {
  if (!inherits(geom, "sfc"))
    geom <- sf::st_as_sfc(geom)
  geom |>
    sf::st_transform(4326) |>
    sf::st_geometry() |>
    sf::st_as_text()
}

#' @rdname geometry
#' @name st_intersects
#' @export st_intersects.stac_request
st_intersects.stac_request <-
  function (x, y, sparse = FALSE, ...) {
    cur_bbox <- x$body$data$bbox
    cur_geom <- x$body$data$intersects

    ## Other projections don't seem to work well, so transform:
    y <- sf::st_transform(y, 4326)

    w <- \()
      rlang::warn("Geometry and bbox are mutually exclusive. Removing defined geometry")
    
    if (inherits(y, "bbox")) {
      
      if (!(is.null(cur_bbox) || is.na(cur_bbox)))
        rlang::warn("Replacing previously defined bbox")
      
      x$body$data$bbox <- as.list(as.numeric(y))
      
      if (!(is.null(cur_geom) || is.na(cur_geom))) {
        x$body$data$intersects <- NULL
        w()
      }
      
    } else {
      
      if (!(is.null(cur_geom) || is.na(cur_geom)))
        rlang::warn("Replacing previously defined geometry")

      ## Make sure to summarise all features to one Geometry(Collection)      
      y <- dplyr::summarise(sf::st_as_sf(y)) |> sf::st_geometry()
      
      tempfn <- tempfile(fileext = ".geojson")
      on.exit({ unlink(tempfn) })
      sf::st_write(y, tempfn, driver = "GeoJSON", quiet = TRUE)
      yjson <- jsonlite::read_json(tempfn)
      geom  <- yjson$features[[1]]$geometry
      
      x$body$data$intersects <- geom
      
      if (!(is.null(cur_bbox) || is.na(cur_bbox))) {
        x$body$data$bbox <- NULL
        w()
      }

    }
    
    x
  }
