# http://clarkgrubb.com/makefile-style-guide
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

NE_GEOJSON_DIR ?= https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson

downloads/ne_10m_admin_0_countries_lakes.geojson:
	# natural earth 4.0, when released, will stop gzipping the geojson
	# https://github.com/nvkelso/natural-earth-vector/pull/230#issuecomment-337800158
	curl --create-dirs -o $@.gz "$(NE_GEOJSON_DIR)/$(notdir $@).gz"
	gzip -f -d $@.gz

build/admin-0.mbtiles: downloads/ne_10m_admin_0_countries_lakes.geojson
	mkdir -p build
	# TODO: lowercase 'name', add 'id'
	tippecanoe -f -o $@ -z 3 -y NAME --detect-shared-borders --detect-longitude-wraparound -l admin-0 $<

ne-admin.mbtiles: build/admin-0.mbtiles
	cp $< $@

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
