PImage img;

float temp[]= {
  1.0e20, 
  15000.0, 
  10000.0, 
  6000.0, 
  5000.0, 
  4000.0, 
  3000.0, 
  2500.0, 
  2000.0, 
  1500.0
};
float redi[]= {
  0.24, 0.27, 0.28, 0.33, 0.35, 0.38, 0.44, 0.48, 0.52, 0.59
};
float greeni[]= {
  0.23, 0.26, 0.28, 0.33, 0.35, 0.38, 0.40, 0.42, 0.41, 0.39
};

float[] tredi = new float[10];
float[] tgreeni = new float[10];

float[] std = new float[3];
float[] white = new float[3];
float[] rgb = new float[3];
float[] xyz = new float[3];


float[] tmp = new float[10];

float intensity;
float faktor, sfaktor;

float tMin, tMax;
float rgbMax, whiteMax, allMax;

float zz;

float inter( float t[], float v[], float T) {
  int i=0;
  while (T>t[i])i++;
  return map(T-t[i-1], 0.0, t[i]-t[i-1], v[i-1], v[i]);
}


float[] transform(float[] H) {  



  float[] r = new float[2];
  float[] g = new float[2];
  float[] s = new float[2];
  float[] h = new float[2];
  float[] f = new float[3];


  float[] R = new float[2];
  float[] G = new float[2];
  float[] B = new float[2];


  float rot, gruen, blau;

  R[0]=0.63+0.1;
  R[1]=0.33-0.1;
  G[0]=0.21;
  G[1]=0.71;
  B[0]=0.14-0.1;
  B[1]=0.16-0.1;

  s[0]=B[0];
  s[1]=B[1];

  r[0]=R[0]-s[0];
  r[1]=R[1]-s[1];

  g[0]=G[0]-s[0];
  g[1]=G[1]-s[1];


  h[0]=H[0]-s[0];
  h[1]=H[1]-s[1];

  rot= (h[1]*g[0]-h[0]*g[1])/(r[1]*g[0]-r[0]*g[1]);
  gruen= (h[0]-rot*r[0])/g[0];
  blau=1.0-rot-gruen;

  f[0]=rot;
  f[1]=gruen;
  

  return f;
}


void initit() {
  
  float[] in = new float[2];
  float[] out = new float[2];
  
  for (int i=0;i<10;i++) {
    tmp[i]=1000.0/temp[i];
    tmp[0]=0.0;
  }
  for(int i=0;i<10;i++){
    in[0]=redi[i];
    in[1]=greeni[i];
    out=transform(in);
    tredi[i]=out[0];
    tgreeni[i]=out[1];
  }
    
}

void transformer() {
  //http://www.brucelindbloom.com (xyz->rgb)
  if (false) {
    xyz[0]=2.37*rgb[0]-0.90*rgb[1]-0.47*rgb[2];
    xyz[1]=-0.51*rgb[0]+1.45*rgb[1]+0.09*rgb[2];
    xyz[2]=0.00*rgb[0]-0.01*rgb[1]+1.00*rgb[2];
  }
  else {
    xyz[0]=1.00*rgb[0]+0.00*rgb[1]+0.00*rgb[2];
    xyz[1]=0.00*rgb[0]+1.00*rgb[1]+0.00*rgb[2];
    xyz[2]=0.00*rgb[0]-0.00*rgb[1]+1.00*rgb[2];
  }   

  for (int j=0;j<3;j++) {
    xyz[j]*=3.0;
    if (xyz[j]<0.0)xyz[j]=-0.001;
  }
}


// Benutzerfunktionen

void setRange(float tmin, float tmax) {
  tMin=tmin;
  tMax=tmax;
}

void getMax() {
  int n=20;
  rgbMax=0.0;
  whiteMax=0.0;
  allMax=0.0;

  float d=(tMax-tMin)/n*1.0;
  for (int i=0;i<n;i++) {
    setWhite(i*d+tMin);
    update();
    for (int j=0;j<3;j++) {
      if (white[j]>whiteMax)whiteMax=white[j];
      if (rgb[j]>rgbMax)rgbMax=rgb[j];
    }
  }
  allMax=3.0*rgbMax;
  if (allMax<whiteMax)allMax=whiteMax;
}




void setWhite(float T) {
  white[0]=inter(tmp, tredi, 1000.0/T);
  white[1]=inter(tmp, tgreeni, 1000.0/T);
  white[2]=1.0-(white[0]+white[1]);
}

void setStd(float T) {
  std[0]=inter(tmp, tredi, 1000.0/T);
  std[1]=inter(tmp, tgreeni, 1000.0/T);
  std[2]=1.0-(std[0]+std[1]);
}


