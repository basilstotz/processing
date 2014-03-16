#!/bin/sh

osmosis \
  --read-xml "schweiz.osm" \
\
  --tag-filter accept-relations landuse=allotments,basin,farm,farmland,farmyard,forest,grass,greenield,industrial,meadow,orchard,pasture,quarry,reservoir,vineyard \
\
  --used-way \
  --used-node \
\
  --write-xml "schweiz-filtered.osm"