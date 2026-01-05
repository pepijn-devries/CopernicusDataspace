#' @importFrom memoise memoise
#' @importFrom methods setOldClass
#' @importFrom rlang .data
NULL

setOldClass("odata_request")

.onLoad = function(libname, pkgname) {
  register_all_s3_methods() # dynamically registers non-imported pkgs (tidyverse)
}

register_all_s3_methods = function() {
  ## Note that superseded tidyverse methods are not included, as there are better alternatives
  ## vctrs
  ## dplyr
  register_s3_method("dplyr", "arrange",       "odata_request")
  register_s3_method("dplyr", "filter",        "odata_request")
  register_s3_method("dplyr", "collect",       "odata_request")
  register_s3_method("dplyr", "compute",       "odata_request")
  register_s3_method("dplyr", "select",        "odata_request")
  register_s3_method("dplyr", "slice_head",    "odata_request")
  register_s3_method("sf",    "st_intersects", "odata_request")
}

# from: https://github.com/tidyverse/hms/blob/master/R/zzz.R
register_s3_method <- function(pkg, generic, class, fun = NULL) {
  stopifnot(is.character(pkg), length(pkg) == 1)
  stopifnot(is.character(generic), length(generic) == 1)
  stopifnot(is.character(class), length(class) == 1)
  
  if (is.null(fun)) {
    fun <- get(paste0(generic, ".", class), envir = parent.frame())
  } else {
    stopifnot(is.function(fun))
  }
  
  if (pkg %in% loadedNamespaces()) {
    registerS3method(generic, class, fun, envir = asNamespace(pkg))
  }
  
  # Always register hook in case package is later unloaded & reloaded
  setHook(
    packageEvent(pkg, "onLoad"),
    function(...) {
      registerS3method(generic, class, fun, envir = asNamespace(pkg))
    }
  )
}