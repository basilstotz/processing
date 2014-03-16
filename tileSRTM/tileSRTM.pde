PImage test;
PImage bild;
float startLon, startLat, endLon, endLat;
float bLon, bLat;
volatile float eLon, eLat;
int minZoom, maxZoom; 
volatile int zoom;
boolean running, loading;
int Width, Height;
long m;
int count;
int MAX;

void setup() {
  Width=512;
  Height=256;

  size(Width, Height);
  background(128);

  MAX=255*255*255;

 

  startLon=5.0;
  endLon=15.0;

  startLat=35.0;
  endLat=45.0;

 bild=createImage(round((endLon-startLon)/5.0)*6000, round((endLat-startLat)/5.0)*6000, ARGB);

  minZoom=5;
  maxZoom=12;

  running=false;
  loading=true;
  thread("loadBild");
  count=0;
}


void draw() {
  background(128);
  fill(0);
  text("             SRTM-Tile-Generator 0.2", 0, 20);

  if (loading) {
    pushStyle();

    bar(map(count,0,4,0.0,1.0),0.0);
    /*
    textAlign(CENTER);
     textSize(30);
     fill(255, 0, 0);
     text("loading.....", Width/2, Height/2);
     */
    popStyle();
  }

  if (running) {
    bar(map(zoom, minZoom, maxZoom+1, 0.0, 1.0), -0.2);
    bar(map(eLon, startLon, endLon, 0.0, 1.0), 0.0);
    bar(map(eLat, startLat, endLat, 0.0, 1.0), 0.2);
    m=millis();
  }

  if (!loading&&!running&&(zoom>=maxZoom)) {
    pushStyle();
    textAlign(CENTER);
    textSize(30);
    fill(255, 0, 0);
    text("finished", Width/2, Height/2);

    popStyle();
    if (millis()-m>3000)exit();
  }
}

void fbar(String s) {

  float value=(sin(millis()/500.0)+1.0)/2.0;
  pushStyle();
  textMode(CENTER);
  noStroke();
  fill(255, 255, 128);
  rect(0.1*Width+0.4*value*Width, Height/2, Width*0.4, Height*0.1);
  stroke(255, 255, 0);
  fill(0, 0);
  rect(0.1*Width, Height/2, Width*0.8, Height*0.1);
  fill(0);
  text(s, 0.5*Width, Height/2+20);
  popStyle();
}

void bar(float value, float displace) {

  value=constrain(value, 0.0, 1.0);
  pushStyle();
  noStroke();
  fill(255, 255, 128);
  rect(0.1*Width, Height/2+Height*displace, value*Width*0.8, Height*0.1);
  stroke(255, 255, 0);
  fill(0, 0);
  rect(0.1*Width, Height/2+Height*displace, Width*0.8, Height*0.1);
  fill(0);
  text(int(value*100)+" %", 0.5*Width, Height/2+Height*displace+20);
  popStyle();
}

void loadBild() {
  
  PImage tile;
  int s=6000;

  loading=true;
  tile=loadImage("srtm_38_02.tiff");
  bild.copy(tile, 0, 0, s, s, 0*s, 0*s, s, s);
  count++;
  tile=loadImage("srtm_39_02.tiff");
  bild.copy(tile, 0, 0, s, s, 1*s, 0*s, s, s);
  count++;
  tile=loadImage("srtm_38_03.tiff");
  bild.copy(tile, 0, 0, s, s, 0*s, 1*s, s, s);
  count++;
  tile=loadImage("srtm_39_03.tiff");
  bild.copy(tile, 0, 0, s, s, 1*s, 1*s, s, s);
  count++;
  bild.save("srtm_all.tiff");
  /*
  tile=loadImage("srtm_38_04.tiff");
  bild.copy(tile, 0, 0, s, s, 0*s, 2*s, s, s);
  count++;
  tile=loadImage("srtm_39_04.tiff");
  bild.copy(tile, 0, 0, s, s, 1*s, 2*s, s, s);
  count++;
*/
  loading=false;
  thread("makeAllTiles");
}

void makeAllTiles() {


  running=true;
  for (zoom=minZoom; zoom<maxZoom+1; zoom++) {
    //println();
    //println("zoom "+zoom+" :");


    bLon=startLon;
    eLon=tile2lon(lon2tile(bLon, zoom)+1, zoom);

    while (eLon<endLon) {
      //println();
      //println(bLon+"  "+eLon);

      bLat=startLat;
      eLat=tile2lat(lat2tile(bLat, zoom)-1, zoom);

      while (eLat<endLat) {
        //println("         "+bLat+"   "+eLat+" ");
        int x=lon2tile(bLon, zoom);
        int y=lat2tile(bLat, zoom);
        String s="output/"+nf(zoom, 1)+"/"+nf(x, 1)+"/"+nf(y, 1)+".tiff";

        makeTile(bLon, bLat, eLon, eLat).save(s);


        bLat=eLat;
        eLat=tile2lat(lat2tile(bLat, zoom)-1, zoom);
      }

      bLon=eLon;
      eLon=tile2lon(lon2tile(bLon, zoom)+1, zoom);
    }
    /*
    for (int i=0;i<bild.width;i+=jump*256) {
     for (int j=0;j<bild.height;j+=jump*256) {
     
     for (int k=0;k<256;k++) {
     for (int l=0;l<256;l++) {
     tile.set(k, l, sample(i+k*jump, j+l*jump, jump) );
     }
     }
     print("*");
     //copy(bild, i, j, 256*jump, 256*jump, 0, 0, 256, 256);
     String s=nf(int(j/(jump*256)), 2)+".tiff";
     tile.save("output/"+(zoom)+"/"+nf(int(i/(jump*256)), 2)+"/"+s);
     }
     }
     */
  }
  running=false;
}


