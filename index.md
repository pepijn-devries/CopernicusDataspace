# CopernicusDataspace

The [Copernicus Data Space Ecosystem](https://dataspace.copernicus.eu/),
is an open ecosystem that provides free instant access to a wide range
of data and services from the Copernicus Sentinel missions and more on
our planet’s land, oceans and atmosphere. This package provides entry
points to several APIs allowing users to access the data directly in R.

## Installation

Install latest developmental version from R-Universe:

``` r
install.packages("CopernicusDataspace", repos = c('https://pepijn-devries.r-universe.dev', 'https://cloud.r-project.org'))
```

## Downloading Using STAC Catalogue

TODO

``` r
library(CopernicusDataspace)
library(stars) ## For reading and plotting the downloaded file

## Only run this if an S3 secret is specified
if (dse_has_s3_secret()) {
  
  id    <- "Copernicus_DSM_COG_30_S69_00_W062_00_DEM"
  asset <- "data"

  filename <- dse_stac_download(id, asset, tempdir())
  tile <- read_stars(filename)
  plot(tile, col = hcl.colors(100), axes = TRUE)
  
}
```

![Example of downloading with STAC
API](reference/figures/README-download-stac-1.png)

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
