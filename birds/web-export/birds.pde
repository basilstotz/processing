/*
boolean android=false;
boolean standart=false;
boolean javascript=true;
*/

float vx, vy;
float x, y;
float sx, sy;
float ssx, ssy;

float time;
int explode;

int Width, Height;

float sizeGreen, sizeBall, sizeBox, sizeTree, sizeText;

int zustand;
int level, maxLevel;
int baelle;
int bonus;
int anzahl;

Stapel stapel;
Tree baum;

class Tree {

  float x, y, w, h, r;
  int level;

  Tree(float _x, float _y, float _w, float _h, float _r) {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    r=_r;
  }

  void display(int _level) {
    level=_level-1;
    if (_level>0) {
      fill(118, 79, 37);
      rect(x, y, w, -h*level);
      fill(37, 118, 46);
      ellipse(x+w/2.0, y-h*level-r/2.0, r, r);
    }
  }

  boolean collision(float ax, float ay) {
    if (level==-1)return false;
    boolean res=false;
    if ( (ax>x)&&(ax<x+w)&&(ay<y)&&(ay>y-h*level))res=true;
    if (sqrt( (ax-x)*(ax-x)+(ay-(y-h*level-r/2.0))*(ay-(y-h*level-r/2.0)) )<r/2)res=true;
    return res;
  }
}

class Stapel {

  int n;
  int score, highScore;
  float[] xpos;
  boolean[] on;
  int[] points;
  color[] farbe;
  float x, y;
  float w, h;

  Stapel(int _n, float _x, float _y, float _w, float _h) {
    n=_n;
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    highScore=0;
    score=0;
    xpos= new float[n];
    on= new boolean[n];
    points= new int[n];
    farbe= new color[n];
  }

  void init() {
    for (int i=0;i<n;i++) {
      on[i]=true;
      xpos[i]=x+random(w/2.5)-w/5.0;
      farbe[i]= color(random(255), random(255), random(255));
    }
  }

  void pointser() {
    for (int i=0;i<n;i++) {
      points[i]=round(random(9))*10+10;
    }
  }  



  void display() {
    float yy=y;

    textSize(sizeBox/2);
    textAlign(CENTER);
    for (int i=0;i<n;i++) {
      if (on[i]) {
        //fill(240, 132, 17);
        fill(farbe[i]);
        //rect(xpos[i], yy, w, -1.0*h, sizeBox/6);
        rect(xpos[i], yy, w, -1.0*h);
        fill(0);
        text(nf(points[i], 2), xpos[i]+w/2.0, yy-h/3.0);
        yy-=h;
      }
    }
  }

  boolean collision(float ax, float ay) {
    float yy=y;
    boolean res=false;
    for (int i=0;i<n;i++) {
      if (on[i]) {
        if ( (ax>xpos[i])&&(ax<xpos[i]+w)&&(ay<yy)&&(ay>yy-h) ) {
          on[i]=false;
          res=true;
          score+=points[i];
          if (score>highScore)highScore=score;
        }
        yy-=h;
      }
    }
    return(res);
  }

  int count() {
    int left=0;
    for (int i=0;i<n;i++) {
      if (on[i])left++;
    }
    return left;
  }

  void showScore(float x, float y) {
    fill(0);
    textSize(sizeText*1.5);
    textAlign(LEFT);
    text(nf(score, 4)+"/"+nf(highScore, 4), x, y);
  }


  void resetScore() {
    score=0;
  }
}

void setup() {
    size(800,480);
    Width=800;
    Height=480;

/*  
  if (android) {
    size(screenWidth, screenHeight);
    Width=screenWidth;
    Height=screenHeight;
    orientation(LANDSCAPE);
  }
  if(standart) {
    Width=round(screenWidth*0.75);
    Height=round(screenHeight*0.75); 
    size(Width, Height);
  }
 
 */

  sizeBox=Height/12.0;
  sizeGreen=Height/12.0;
  sizeBall=Width/48.0;
  sizeTree=Width/4.0;
  sizeText=Height/24.0;

  sx=Width/4.0;
  sy=Height-Width/4.0-sizeGreen;

  //ssx=sx;
  //ssy=sy;
  zustand=0;
  anzahl=8;
  bonus=round(anzahl*1.5);
  baelle=bonus;
  level=0;
  maxLevel=0;

  baum= new Tree(Width/2.0, Height-sizeGreen, sizeTree/10.0, sizeTree/4.0, sizeTree);

  stapel= new Stapel(anzahl, Width-Width/8.0, Height-sizeGreen, sizeBox, sizeBox);
  stapel.init();
  stapel.pointser();
}


