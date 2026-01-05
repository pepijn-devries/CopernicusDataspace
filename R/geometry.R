#' @include init.R
NULL

#' Filter OData Request Using Geometries
#' 
#' Filters OData rows that intersect with spatial feature `y`.
#' @param x An `odata_request` class object. Generated with [dse_odata_products_request()]
#' or [dse_odata_bursts_request()].
#' @param y A spatial geometry of either class `sf` (see [sf::st_as_sf()]) or
#' `sfc` (see [sf::st_as_sfc()]). It
#' will always be transformed to WGS 84 projection (EPSG:4326).
#' @param sparse Argument inherited from generic definition. Ignored in this context
#' @param ... Ignored
#' @returns Returns an `odata_request` class object, with the geometry filter added
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
#' }
#' @rdname geometry
#' @name st_intersects
#' @export
st_intersects.odata_request <-
  function (x, y, sparse = FALSE, ...) {
    x$odata$geoms <- c(x$odata$geoms, list(y))
    x
  }

.translate_geoms <- function(geom) {
  geom |>
    sf::st_transform(4326) |>
    sf::st_geometry() |>
    sf::st_as_text()
}
