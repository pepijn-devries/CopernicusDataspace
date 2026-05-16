# Package index

## Authentication Functions

Authentication methods for Copernicus Dataspace Ecosystem services

- [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_public_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_get_client_id()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_set_client_id()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_set_username()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_set_password()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_get_client_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_get_username()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_get_password()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_set_client_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_has_client_info()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  [`dse_has_password()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  : Client Information and Access Token for the Data Space Store API
- [`dse_get_token_details()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_get_token_details.md)
  : Decode Access Token
- [`dse_has_s3_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
  [`dse_s3_get_key()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
  [`dse_s3_set_key()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
  [`dse_s3_get_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
  [`dse_s3_set_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
  : Setup Amazon Simple Storage Service for the Data Space Ecosystem
- [`dse_set_gdal_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_set_gdal_token.md)
  : Set Copernicus Data Space Ecosystem Access Token for GDAL Driver
- [`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)
  [`dse_user_statistics()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)
  : Get Data Space Account Information

## STAC Functions

Functions accessing the STAC catalogue

- [`dse_stac_client()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_client.md)
  : Obtain Information About the STAC Client
- [`dse_stac_collections()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_collections.md)
  : Get a Summary of all Data Space Ecosystem Collections
- [`dse_stac_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_download.md)
  : Download Asset From STAC Catalogue
- [`dse_stac_get_uri()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_get_uri.md)
  : Get a Uniform Resource Identifier (URI) for an Asset in a Product
- [`dse_stac_guess_collection()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_guess_collection.md)
  : Guess the Collection id from an Asset id
- [`dse_stac_queryables()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_queryables.md)
  : Get Queryables for a STAC Collection
- [`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md)
  : Create a Request for a STAC Search in the Data Space Ecosystem

## OData Functions

Functions for handling OData services

- [`dse_odata_attributes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_attributes.md)
  : List OData Attributes
- [`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md)
  [`dse_odata_bursts()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md)
  : Create a OData Request for a Data Space Ecosystem Bursts Data
- [`dse_odata_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download.md)
  : Download Data Space Ecosystem Products Through OData API
- [`dse_odata_download_path()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download_path.md)
  : Alternative Route to Download OData Products
- [`dse_odata_product_nodes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_product_nodes.md)
  : List OData Product Nodes (i.e. Files and Directories)
- [`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md)
  [`dse_odata_products()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md)
  : Create a OData Request for a Data Space Ecosystem Product
- [`dse_odata_quicklook()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_quicklook.md)
  : Download a Quicklook for a Product

## S3 Functions

Functions accessing the S3 buckets

- [`dse_has_s3_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
  [`dse_s3_get_key()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
  [`dse_s3_set_key()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
  [`dse_s3_get_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
  [`dse_s3_set_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md)
  : Setup Amazon Simple Storage Service for the Data Space Ecosystem
- [`dse_s3_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_download.md)
  : Download Asset Through Uniform Resource Identifier
- [`dse_s3_set_gdal_options()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_set_gdal_options.md)
  : Set-up S3 Configuration for GDAL Library
- [`dse_s3_uri_to_vsi()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_uri_to_vsi.md)
  : Convert Uniform Resource Identifier to Virtual System Identifier

## SH Functions

Functions for using SentinelHub

- [`dse_sh_collections()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_collections.md)
  : List Sentinel Hub Collections
- [`dse_sh_custom_scripts()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_custom_scripts.md)
  : List Custom JavaScripts for Processing Sentinel Hub Data
- [`dse_sh_features()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_features.md)
  : List Sentinel Hub Features
- [`dse_sh_get_custom_script()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_get_custom_script.md)
  : Retrieve Custom JavaScripts to be Used by Sentinel Hub
- [`dse_sh_prepare_input()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_prepare_.md)
  [`dse_sh_prepare_output()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_prepare_.md)
  : Prepare Input and Output Fields for Sentinel Hub Request
- [`dse_sh_process()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_process.md)
  : Process Satellite Data and Download Result
- [`dse_sh_queryables()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_queryables.md)
  : List Queryable Fields on Sentinel Hub
- [`dse_sh_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_search_request.md)
  : Create a Request for the SentinelHub Catalogue
- [`dse_sh_use_requests_builder()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_use_requests_builder.md)
  : Use Requests Builder to Send Processing Request to SentinelHub

## Tidyverse Functions

Specific implementations of Tidyverse generics

- [`req_perform()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/req_perform.md)
  : Perform a Request to Get a Response
- [`filter(`*`<odata_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`filter(`*`<sentinel_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`filter(`*`<stac_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`compute(`*`<odata_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`collect(`*`<odata_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`collect(`*`<sentinel_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`collect(`*`<stac_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`arrange(`*`<odata_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`arrange(`*`<stac_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`slice_head(`*`<odata_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`slice_head(`*`<stac_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`slice_head(`*`<sentinel_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`select(`*`<odata_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`select(`*`<stac_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  [`select(`*`<sentinel_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
  : Tidy Verbs for OData, SentinelHub and STAC API Requests

## Geometry Functions

Functions for filtering geometries

- [`st_intersects(`*`<odata_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/geometry.md)
  [`st_intersects(`*`<stac_request>`*`)`](https://pepijn-devries.github.io/CopernicusDataspace/reference/geometry.md)
  : Filter OData and STAC Requests Using Geometries