void setIntensity(float in) {
  intensity=in;
}

void setFaktor(float sf) {
  sfaktor=sf;
}

void update() {    

  float lfaktor= sfaktor;
  float[] lrgb = new float[3];

  lrgb[0]=white[0]-lfaktor*std[0];
  lrgb[1]=white[1]-lfaktor*std[1];
  lrgb[2]=white[2]-lfaktor*std[2];

  for (int j=0;j<3;j++) {
    if (lrgb[j]<=0.0) {
      float tf=white[j]/std[j];
      if (tf<lfaktor)lfaktor=tf;
    }
  }
  lrgb[0]=white[0]-lfaktor*std[0];
  lrgb[1]=white[1]-lfaktor*std[1];
  lrgb[2]=white[2]-lfaktor*std[2];

  faktor=lfaktor*intensity;
  for (int j=0;j<3;j++)rgb[j]=intensity*lrgb[j];
  transformer();
}


void setup() {
  size(256, 256);
  
  background(0);
  image(img,0,0);
  initit();
  zz=0.0;
  noStroke();

  setStd(3000.0); 
  setRange(2550.0, 6000.0);
  setFaktor(1.0);
  setIntensity(1.0);

  getMax();
  println("whiteMax rgbMax allMax");
  print(whiteMax+"  ");
  println(3.0*rgbMax);

  println("Skala ="+1.0/(allMax));

  println("whiteMax rgbMax allMax");
  print(whiteMax/allMax+"  ");
  println(3.0*(rgbMax/allMax));



  /*
  for (float tt=2000.0;tt<=10000.0;tt+=500.0) {
   
   setWhite(tt);
   update();
   
   
   print(nfs(tt, 5, 0)+"  ");
   print(nfs(faktor, 1, 2)+"  ");
   print(nfs(xyz[0], 1, 2)+" ");
   print(nfs(xyz[1], 1, 2)+" ");
   print(nfs(xyz[2], 1, 2)+" ");
   print(nfs(faktor+(xyz[0]+xyz[1]+xyz[2])/3.0, 1, 2)+" :: ");
   print(nfs(white[0], 1, 2)+" ");
   print(nfs(white[1], 1, 2)+" ");
   println(nfs(white[2], 1, 2)+" ");
   }
   println("fertig");
   */
  fill(255);
  textSize(20);
  text("RGBW-LED-Treiber", 40, 40);
  textSize(12);
  text(nfs(tMin, 3, 0)+"K", 25, 110);
  text(nfs(tMax, 3, 0)+"K", 190, 110);
}

void draw() {
  translate(30, 0);
  //print("*");
  //background(128);
  //float zz=sin(0.0001*millis());
  zz+=0.005;
  if (zz>1.0)noLoop();
  float ti=map(zz, 0.0, 1.0, tMin, tMax);
  //float ti=3000.0;
  setWhite(ti);

  update();

  float skala=1.0/(allMax);
  float rskala=1.0/rgbMax;
  float wskala=3.0; ///whiteMax;
  float xx=zz*200;

  if (skala*faktor*std[0]<=1.0) {
    fill(rskala*std[0]*255*faktor, rskala*std[1]*255*faktor, rskala*std[2]*255*faktor);
  }
  else {
    fill(128);
  }
  rect(xx, 160, 1, faktor*20);

  fill(intensity*wskala*white[0]*255, intensity*wskala*white[1]*255, intensity*wskala*white[2]*255);
  rect(xx, 50, 1, 50);
  fill(skala*xyz[0]*255.0, skala*xyz[1]*255.0, skala*xyz[2]*255.0);
  //fill(255);
  rect(xx, 120, 1, 20);

  if (skala*xyz[0]<=1.0) {
    fill(skala*xyz[0]*255.0, 0*xyz[1]*255.0, 0*xyz[2]*255.0);
  }
  else {
    fill(128);
  }
  rect(xx, 180, 1, skala*xyz[0]*20.0);

  if (skala*xyz[1]<=1.0) {
    fill(0*xyz[0]*255.0, skala*xyz[1]*255.0, 0*xyz[2]*255.0);
  }
  else {
    fill(128);
  }
  rect(xx, 200, 1, skala*xyz[1]*20.0);

  if (skala*xyz[2]<=1.05) {  
    fill(0*xyz[0]*255.0, 0*xyz[1]*255.0, skala*xyz[2]*255.0);
  }
  else {
    fill(128);
  }
  rect(xx, 220, 1, skala*xyz[2]*20);  

  //fill(255);
  //text(ti,200,200);
  //rect(mouseX,mouseY,10,10);
}

