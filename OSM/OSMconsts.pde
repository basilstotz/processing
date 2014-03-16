interface OSMconsts {

  //Groups
  static final int GROUPS=6;
  static final int HIGHWAY=1;
  static final int WATERWAY=2;
  static final int TOURISM=3;
  static final int LANDUSE=4;
  static final int NATURAL=5;
  static final int PLACE=6;  
  static final String[] groups= { 
    "highway", "waterway", "tourism", "landuse", "natural", "place"
  };

  //Highway
  static final int HIGHWAY_CNT=2;
  static final int PATH=1;
  static final int FOOTWAY=2;
  static final String[] highway= { 
    "highway", "waterway", "tourism", "landuse", "natural", "place"
  };

  //Waterway
  static final int WATERWAY_CNT=5;
  static final int RIVER=1;
  static final int RIVERBANK=2;
  static final int STREAM=3;
  static final int CANAL=4;
  static final int DAM=5;
  static final String[] waterway= { 
    "highway", "waterway", "tourism", "landuse", "natural", "place"
  };

  //Tourism
  static final int TORISM_CNT=1;
  static final int ALPIN_HUT=1;
  static final String[] tourism= { 
    "highway", "waterway", "tourism", "landuse", "natural", "place"
  };

  //Landuse
  static final int LANDUSE_CNT=15;
  static final int ALLOTMENTS=1;
  static final int BASIN=2;
  //static final int FARM=3;
  static final int FARMLAND=4;
  static final int FARMYARD=5;
  static final int FOREST=6;
  static final int GRASS=7;
  static final int GREENFIELD=8;
  static final int INDUSTRIAL=9;
  static final int MEADOW=10;
  static final int ORCHARD=11;
  static final int PASTURE=12;
  static final int QUARRY=13;
  static final int RESERVOIR=14;
  static final int VINEYARD=15;
  static final String[] landuse= { 
    "highway", "waterway", "tourism", "landuse", "natural", "place"
  };

  //Natural
  static final int NATURAL_CNT=27;
  static final int BARE_ROCK=1;
  static final int FELL=2;
  static final int GRASLAND=3;
  static final int HEATH=4;
  static final int MUD=5;
  static final int SAND=6;
  static final int SCRUB=7;
  static final int STONE=8;
  static final int TREE=9;
  static final int TREE_ROW=10;
  static final int WETLAND=11;
  static final int WOOD=12;
  static final int BAY=13;
  static final int BEACH=14;
  static final int SPRING=15;
  static final int WATER=16;
  static final int ARETE=17;
  static final int CAVE_ENTRANCE=18;
  static final int CLIFF=19;
  static final int GLACIER=20;
  static final int PEAK=21;
  static final int RIDGE=22;
  static final int ROCK=23;
  static final int SADDLE=24;
  static final int SCREE=25;
  static final int SINKHOLE=26;
  static final int VOLCANO=27;
  static final String[] natural= { 
    "highway", "waterway", "tourism", "landuse", "natural", "place"
  };

  //Place
  static final int PLACE_CNT=6;
  static final int CITY=1;
  static final int TOWN=2;
  static final int VILLAGE=3;
  static final int HAMLET=4;
  static final int ISOLATED_DWELL=5;
  static final int FARM=6;
  static final String[] place= { 
    "highway", "waterway", "tourism", "landuse", "natural", "place"
  };
}

