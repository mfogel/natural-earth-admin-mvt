# http://clarkgrubb.com/makefile-style-guide
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

# If you have a copy of Natural Earth cloned to your local filesystem, you can use it directly:
# export NE_GEOJSON_DIR=file:///path/to/natural/earth/geojson/dir
NE_GEOJSON_DIR ?= https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson

downloads/ne_10m_admin_0_countries_lakes.geojson downloads/ne_10m_admin_1_states_provinces_lakes.geojson:
	# natural earth 4.0, when released, will stop gzipping the geojson
	# https://github.com/nvkelso/natural-earth-vector/pull/230#issuecomment-337800158
	curl --create-dirs -o $@.gz "$(NE_GEOJSON_DIR)/$(notdir $@).gz"
	gzip -f -d $@.gz

build/admin-0.mbtiles: downloads/ne_10m_admin_0_countries_lakes.geojson
	mkdir -p build
	jq -c '.features[] | .properties = ( .properties | { "name": .NAME, "iso-3166-1-a2": .ISO_A2, "iso-3166-1-a3": .ISO_A3, "iso-3166-1-n3": .ISO_N3 } )' $< \
		| tippecanoe -f -o $@ -z 5 --detect-shared-borders --detect-longitude-wraparound -l admin-0

build/admin-1.mbtiles: downloads/ne_10m_admin_1_states_provinces_lakes.geojson
	mkdir -p build
	jq -c '.features[] | .properties = ( .properties | { "name": .name, "iso-3166-2": .iso_3166_2 } )' $< \
		| tippecanoe -f -o $@ -Z 3 -z 5 --detect-shared-borders --detect-longitude-wraparound -l admin-1

ne-admin.mbtiles: build/admin-0.mbtiles build/admin-1.mbtiles
	tile-join -f -o $@ -pk -n "Natural Earth Admin"  $^

.PHONY: all
all: ne-admin.mbtiles

.PHONY: serve
serve: ne-admin.mbtiles
	docker run -it -v $(CURDIR):/data:ro -p 8080:80 klokantech/tileserver-gl-light $<

.PHONY: clean
clean:
	rm -rf build

.PHONY: fullclean
fullclean: clean
	rm -rf downloads
