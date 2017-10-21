# Natural Earth Admin features in Mapbox Vector Tile format

### Note: work in progress. Docs that follow describe functionality currently in development.

## Quickstart

From the root of the repository, run:

```sh
make
```

This will produce a file in the repository root, `ne-admin.mbtiles`, which can be served with [your favorite mvt server](https://github.com/mapbox/awesome-vector-tiles#servers).

## Available `make` commands

### `make`/`make all`/`make ne-admin.mbtiles`

Create the file `ne-admin.mbtiles`, which is a bundled package of [Mapbox Vector Tiles](https://www.mapbox.com/vector-tiles/).

#### Prerequisites

You'll need to have already installed [curl](https://curl.haxx.se/), [gzip](http://www.gzip.org/), [jq](https://stedolan.github.io/jq/), and [tippecanoe](https://github.com/mapbox/tippecanoe) on your machine.

#### Data

Features are sourced from the [10m Natural Earth Admin 0 and Admin 1 geojson](https://github.com/nvkelso/natural-earth-vector/tree/master/geojson). Major lakes straddling international boundaries are excluded from the features. All features are rendered as polygons/multipolygons in the vector tiles. Zoom levels 0 thru 5 are rendered.

#### Tags

All tags present in the natural earth data are removed, excluding following which are carried through:

* a human-readable, generally english-language `name` field
* and an `id` field. For Admin 0 features (ie. countries) this is their [ISO 3166-1 Alpha 2](https://www.iso.org/standard/63545.html) code. For Admin 1 features (ie. states/provinces) this is their [ISO 3166-2](https://www.iso.org/standard/63546.html) code.

#### Layers

Features in the vector tiles are organized into a series of layers.

* `admin-0`: All Admin 0 features. Rendered into zoom levels 0-3.
* `admin-1.XX`: Admin 1 features of the Admin 0 feature with the ISO 3166-1 Alpha 2 code of `XX`. Depending on the physical size of the Admin 1 features in the layer, this layer is rendered to either: zoom levels 3 thru 5, zoom levels 4 and 5, or just zoom level 5.

Some Admin 0 features do not yet have their Admin 1 features rendered in the vector tiles. Currently, the rendered vector tiles contain Admin 1 layers for the following Admin 0 entities:

| ISO 3166-1 Alpha 2 | Name | Minimum rendered zoom level |
| --- | --- | --- |
| AR | Argentina | 4 |
| CA | Canada | 3 |
| US | USA | 3 |

### `make serve`

Start up a webserver in a docker container to allow you to visually inspect your local `ne-admin.mbtiles`. While running the webserver container in a terminal window, load http://localhost:8080/ in a browser. To quit the webserver, use `ctrl-c`.

For this to work, you will need to have previously installed [docker](https://www.docker.com/) and the [klokantech/tileserver-gl-light](https://hub.docker.com/r/klokantech/tileserver-gl-light/) image.

### `make clean`

Delete all final and intermediate data products, excluding the raw downloads of Natural Earth data.

### `make fullclean`

Everything `make clean` does, and also delete the raw downloads of Natural Earth data.

## Contributing

Bugs, feature suggestions - please file a github issue or make a pull request.

Adding additional Admin 1 layers is an ongoing task and help is appreciated.

## License

[MIT](https://github.com/travelmapaddict/natural-earth-admin-mvt/blob/master/LICENSE)