void bild() {
  background(32, 32, 255);
  noStroke();
  fill(32, 255, 32);
  rect(0, Height-sizeGreen, Width, sizeGreen);
  //fill(240, 132, 17);
  //rect(Width-100, Height-100, 50, 50, 10);
  fill(0);
  ellipse(sx, sy, sizeBall, sizeBall);
  fill(10, 80, 10);
  textAlign(CENTER);
  textSize(sizeText);
  text("www.amxa.ch", Width/2.0, Height-sizeGreen/3.0);
} 

void draw() {

  bild();
  baum.display(level);
  stapel.display();
  stapel.showScore(Width-Width/3.0, Height/14.0);

  fill(0);
  textSize(sizeText*1.5);
  text(nf(level, 0)+"/"+nf(maxLevel, 0), Height/12.0, Height/14.0);

  for (int i=0;i<baelle-1;i++) {
    fill(255, 0, 0);
    ellipse(i*sizeBall*1.5+sizeBall*1.5, Height-sizeGreen-sizeBall/2.0, sizeBall, sizeBall);
  }

  if (baelle==0) {
    baelle=-1;
    zustand=5;
    explode=200;
  }

  switch(zustand) {
  case 0: //bereit
    textSize(sizeText);
    fill(0);
    text("Ready", sizeGreen, Height-sizeGreen/3.0);
    break;
  case 1: //laden
    stroke(128);
    strokeWeight(sizeBall/5.0);
    strokeCap(ROUND);
    float mx=lerp(sx,mouseX,0.25);
    float my=lerp(sy,mouseY,0.25);
    line(sx, sy, mx,my);
    noStroke();
    fill(0);
    ellipse(sx, sy, sizeBall, sizeBall);
    fill(255, 0, 0);
    ellipse(mx, my, sizeBall, sizeBall);
    break;
  case 2: //fly
    time+=0.1;
    x=sx+vx*time;
    y=sy-vy*time+10.0*time*time;
    fill(255, 0, 0);
    ellipse(x, y, sizeBall, sizeBall);

    if ((x>Width)||(x<0)||(y>Height-sizeGreen)) {
      zustand=0;
    }

    if (baum.collision(x, y)) {
      zustand=0;
      // ssx=x;
      // ssy=y;
      // vx=0.0;
      // vy=0.0;
    }

    if (stapel.collision(x, y)) {
      if (stapel.count()==0) {
        zustand=4;
        explode=100;
      }
      else {
        zustand=3;
        explode=100;
      }
    }
    break;
  case 3: //explode
    if (explode>0) {
      explode-=3;
      float ss=((100.0-explode)/30.0)*sizeBox;
      fill(100, 255, 255, random(255));
      ellipse(x+random(20)-10, y+random(20)-10, ss, ss);
      fill(255, random(255), 255, random(255));
      ellipse(x+random(20)-10, y+random(20)-10, (random(100)/200.0)*ss, (random(100)/200.0)*ss);
      fill(255, 255, 255, 128);
      ellipse(x, y, ss, ss);
    }
    else {
      stapel.pointser();
      zustand=0;
    }
    break;
  case 4: 
    textAlign(CENTER);
    fill(255, 255, 0);
    textSize(2*sizeText);
    if (explode>0) {
      explode-=3;
      text("Next Level", (Width/2.0)+random(2*sizeText)-sizeText, (Height/2.0)+random(2*sizeText)-sizeText );
    }
    else {
      zustand=0;
      level++;
      if (level>maxLevel)maxLevel=level;
      baelle+=bonus;
      stapel.init();
      stapel.pointser();
    }
    break;
  case 5:
    textAlign(CENTER);
    fill(0, 255, 255);
    textSize(4*sizeText);
    if (explode>0) {
      explode-=3;
      text("Game Over", (Width/2.0)+random(4*sizeText)-2.0*sizeText, (Height/2.0)+random(4.0*sizeText)-2*sizeText );
    }
    else {
      zustand=0;
      level=0;
      baelle=bonus;
      stapel.init();
      stapel.pointser();
      stapel.resetScore();
    }
    break;
  }
}




void mousePressed() {
  if (zustand==0) {
    baelle-=1;
    zustand=1;
  }
}

void mouseReleased() {
  if (zustand==1) {
    vx=0.75*(sx-mouseX);
    vy=0.75*(mouseY-sy);
    x=sx;
    y=sy;
    time=0.0;
    zustand=2;
  }
}


