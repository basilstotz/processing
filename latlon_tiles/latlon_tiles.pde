float a=5.0;
float b=10.0;
float delta=5.0/6000;

void setup(){
 for(int zoom=0;zoom<19;zoom++){
   float dd=tile2lon(2,zoom)-tile2lon(1,zoom);
   println(zoom+" "+dd+" "+dd/delta);  
 }
 exit();
}






float tile2lon(int x, int z) {
  return x / pow(2.0, z) * 360.0 - 180;
}

float tile2lat(int y, int z) {
  float n = PI - (2.0 * PI * y) / pow(2.0, z);
  return degrees(atan(sinh(n)));
}

int  lon2tile(float lon, int zoom) {
  return floor( (lon + 180) / 360 * (1<<zoom) );
}

int lat2tile(float lat, int zoom) {
  return floor( (1 - log(tan(radians(lat)) + 1 / cos(radians(lat))) / PI) / 2 * (1<<zoom) ) ;
}

String getTileNumber(final float lat, final float lon, final int zoom) {
  int xtile = lon2tile(lon,zoom);
  int ytile = lat2tile(lat,zoom);
  return ("/" + zoom + "/" + xtile + "/" + ytile);
}

String getURL( float lon, float lat, int zoom){
  return "http://tile.openstretmap.org/"+getTileNumber(lon, lat, zoom);
}

float sinh(float x){
  return 0.5*(exp(x)-exp(-x));
}
