# Changelog

## CopernicusDataspace V0.0.3.0003

- You can now set the limit for
  [`dse_stac_collections()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_collections.md)
- Fixed problem with stacking tidyverse operators, due to issues with
  [`httr2::req_body_json_modify()`](https://httr2.r-lib.org/reference/req_body.html)
- Updated documentation

## CopernicusDataspace V0.0.3

CRAN release: 2026-07-03

- Switched back to paws dependency due to [this
  issue](https://github.com/cloudyr/aws.signature/issues/68)
- Updated documentation

## CopernicusDataspace V0.0.1

CRAN release: 2026-05-21

- Initial release which can explore the catalogues and download data,
  providing entry points for the following APIs:
  - STAC
  - OData
  - SentinelHub
