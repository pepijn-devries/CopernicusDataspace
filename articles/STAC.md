# Using the STAC Catalogue

In the Copernicus Data Space Ecosystem (CDSE), [STAC stands for
SpatioTemporal Asset Catalog](https://stacspec.org/en). It is a
standardized, open-source metadata specification used to structure,
search, and discover Earth Observation (EO) data.

Instead of requiring users to download massive, raw satellite images,
the CDSE STAC [RESTful API](https://en.wikipedia.org/wiki/REST) allows
developers to query precise metadata (e.g., location, time, cloud cover,
and specific bands) to locate exact data assets.

Key Functions of STAC:

- *Data Access*: It provides a direct path (such as S3 storage links) to
  cloud-hosted imagery, enabling tools to process a subset of data
  without full downloads.
- *System Interoperability*: It replaces satellite-specific extensions
  with a unified data model, allowing the same code or software to
  seamlessly handle diverse datasets like Sentinel-1 and Sentinel-2.

The package also offers features for the complementary primary catalogue
via OData. For more details on that read
[`vignette("OData")`](https://pepijn-devries.github.io/CopernicusDataspace/articles/OData.md).

In general to understand which STAC client the server is offering, you
can call
[`dse_stac_client()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_client.md).

## Data Exploration

A good starting point of exploring data with STAC is being aware which
collections of data are available in the first place. You can list them
as follows:

``` r

library(CopernicusDataspace)
dse_stac_collections()
#> # A tibble: 422 × 23
#>    id        type  links  title assets       extent   license keywords providers
#>    <chr>     <chr> <list> <chr> <list>       <list>   <chr>   <list>   <list>   
#>  1 ccm-opti… Coll… <list> Cope… <named list> <tibble> other   <list>   <list>   
#>  2 ccm-sar   Coll… <list> Cope… <named list> <tibble> other   <list>   <list>   
#>  3 clms_ba_… Coll… <list> CLMS… <named list> <tibble> other   <list>   <list>   
#>  4 clms_ba_… Coll… <list> CLMS… <named list> <tibble> other   <list>   <list>   
#>  5 clms_ba_… Coll… <list> CLMS… <named list> <tibble> other   <list>   <list>   
#>  6 clms_ba_… Coll… <list> CLMS… <named list> <tibble> other   <list>   <list>   
#>  7 clms_ba_… Coll… <list> CLMS… <named list> <tibble> other   <list>   <list>   
#>  8 clms_ba_… Coll… <list> CLMS… <named list> <tibble> other   <list>   <list>   
#>  9 clms_ba_… Coll… <list> CLMS… <named list> <tibble> other   <list>   <list>   
#> 10 clms_ba_… Coll… <list> CLMS… <named list> <tibble> other   <list>   <list>   
#> # ℹ 412 more rows
#> # ℹ 14 more variables: summaries <list>, description <chr>, item_assets <list>,
#> #   `auth:schemes` <list>, `ceosard:type` <list>, stac_version <chr>,
#> #   stac_extensions <list>, `storage:schemes` <list>, bands <list>,
#> #   `sci:doi` <list>, contacts <list>, `sci:citation` <list>,
#> #   `ceosard:specification` <list>, `ceosard:specification_version` <list>
```

The returned `data.frame` contains descriptive information about each of
the collections. It can help you focus your search. Once you have
identified a collection, you can check which filter/search are available
for further narrowing your exploration tour:

``` r

dse_stac_queryables("sentinel-1-grd") |> summary()
#>                      Length Class  Mode     
#> $id                   1     -none- character
#> type                  1     -none- character
#> title                 1     -none- character
#> $schema               1     -none- character
#> properties           11     -none- list     
#> additionalProperties  1     -none- logical
```

The example above shows 11 properties that can be used to focus the
search. You can start an actual search by creating a STAC search request
with:
[`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md).
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

``` r

library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is TRUE

bbox <-
  sf::st_bbox(
    c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
    crs = 4326)

dse_stac_search_request("sentinel-1-grd") |>
  filter(`sat:orbit_state` == "ascending") |>
  arrange("id") |>
  st_intersects(bbox) |>
  collect()
#> # A tibble: 10 × 63
#>    id        bbox   type  links  assets   geometry collection properties.created
#>  * <chr>     <list> <chr> <list> <list>   <list>   <chr>      <chr>             
#>  1 S1D_IW_G… <list> Feat… <list> <tibble> <tibble> sentinel-… 2026-07-11T16:27:…
#>  2 S1C_IW_G… <list> Feat… <list> <tibble> <tibble> sentinel-… 2026-07-10T16:15:…
#>  3 S1C_IW_G… <list> Feat… <list> <tibble> <tibble> sentinel-… 2026-07-05T16:17:…
#>  4 S1D_IW_G… <list> Feat… <list> <tibble> <tibble> sentinel-… 2026-07-04T16:34:…
#>  5 S1C_IW_G… <list> Feat… <list> <tibble> <tibble> sentinel-… 2026-06-28T16:30:…
#>  6 S1A_IW_G… <list> Feat… <list> <tibble> <tibble> sentinel-… 2026-06-27T16:27:…
#>  7 S1D_IW_G… <list> Feat… <list> <tibble> <tibble> sentinel-… 2026-06-22T16:38:…
#>  8 S1A_IW_G… <list> Feat… <list> <tibble> <tibble> sentinel-… 2026-06-22T16:38:…
#>  9 S1D_IW_G… <list> Feat… <list> <tibble> <tibble> sentinel-… 2026-06-17T16:21:…
#> 10 S1A_IW_G… <list> Feat… <list> <tibble> <tibble> sentinel-… 2026-06-15T16:28:…
#> # ℹ 55 more variables: properties.expires <chr>, properties.updated <chr>,
#> #   properties._private.visible <lgl>, properties._private.product_name <chr>,
#> #   properties._private.product_size <int>,
#> #   properties._private.product_uuid <chr>, properties.datetime <chr>,
#> #   properties.platform <chr>, properties.published <chr>,
#> #   properties.instruments <list>, `properties.auth:schemes.s3.type` <chr>,
#> #   `properties.auth:schemes.oidc.type` <chr>, …
```

## Downloading Data

When downloading data, you could retrieve the Uniform Resource
Identifier (URI) with
[`dse_stac_get_uri()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_get_uri.md).
To get an URI, you need at least the asset identifier and the specific
asset. Both can be obtained with a search as shown above. The example
below shows you how:

``` r

dse_stac_get_uri(
  asset_id = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
  asset = "B01",
  collection = "sentinel-2-l1c"
)
#> [1] "s3://eodata/Sentinel-2/MSI/L1C/2026/01/09/S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148.SAFE/GRANULE/L1C_T39XVL_A055105_20260109T132737/IMG_DATA/T39XVL_20260109T132741_B01.jp2"
#> attr(,"local_path")
#> [1] "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148.SAFE/GRANULE/L1C_T39XVL_A055105_20260109T132737/IMG_DATA/T39XVL_20260109T132741_B01.jp2"
```

This approach also needs the collection from which the asset is made
available. If you don’t provide it, it will be guessed with
[`dse_stac_guess_collection()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_guess_collection.md).
This function is not 100% reliable, so it’s best practice to provide the
collection manually. Instead of working with the URI yourself it is
easier to call
[`dse_stac_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_download.md).
It will automatically takes care of required authentication for
downloading the file (if properly provided). Check
[`vignette("Authentication")`](https://pepijn-devries.github.io/CopernicusDataspace/articles/Authentication.md)
for more information about the authentication process.

``` r

dse_stac_download(
  asset_id = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
  asset = "B01",
  collection = "sentinel-2-l1c",
  destination = tempdir()
)
```
