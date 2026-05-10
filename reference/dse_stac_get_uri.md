# Get a Uniform Resource Identifier (URI) for an Asset in a Product

Get a Uniform Resource Identifier (URI) for an asset in a product. This
can be used to download a file manually or connect to the asset directly
straight from the source.

## Usage

``` r
dse_stac_get_uri(
  asset_id,
  asset,
  collection = dse_stac_guess_collection,
  type = "s3",
  ...
)
```

## Arguments

- asset_id:

  STAC id, used for locating the asset download details.

- asset:

  Name of the asset to download

- collection:

  The identifier for a collection. The default argument is the
  [`dse_stac_guess_collection()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_guess_collection.md)
  function which tries to guess the collection id from the `asset_id`. A
  more rigid approach is to provide the collection id as a `character`
  string.

- type:

  Which type of URI should be returned? Defaults to `"s3"`. Use
  `"odata"` to get the alternative https URI.

- ...:

  Ignored

## Value

Returns the URI as a `character` string. If available, the local path
for an asset is returned as attribute.

## Examples

``` r
if (interactive()) {
  dse_stac_get_uri(
    asset_id = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
    asset = "B01"
  )
}
```
