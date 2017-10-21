# Natural Earth Admin features in Mapbox Vector Tile format

### Note: work in progress. Docs that follow describe functionality currently in development.

## Quickstart

From the root of the repository, run:

```sh
make
```

This will produce a file in the repository root, `ne-admin.mbtiles`, ready for serving with [your favorite mvt server](https://github.com/mapbox/awesome-vector-tiles#servers).

## About

Features are sourced from the [10m Natural Earth Admin 0 and Admin 1 geojson](https://github.com/nvkelso/natural-earth-vector/tree/master/geojson). Major lakes straddling international boundaries are excluded from the features. All features are rendered as polygons/multipolygons in the vector tiles. Zoom levels 0 thru 5 are rendered.

All tags present in the natural earth data are removed, excluding following which are carried through:

* a human-readable, generally english-language `name` field
* and an `id` field. For Admin 0 features (ie. countries) this is their [ISO 3166-1 Alpha 2](https://www.iso.org/standard/63545.html) code. For Admin 1 features (ie. states/provinces) this is their [ISO 3166-2](https://www.iso.org/standard/63546.html) code.

Features in the vector tiles are organized into a series of layers.

* `admin-0`: All Admin 0 features. Rendered into zoom levels 0-3.
* `admin-1.XX`: Admin 1 features of the Admin 0 feature with the ISO 3166-1 Alpha 2 code of `XX`. Depending on the physical size of the Admin 1 features in the layer, this layer is rendered to either zoom levels 3 thru 5, 4 and 5, or just zoom level 5.

Some Admin 0 features do not yet have their Admin 1 features rendered in the vector tiles. Currently, the rendered vector tiles contain Admin 1 layers for the following Admin 0 entities:

| ISO 3166-1 Alpha 2 | Name | Largest rendered zoom level |
| --- | --- | --- |
| AR | Argentina | 4 |
| CA | Canada | 3 |
| US | USA | 3 |

## Contributing

Bugs, feature suggestions - please file a github issue or make a pull request.

Adding additional Admin 1 layers is an ongoing task and help is appreciated.

## License

[MIT](https://github.com/travelmapaddict/natural-earth-admin-mvt/blob/master/LICENSE)
