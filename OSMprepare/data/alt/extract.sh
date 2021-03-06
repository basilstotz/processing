#!/bin/sh

osmosis \
  --read-xml "schweiz.osm" \
\
  --tag-filter accept-nodes waterway=river,riverbank,stream,canal,dam \
  --tag-filter accept-nodes landuse=allotments,basin,farm,farmland,farmyard,forest,grass,greenield,industrial,meadow,orchard,pasture,quarry,reservoir,vineyard \
  --tag-filter accept-nodes natural=bare_rock,fell,grassland,heath,mud,sand,scrub,stone,tree,tree_row,wetland,wood,bay,beach,spring,water,arete,cave_entrance,cliff,glacier,peak,ridge,rock,saddle,scree,sinkhole,volcano \
  --tag-filter accept-nodes place=city,town,village,hamlet,isolated_dwelling,farm \
\
  --tag-filter accept-ways waterway=river,riverbank,stream,canal,dam \
  --tag-filter accept-ways landuse=allotments,basin,farm,farmland,farmyard,forest,grass,greenield,industrial,meadow,orchard,pasture,quarry,reservoir,vineyard \
  --tag-filter accept-ways natural=bare_rock,fell,grassland,heath,mud,sand,scrub,stone,tree,tree_row,wetland,wood,bay,beach,spring,water,arete,cave_entrance,cliff,glacier,peak,ridge,rock,saddle,scree,sinkhole,volcano \
  --tag-filter accept-ways place=city,town,village,hamlet,isolated_dwelling,farm \
\
  --tag-filter accept-relations waterway=river,riverbank,stream,canal,dam \
  --tag-filter accept-relations landuse=allotments,basin,farm,farmland,farmyard,forest,grass,greenield,industrial,meadow,orchard,pasture,quarry,reservoir,vineyard \
  --tag-filter accept-relations natural=bare_rock,fell,grassland,heath,mud,sand,scrub,stone,tree,tree_row,wetland,wood,bay,beach,spring,water,arete,cave_entrance,cliff,glacier,peak,ridge,rock,saddle,scree,sinkhole,volcano \
  --tag-filter accept-relations place=city,town,village,hamlet,isolated_dwelling,farm \
\
  --used-way \
  --used-node \
\
  --write-xml "schweiz-filtered.osm"