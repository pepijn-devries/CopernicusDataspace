# Using the OData API

In the Copernicus Data Space Ecosystem (CDSE), OData (Open Data
Protocol) is the primary [RESTful
API](https://en.wikipedia.org/wiki/REST) standard used for searching,
discovering, and downloading satellite data products.

Key functions of OData in CDSE are:

- *Metadata Querying*: You can search for products using complex filters
  such as collection name (e.g., Sentinel-2), geographical area (AOI),
  acquisition dates, and cloud cover percentage.
- *Data Download*: Once a specific product ID is retrieved via a search,
  the OData API can be used to trigger the actual download of the data
  files.

This package provides convenient wrappers to access those features, and
are described in this vignette.

The package also offers features for the complementary alternative
catalogue via STAC. For more details on that read
[`vignette("STAC")`](https://pepijn-devries.github.io/CopernicusDataspace/articles/STAC.md).

## Searching Products

For searching products, you could simply use
[`dse_odata_products()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md),
where you could directly add filters as arguments. But for more
sophisticated queries, you can use
[`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md).
It creates a special class of `httr2` request object. In essence, it is
a request to the API server, which you can modify with tidyverse
operators. This sounds more complicated than it is.

Once you have created the request, you can add tidyverse operators (like
[`filter()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md),
[`arrange()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
and
[`slice_head()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)),
to modify this request. You can join those modifications with the pipe
operator (`|>` or `%>%`). You can also query products that intersect
with specific spatial features (`sf`) using
[`st_intersects()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/geometry.md).

Each collection will have specific fields which you can use to filter
your product search. To discover which fields you use, call
[`dse_odata_attributes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_attributes.md).

All of this is shown in the example below, where we filter products that
were created after January first of 2025. Where the image overlaps with
the bounding box we specify. We create a descending arrangement of
identifiers, and select only the first 5 results. By calling
[`collect()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
we ensure that the request is performed and the result is returned in a
human readable form (`data.frame`).

``` r

library(CopernicusDataspace)
library(dplyr) # Tidiverse package for data manipulation
library(sf)    # package for handling simple (spatial) features

## Define a bounding box for our search query:
bbox <-
  st_bbox(
    c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
    crs = 4326) |>
    st_as_sfc()

## Create an API request:
dse_odata_products_request() |>
  ## Filter content on ContentDate/Start`:
  filter(
    `ContentDate/Start` > "2025-01-01") |>
  ## Only data that intersects with our bounding box:
  st_intersects(bbox) |>
  ## Arrange by descending Id:
  arrange(desc(Id)) |>
  ## Only the first 5 hits:
  slice_head(n = 5) |>
  ## Collect the results:
  collect()
#> # A tibble: 5 × 16
#>   Id                  Name  ContentType ContentLength OriginDate PublicationDate
#>   <chr>               <chr> <chr>               <int> <chr>      <chr>          
#> 1 ffff1bb2-405d-49c2… MCD4… applicatio…      54771356 2025-04-3… 2025-11-09T22:…
#> 2 fffec6a0-62da-45ef… c_gl… applicatio…       2281083 2025-07-1… 2025-07-11T12:…
#> 3 fffe33e6-9119-4286… c_gl… applicatio…      23272601 2026-07-0… 2026-07-04T05:…
#> 4 fffd6992-b724-4a5d… c_gl… applicatio…    1080239294 2026-02-2… 2026-02-23T02:…
#> 5 fffd6520-0f19-49fc… c_gl… applicatio…      11559794 2025-10-3… 2025-10-31T16:…
#> # ℹ 10 more variables: ModificationDate <chr>, Online <lgl>,
#> #   EvictionDate <chr>, S3Path <chr>, Checksum <list>, ContentDate.Start <chr>,
#> #   ContentDate.End <chr>, Footprint <chr>, GeoFootprint.type <chr>,
#> #   GeoFootprint.coordinates <list>
```

## Burst Data

[Bursts](https://documentation.dataspace.copernicus.eu/APIs/Sentinel-1%20SLC%20Burst.html)
is a concept associated with the Sentinel-1 C-SAR instrument. They have
dedicated functions for searching for specific burst data:
[`dse_odata_bursts()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md)
and
[`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md).
These are the equivalents of
[`dse_odata_products()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md)
and
[`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md).
They work with the same mechanisms and downloading them works the same
as for normal OData products, as shown below. Below a basic example of
looking for and downloading of burst data:

``` r

burst_req <-
  dse_odata_bursts_request(ParentProductId == "879d445c-2c67-5b30-8589-b1f478904269")

## Note that these are large files and may take a while to download:
dse_odata_download(
  burst_req,
  tempdir()
)
```

## Exploring a Product

Once you have identified an interesting product, there are ways to
further explore it. You need the product identifier (ID) to do so. With
[`dse_odata_product_nodes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_product_nodes.md)
you can see which files are associated with the product:

``` r

dse_odata_product_nodes("c8ed8edb-9bef-4717-abfd-1400a57171a4",
                        recursive = TRUE)
#> # A tibble: 6 × 5
#>   Id                                Name  ContentLength ChildrenNumber Nodes.uri
#>   <chr>                             <chr>         <int>          <int> <chr>    
#> 1 S6A_P4_2__LR______20250110T11091… S6A_…             0              5 https://…
#> 2 xfdumanifest.xml                  xfdu…        126456              0 https://…
#> 3 EOPMetadata.xml                   EOPM…         13800              0 https://…
#> 4 S6A_P4_2__LR_RED__NT_153_196_202… S6A_…       1410175              0 https://…
#> 5 S6A_P4_2__LR_STD__NT_153_196_202… S6A_…      10670647              0 https://…
#> 6 manifest.xml                      mani…          1727              0 https://…
```

If available you can also get a quick peek at your product by calling
[`dse_odata_quicklook()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_quicklook.md):

``` r

dse_odata_quicklook(
    "91822f33-b15c-5b60-aa39-6d9f6f5c773b",
    tempfile(fileext = ".jpg"))
```

## Downloading Data

As shown in the ‘exploring’ section above, products can contain ‘nodes’,
which could either represent a file or a directory. If you want to
download all files in such a directory you can call
[`dse_odata_download_path()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download_path.md).
It will download all files in the specified node path. This is
demonstrated below:

``` r

if (dse_has_account()) {
  dse_odata_download_path(
    product     = "2f497806-0101-5eea-83fa-c8f68bc56b0c",
    node_path   =
      paste("DEM1_SAR_DTE_90_20101213T034716_20130408T035028_ADS_000000_5033.DEM",
            "Copernicus_DSM_30_S09_00_E026_00", "DEM",
            "Copernicus_DSM_30_S09_00_E026_00_DEM.dt1", sep = "/"),
    destination = tempdir()
    )
}
```

The example above uses an alternative https route and requires a private
access token, which in turn requires your Copernicus Data Space user id
(usually your e-mail address) and password (see
[`vignette("Authentication")`](https://pepijn-devries.github.io/CopernicusDataspace/articles/Authentication.md)).

The formal OData route uses [S3
buckets](https://en.wikipedia.org/wiki/Amazon_S3) and requires S3
authentication (see
[`vignette("Authentication")`](https://pepijn-devries.github.io/CopernicusDataspace/articles/Authentication.md)).
You can perform such downloads with `dse_odata_downloads()` as shown
below

``` r

if (dse_has_s3_secret()) {
  dse_odata_download(
      dse_odata_products(
        Name ==
          "S1A_IW_OCN__2SDH_20250707T210608_20250707T210625_059983_07739B_893E.SAFE"),
      destination = tempdir())
}
```
