class OsmPlace {

  int place_id;
  String osm_type;
  int osm_id;
  int place_rank;
  String boundingbox;
  float lon;
  float lat;
  String display_name;
  String classe;
  String type;
  String icon;



  OsmPlace(){;}

  String toString(){
   return(display_name+"\n"+classe+" "+type);
  }
  
}

