int SOL=0;
int MERKUR=1;
int VENUS=2;
int TERRA=3;
int MARS=4;
int JUPITER=5;
int SATURN=6;
int NEPTUN=7;
int URANUS=8;

Planet[] planets;
Planet eins, center, zwei;

int nEins,nZwei,nCenter;

int Width, Height, Rest, Rand, Radius;

float time;
float delta;

boolean update;

float rScale;
float tScale;
float dScale;
float tMax;

PFont font;

ColorLine linie;
color hintergrund;


int[][] combi;
int lMax;
int count;

int seq;
int maxLines;
int displace;
int mass;

void setup() {


//din a6 105x148

  Width=500;
  Height=500;
  size(Width, Height, P2D);

  mass=min(Width,Height);
  Rest=abs(Height-Width);

  font=loadFont("DroidSerif-Bold-24.vlw");
  textFont(font, 24);
  

  planets= new Planet[9];
  //                       name,radius,period,phase,picture,color
  planets[SOL]= new Planet("Sol", 0.0, 0.0, 0.0, loadImage("sonne.jpg"), color(255, 255, 255));
  planets[MERKUR]= new Planet("Merkur", 0.3870, 0.2408, 0.0, loadImage("merkur.jpg"), color(255, 255, 0));
  planets[VENUS]= new Planet("Venus", 0.7233, 0.6151, 0.0, loadImage("venus.jpg"), color(0, 255, 0));
  planets[TERRA]= new Planet("Terra", 1.0, 1.0, 0.0, loadImage("erde.jpg"), color(5, 190, 255));
  planets[MARS]= new Planet("Mars", 1.5236, 1.8808, 0.0, loadImage("mars.jpg"), color(255, 0, 0));
  planets[JUPITER]= new Planet("Juptier", 5.2033, 11.862, 0.0, loadImage("jupiter.jpg"), color(255, 160, 5));
  planets[SATURN]= new Planet("Saturn", 9.5370, 29.447, 0.0, loadImage("saturn.jpg"), color(81, 5, 255));
  planets[NEPTUN]= new Planet("Neptun", 19.191, 84.016, 0.0, loadImage("neptun.jpg"), color(175, 255, 5));
  planets[URANUS]= new Planet("Uranus", 30.068, 164.79, 0.0, loadImage("uranus.jpg"), color(64, 255, 0));

  time=0.0;
  //delta=1.0/365.25;

  linie = new ColorLine();
  
  combi= new int[600][3];
  lMax=0;
  for (int i=0;i<9;i++) { //center
    for (int j=0;j<9;j++) {
      for (int k=0;k<9;k++) {
        if (diff(i, j, k) ) {
          if (unique(i, j, k)) {         
            combi[lMax][0]=i;
            combi[lMax][1]=j;
            combi[lMax][2]=k;
            lMax++;
          }
        }
      }
    }
  } 
  
   seq=1;
   count=0;  
  //*****************************************************************************

  //eins=planets[MARS];
  //zwei=planets[URANUS];
  //center=planets[SATURN];
  
  linie.transparency(62);
  linie.width(2);
  
  maxLines=2000;

  
  hintergrund=color(0,0,20);
  
  //*****************************************************************************
  

  update=true;
}

void draw() {
  
  if (update)updatePlanets(); 
   
  displayLine(time);
  time+=delta;
  
  if(time>tMax){
    savePicture();
    //seq++;
    //if(seq>5){
    //  seq=1;
      update=true;
      println(count);
  
    //}
    
  }
}


void updatePlanets() {

  float fac;

  float rMax;
  float tMin;

  update=false;
  time=0.0;
  
  nEins=combi[count][1];
  nZwei=combi[count][2];
  nCenter=combi[count][0];
  
  eins=planets[nEins];
  zwei=planets[nZwei];
  center=planets[nCenter];

  count++;
  if(count>=lMax)noLoop();

  rMax=max(eins.getRadius()+center.getRadius(), zwei.getRadius()+center.getRadius());


  Rand=mass/15;
  Radius=mass-2*Rand;


  rScale=Radius/(2.0*rMax);

/*
  if((eins.getRadius()>0.1)&&(zwei.getRadius()>0.1)){
  fac=eins.getRadius()/zwei.getRadius();
  if (fac<1.0)fac=1.0/fac;
  }else{
    fac=1.0;
  }
*/

  //tMin=min(eins.getPeriod(), zwei.getPeriod(), center.getPeriod());

  tMax=max(eins.getPeriod(), zwei.getPeriod(), center.getPeriod());

 
  //dScale=sqrt(tMin*tMax);
  tScale=1.0;
  delta=tMax/float(maxLines);
  
  linie.blend(eins.getColor(),zwei.getColor());

  background(hintergrund);
}

void displayLine(float time) {

  PVector v1=eins.getPosition(time);
  PVector v2=zwei.getPosition(time);
  PVector v3=center.getPosition(time);

  v1.mult(rScale);
  v2.mult(rScale);
  v3.mult(rScale);
  pushMatrix();
  
  translate((Width+(Rest/2))/2.0, Height/2.0);
  translate(v3.x, v3.y);  

  linie.draw(v1.x,v1.y,v2.x,v2.y);

  popMatrix();
  

}


void savePicture(){
      String n=nf(nCenter,0)+nf(nEins,0)+nf(nZwei,0)+"-"+
             center.getName()+"-"+
             eins.getName()+"-"+
             zwei.getName()+"-"+
             nf(time,0,3)+"-"+
             nf(delta*365.25,0,3);
    //fill(255);
    //text(n,20,20);
    //saveFrame(n+".png");
    saveFrame("HiRes/tiff/"+n+".tiff");
    saveFrame("HiRes/jpeg/"+n+".jpg");
    //fill(hintergrund);
    //rect(0,0,Width,20);
}

boolean diff(int i, int j, int k) {
  return ((i!=j)&&(i!=k)&&(k!=j));
  //return true;
}

boolean unique(int i, int j, int k) {

  boolean u=true;
  for (int n=0;n<lMax;n++) {
    if (i==combi[n][0]) {
      if ((combi[n][1]==k)&&(combi[n][2]==j))u=false;
    }
  }
  return u;
}
