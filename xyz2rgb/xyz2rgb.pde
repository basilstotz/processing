int first;

PImage img;

float temp[]= {
  100000.0, 
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
  0.24, 0.26, 0.29, 0.33, 0.35, 0.38, 0.43, 0.48, 0.52, 0.59
};
float greeni[]= {
  0.23, 0.26, 0.29, 0.33, 0.35, 0.38, 0.41, 0.42, 0.42, 0.39
};


float lambda[]= {
  390.0, 450.0, 480.0, 490.0
};
float rt[]= {
  0.17, 0.16, 0.13
};
float gn[]= {
  0.01, 0.03, 0.06
};
float[] R = new float[2];
float[] G = new float[2];
float[] B = new float[2];

float[] H = new float[2];

float[] f = new float[3];

int gr;


color rainbow(float lambda) {
  color t;
  t=color(255, 255, 255);
  return t;
}

void setup() {
  gr=300;
float dx,dy;
  first=0;
  size(gr, gr);



    R[0]=0.63;
    R[1]=0.33;
    G[0]=0.21;
    G[1]=0.71;
    B[0]=0.14;
    B[1]=0.16;
    /*
    dx=((R[0]+G[0]+B[0])/3.0)-(1.0/3.0);
    dy=((R[1]+G[1]+B[1])/3.0)-(1.0/3.0);

    R[0]-=dx;
    R[1]-=dy;
    G[0]-=dx;
    G[1]-=dy;
    B[0]-=dx;
    B[1]-=dy;
   */

  img=loadImage("CIE.jpg");
  noStroke();

  ;
}

float[] transform(float[] H) {  



  float[] r = new float[2];
  float[] g = new float[2];
  float[] s = new float[2];
  float[] h = new float[2];
  float[] f = new float[3];

  float rot, gruen, blau;
  float dx=0.0;
  float dy=0.0;


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
  f[2]=blau;

  return f;
}


