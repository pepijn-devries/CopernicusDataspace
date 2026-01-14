# CopernicusDataspace

The [Copernicus Data Space Ecosystem](https://dataspace.copernicus.eu/),
is an open ecosystem that provides free instant access to a wide range
of data and services from the Copernicus Sentinel missions and more on
our planet’s land, oceans and atmosphere. This package provides entry
points to several APIs allowing users to access the data directly in R.

## Installation

At the moment, the package is still only experimental. It can therefore
only be installed from GitHub:

``` r
devtools::install_github("CopernicusDataspace", username = "pepijn-devries")
```

## Introduction

The Copernicus Data Space Ecosystem offers access to its services
through several
[APIs](https://documentation.dataspace.copernicus.eu/APIs.html). This
package offers access via the following APIs:

- [OData](https://documentation.dataspace.copernicus.eu/APIs/OData.html);
- [STAC](https://documentation.dataspace.copernicus.eu/APIs/STAC.html);
  and
- [SentinelHub](https://documentation.dataspace.copernicus.eu/APIs/SentinelHub.html).

This README shows only essential methods for downloading data. For more
detailed information consult the respective vignettes:

- [`vignette("OData")`](https://pepijn-devries.github.io/CopernicusDataspace/articles/OData.md);
- [`vignette("STAC")`](https://pepijn-devries.github.io/CopernicusDataspace/articles/STAC.md);
  and
- [`vignette("SentinelHub")`](https://pepijn-devries.github.io/CopernicusDataspace/articles/SentinelHub.md)

## Authentication

When actually downloading files from the Copernicus Data Space
Ecosystem, you usually need some form of authentication. Examples below
use credentials stored as environment variables. For more information
about how to effectively authenticate download requests, please see
[`vignette("Authentication")`](https://pepijn-devries.github.io/CopernicusDataspace/articles/Authentication.md).

## Downloading Using STAC Catalogue

When you know the STAC identifier (`id`) and the asset name you wish to
download, you can simply use the example shown below. When you don’t
know these details, you should first explore the catalogue. Please see
[`vignette("STAC")`](https://pepijn-devries.github.io/CopernicusDataspace/articles/STAC.md)
for more details on working with the STAC catalogue.

``` r
library(CopernicusDataspace)
library(stars) ## For reading and plotting the downloaded file

## Only run this if an S3 secret is specified
if (dse_has_s3_secret()) {
  
  id        <- "Copernicus_DSM_COG_30_S69_00_W062_00_DEM"
  asset     <- "data"

  filename  <- dse_stac_download(id, asset, tempdir())
  tile_stac <- read_stars(filename)
  plot(tile_stac, col = hcl.colors(100), axes = TRUE)
  
}
```

![Example of downloading with STAC
API](reference/figures/README-download-stac-1.png)

## Downloading Using OData API

``` r

response <-
  dse_odata_download_path(
  product     = "2f497806-0101-5eea-83fa-c8f68bc56b0c",
  node_path   = paste(
    "DEM1_SAR_DTE_90_20101213T034716_20130408T035028_ADS_000000_5033.DEM",
    "Copernicus_DSM_30_S09_00_E026_00", "DEM",
    "Copernicus_DSM_30_S09_00_E026_00_DEM.dt1", sep = "/"),
  destination = tempdir())

tile_odata <- read_stars(response$body)
plot(tile_odata, col = terrain.colors(100), axes = TRUE)
```

![Example of downloading with OData
API](reference/figures/README-download-odata-1.png) TODO

## Downloading Using SentinelHub

TODO

## More of Copernicus

More R packages for exploring other Copernicus data services:

- [CopernicusClimate](https://github.com/pepijn-devries/CopernicusClimate)
  Dedicated to climate change datasets
- [CopernicusMarine](https://github.com/pepijn-devries/CopernicusMarine)
  Dedicated to marine datasets

## Code of Conduct

Please note that the CopernicusDataspace project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
