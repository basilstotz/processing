int Width, Height;

PImage Cache;
PImage[][] cache;
boolean[][] cacheOk;

int cacheXSize;
int cacheYSize;
int cacheXul;
int cacheYul;
int cacheXlr;
int cacheYlr;

int oldXul, oldYul;
int oldXlr, oldYlr;

float xllSTRM;
float yllSTRM;
float cellSTRM;

float xll, yll, cell;

int zoomLevel;
int zoom;

boolean running;

float x, y;

void setup() {
  Width=1000;
  Height=500;

  size(Width, Height);

  xllSTRM=5.0;
  yllSTRM=45.0;
  cellSTRM=5.0/6000.0;


  zoomLevel=4;
  zoom=round(pow(2, 5)/pow(2, zoomLevel));
  cell=cellSTRM*zoom;

  cacheXSize=2+(Width/256);
  cacheYSize=2+(Height/256);

  cacheOk =new boolean[cacheXSize][cacheYSize];

  for (int i=0;i<cacheXSize;i++) {
    for (int j=0;j<cacheYSize;j++) {
      cacheOk[i][j]=false;
    }
  }

  cache = new PImage[cacheXSize][cacheYSize];

  Cache= createImage(cacheXSize*256, cacheYSize*256, ARGB);

  clearOK();

  x=y=1;
  oldYul=oldXul=-1;
  oldYlr=oldXlr=-1;
  
  cacheXul=0;
  cacheYul=0;
  cacheXlr=0;
  cacheYlr=0;

  running=false;
}


void draw() {

  if (mousePressed) {
    x-=mouseX-pmouseX;
    y-=mouseY-pmouseY;
  }
  x=constrain(x, 0, 6000-Width);
  y=constrain(y, 0, 6000-Height);

  displayImage(x, y);
}


void displayImage(float x, float y) {

  cacheXul=int(x)/256;
  cacheYul=int(y)/256;
  
  cacheXlr=int(x+Width)/256;
  cacheYlr=int(y+Height)/256;

  if ((oldXul!=cacheXul)||(oldYul!=cacheYul)||(oldXlr!=cacheYlr)||(oldYlr!=cacheYlr)) {

    if (!running) {
      thread("loaderThread");   
      oldXul=cacheXul;
      oldYul=cacheYul;
      oldXlr=cacheXlr;
      oldYlr=cacheYlr;
    }
  }
  int xc=int(x-(cacheXul)*256);
  int yc=int(y-(cacheYul)*256);
  
  copy(Cache, xc, yc, Width, Height, 0, 0, Width, Height);
  text(xc+" "+yc,0,20);
  text(cacheXul+" "+cacheYul,0,40);
}

void clearOK() {
  for (int i=0;i<cacheXSize;i++) {
    for (int j=0;j<cacheYSize;j++) {
      cacheOk[i][j]=false;
    }
  }
}


void loaderThread() {

  running=true;
  PImage pi=createImage(256, 256, ARGB);
  clearOK();
  for (int i=0;i<cacheXSize;i++) {
    for (int j=0;j<cacheYSize;j++) {
      if (cacheOk[i][j]==false) {
        
        String s="strm"+nf(cacheXul+i, 2)+"-"+nf(cacheYul+i, 2)+".tif";
        println(s);
        pi=loadImage(s);
        //cache[i][j]=pi;
        cacheOk[i][j]=true;
        Cache.copy(pi, 0, 0, pi.width, pi.height, i*pi.width, j*pi.height, pi.width, pi.height);
      }
    }
    running=false;
  }
}