void draw() {

float L,as,bs;
float Xn=0.33;
float Yn=0.33;

  float rot, gruen, blau;
  float gra=gr;
  //translate(0,-gr);
  background(200);
  image(img, 0, 0, gr*0.8, gr*0.9);
  fill(200);
  beginShape();
  vertex(0, gr);
  vertex(gr, gr);
  vertex(gr, 0);
  endShape();

  /*
  stroke(5);
   fill(0);
   line(0.17*gr, 0.01*gr, 0.73*gr, 0.27*gr);
   fill(128);
   beginShape();
   curveVertex(0.74*gra,0.26*gra);
   curveVertex(0.73*gra, 0.27*gra);
   curveVertex(0.3*gra, 0.7*gra);
   curveVertex(0.08*gra, 0.83*gra);
   curveVertex(0.01*gra, 0.63*gra);
   curveVertex(0.03*gra, 0.35*gra);
   curveVertex(0.1*gra, 0.1*gra);
   curveVertex(0.17*gra, 0.01*gra);
   curveVertex(0.165*gra, 0.00*gra);
   endShape();
   */
  fill(128, 128, 128, 255);
  noStroke();
  beginShape();
  vertex(R[0]*gr, R[1]*gr);
  vertex(G[0]*gr, G[1]*gr);
  vertex(B[0]*gr, B[1]*gr);
  vertex(R[0]*gr, R[1]*gr);
  endShape(); 

  //line(0.73*gr,0.27*gr,);
  //line(0.3*gr,0.7*gr,);
  // line(0.08*gr,0.83*gr,);
  //line(0.01*gr,0.63*gr,);
  //line(0.06*gr,0.3*gr,);
  //line(0.1*gr,0.1*gr,
  noStroke();



  fill(0);

  //translate(10,-10+gr);
  //scale(0.8*100,-0.8*100);
  //line(0,0,0,1);
  //line(0,0,1,0);
  float mm;
  for (int i=0;i<10;i++) {
    H[0]=redi[i];
    H[1]=greeni[i];
    f=transform(H);
    if (first==0) {
      println(nfs(temp[i], 3, 0)+" "+
        nfs(f[0], 1, 2)+"  "+
        nfs(f[1], 1, 2)+"  "+
        nfs(1.0-f[0]-f[1], 1, 2)+"  "+
        nfs( (f[0]+f[1]) / (2.0*(1.0-f[0]-f[1])), 1, 2)+"  "+
        nfs(f[0]/f[1], 1, 2)
        );
    }
    stroke(0);
    mm=f[0];
    if (f[1]>mm)mm=H[1];
    if (1.0-H[0]-H[1]>mm)mm=1.0-H[0]-H[1];
    fill(f[0]*255/mm, f[1]*255/mm, (1-0-f[0]-f[1])*255/mm);
    ellipse(H[0]*gr, H[1]*gr, 10, 10);
    fill(0);
    textSize(8);
    text(nfs(temp[i]/1000.0, 1, 1), H[0]*gr-5, H[1]*gr-5);
  }
  noStroke();
  first=1;

  H[0]=(mouseX*1.0)/(gr*1.0);
  H[1]=(mouseY*1.0)/(gr*1.0);

  f=transform(H);
  mouse();
  rot=f[0];
  gruen=f[1];
  blau=f[2];
  
  float Zn=1.0-Xn-Yn;
  float Z=1.0-H[0]-H[1];

L=116.0*pow(H[1]/Yn,1.0/3.0)-16.0;
as=500.0*(pow(H[0]/Xn,1.0/3.0)-pow(H[1]/Yn,1.0/3.0));
bs=200.0*(pow(H[1]/Yn,1.0/3.0)-pow(Z/Zn,1.0/3.0));

text("L*a*b: "+round(L)+" "+round(as)+" "+round(bs),100,220);

  //noStroke();
  stroke(255);
  fill(255, 0, 0);
  ellipse(R[0]*gr, R[1]*gr, 10, 10);
  fill(0, 255, 0);
  ellipse(G[0]*gr, G[1]*gr, 10, 10);
  fill(0, 0, 255);
  ellipse(B[0]*gr, B[1]*gr, 10, 10);
  noStroke();
  float maxi=0.0;
  if (rot>maxi)maxi=rot;
  if (gruen>maxi)maxi=gruen;
  if (blau>maxi)maxi=blau;
  fill(rot*255.0/maxi, gruen*255.0/maxi, blau*255.0/maxi);

  if ( (rot+gruen<1.0)&&(rot>0.0)&&(gruen>0.0)) {
    ellipse(H[0]*gr, H[1]*gr, 10, 10);
    rect(gr-100, gr-95, 45, 90);
    fill(rot*255, gruen*255, blau*255);
    rect(gr-55, gr-95, 45, 90);
  }
  fill(0);
  text(nfs(H[0], 1, 2)+" "+nfs(H[1], 1, 2)+" "+nfs(1.0-H[0]-H[1], 1, 2)+"  "+nfs(0.3333/maxi, 1, 2), 20+H[0]*gr, H[1]*gr);



  fill(255);
  stroke(5);
  line(0, gr, gr, 0);
  noStroke();

  fill(0);
  rect(180, 190, 20, -50);
  rect(210, 190, 20, -50);
  rect(240, 190, 20, -50);
  rect(270, 190, 20, -50);
  fill(255);
  rect(180, 190, 20, (0.3333/maxi)*-50);
  fill(255, 0, 0);
  rect(210, 190, 20, rot*-50);
  fill(0, 255, 0);
  rect(240, 190, 20, gruen*-50);
  fill(0, 0, 255);
  rect(270, 190, 20, blau*-50);

  fill(0);
  text(nfs(0.333/maxi, 1, 2)+"  "+nfs(rot, 1, 2)+"   "+nfs(gruen, 1, 2)+"   "+nfs(blau, 1, 2), 180, 135);

  float[] mx = new float[3];
  float[] my = new float[3];
  float[] mz = new float[3];
  float[] v = new float[2];
  
  v[0]=1.0;v[1]=0.0;
  mx=transform(v);
  
    v[0]=0.0;v[1]=1.0;
  my=transform(v);
  
  v[0]=0.0;v[1]=0.0;
  mz=transform(v);
  fill(0);
  text(nfs(mx[0],1,2)+"  "+nfs(mx[1],1,2)+"  "+nfs(mx[2],1,2),80,250);
  text(nfs(my[0],1,2)+"  "+nfs(my[1],1,2)+"  "+nfs(my[2],1,2),80,265);
  text(nfs(mz[0],1,2)+"  "+nfs(mz[1],1,2)+"  "+nfs(mz[2],1,2),80,280);

}


void mouse() {

  if (mousePressed) {
    float mx=(mouseX*1.0)/(gr*1.0);
    float my=(mouseY*1.0)/(gr*1.0);



    if (dist(mx, my, G[0], G[1])<0.1) {
      G[0]=mx;
      G[1]=my;
    }

    if (dist(mx, my, B[0], B[1])<0.1) {
      B[0]=mx;
      B[1]=my;
    }

    if (dist(mx, my, R[0], R[1])<0.1) {
      R[0]=mx;
      R[1]=my;
    }
  }
}