PImage makeTile(float x1, float y1, float x2, float y2) {

  PImage tile= createImage(256, 256, ARGB);
  float dx=(x2-x1)/256.0;
  float dy=(y2-y1)/256.0;
  int s;

  //create tile
  for (int k=0;k<256;k++) {
    for (int l=0;l<256;l++) {

      float x=lon2Bild(x1+k*dx);
      float y=lat2Bild(y1+l*dy);

      if (zoom<9) {
        s=10-zoom;
      }
      else {
        s=1;
      }

      tile.set(k, l, sample(x, y, s) );
    }
  }
  return tile;
}
//save tile



color sample( float x, float y, int size) {

  long temp=0;
  int sh=size/2;
  int shs=sh*sh;
  color tColor;
  
  int v;
  int count=0;
  if (sh>0) {
    for (int i=-sh;i<sh;i++) {
      for (int j=-sh;j<sh;j++) {
        v=(int)bild.get(round(constrain(x+i, 0, bild.width-1)), round(constrain(y+j, 0, bild.height-1)));
        if(v<MAX){
          temp+=v;
          count++;
        }
      }
    }
    if(count>0){
       tColor=(color)int(temp/count);
    }else{
       tColor=color(255,255,255,255);
    }
  }
  else {
    
    /*
    int xx=floor(x);
    int yy=floor(y);

    PVector p1= new PVector(x, y, (int)(bild.get(xx, yy)));
    PVector p2= new PVector(x+1, y, (int)(bild.get(xx+1, yy)));
    PVector p3= new PVector(x+1, y+1, (int)(bild.get(xx+1, yy+1)));
    PVector p4= new PVector(x, y+1, (int)(bild.get(xx, yy+1)));
    tColor=(color)(interpol(x, y, p1, p2, p3, p4)); 
*/

    tColor=bild.get(round(constrain(x, 0, bild.width-1)+0.5), round(constrain(y, 0, bild.height-1)+0.5));
  }
  return tColor;
}





int interpol( float x, float y, PVector p1, PVector p2, PVector p3, PVector p4) {

  PVector p0=new PVector(x, y, 0.0);
  PVector rm=new PVector();
  rm= PVector.sub(p2, p3);
  float m=rm.mag();

  p1.sub(p0);
  p2.sub(p0);
  p3.sub(p0);
  p4.sub(p0);

  float w1=constrain(m/p1.mag(), 0.01, 1.0);
  float w2=constrain(m/p2.mag(), 0.01, 1.0);  
  float w3=constrain(m/p3.mag(), 0.01, 1.0);  
  float w4=constrain(m/p4.mag(), 0.01, 1.0);

  return round((w1*p1.z+w2*p2.z+w3*p3.z+w4*p4.z)/(w1+w2+w3+w4));
}


float tile2BildX(int tile, int zoom) {
  return lon2Bild(tile2lon(tile, zoom));
}

float tile2BildY(int tile, int zoom) {
  return lat2Bild(tile2lat(tile, zoom));
}

float lon2Bild(float lon) {

  float d=5.0/6000;
  //lon=constrain(lon, 5.0, 10.0);
  return (lon-startLon)/d;
}

float lat2Bild(float lat) {

  float d=5.0/6000;
  //lat=constrain(lat, 45.0, 50.0);
  return (lat-startLat)/d;
}




float tile2lon(int x, int zoom) {
  return x / pow(2.0, zoom) * 360.0 - 180;
}

float tile2lat(int y, int zoom) {
  float n = PI - (2.0 * PI * y) / pow(2.0, zoom);
  return degrees(atan(sinh(n)));
}

int  lon2tile(float lon, int zoom) {
  return floor( ((lon + 180) / 360) * (1<<zoom) );
}

int lat2tile(float lat, int zoom) {
  return floor( (1 - log(tan(radians(lat)) + 1 / cos(radians(lat))) / PI) / 2 * (1<<zoom) ) ;
}

String getTileNumber(final float lat, final float lon, final int zoom) {
  int xtile = lon2tile(lon, zoom);
  int ytile = lat2tile(lat, zoom);
  return ("/" + zoom + "/" + xtile + "/" + ytile);
}

String getURL( float lon, float lat, int zoom) {
  return "http://tile.openstretmap.org/"+getTileNumber(lon, lat, zoom);
}

float sinh(float x) {
  return 0.5*(exp(x)-exp(-x));
}

