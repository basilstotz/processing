float r[]= {
  0.3870, 0.7233, 1.0000, 1.5236, 5.2033, 9.5370, 19.191, 30.068
};
float T[]= {
  0.2408, 0.6151, 1.0000, 1.8808, 11.862, 29.447, 84.016, 164.79
};
String l[]= {
  "Mercur", "Venus", "Terra", "Mars", "Jupiter", "Saturn", "Uranus", "Neptun"
};
PImage merkur, venus, erde, mars, jupiter, saturn, neptun, uranus;

float r_1;
float T_1;

float r_2;
float T_2;

float r_max;
float T_min;

float time;
float skale;
float t_skale;
float i_skale;

boolean left, right;

float Height=800.0;
float Width=600.0;
float Rand=20.0;

int eins, zwei;
int t_eins, t_zwei;

void kreis() {
  noStroke();
  fill(0, 0, 255);
  ellipse(Width/2.0, Width/2.0, Width-2.0*Rand, Width-2.0*Rand);
}


void updateScales() {

  float factor;

  r_1=r[eins];
  T_1=T[eins];

  r_2=r[zwei];
  T_2=T[zwei];

  if (r_1>r_2) {
    r_max=r_1;
  }
  else {
    r_max=r_2;
  }
  if (T_1<T_2) {
    T_min=T_1;
  }
  else {
    T_min=T_2;
  }

  skale=(Width-2.0*Rand)/(2.0*r_max);

  factor=r_1/r_2;
  if (factor<1.0) {
    factor=1.0/factor;
  }

  t_skale=T_min*sqrt(factor);
  kreis();
}

void setup() {
  size((int)Width, (int)Height);
  frameRate(60);

  merkur=loadImage("merkur.jpg");
  venus=loadImage("venus.jpg");
  erde=loadImage("erde.jpg");
  mars=loadImage("mars.jpg");
  jupiter=loadImage("jupiter.jpg");
  saturn=loadImage("saturn.jpg");
  uranus=loadImage("uranus.jpg");
  neptun=loadImage("neptun.jpg");

  eins=1;
  zwei=2;

  time=0.0; 

  updateScales();

  background(0, 0, 0);
  kreis();
}

void displayPlanet(PImage pl) {
  fill(0);
  rect(0, 0, Width, Height-100);
  fill(255);
  textSize(60);
  textAlign(CENTER);
  text(l[eins], Width/2.0, 80);
  i_skale= Width/pl.width;
  image(pl, 0, 100, i_skale*pl.width, i_skale*pl.height);
  fill(128);
  textSize(30);
  text("   Abstand: "+r[eins]+" [AE]", Width/2.0, 100+i_skale*pl.height+70);
  text("Umlaufzeit: "+T[eins]+" [a]", Width/2.0, 100+i_skale*pl.height+110);
}

boolean mouseOver(float x, float y, float w, float h) {
  return( (mouseX>x)&&(mouseX<x+w)&&(mouseY>y)&&(mouseY<y+h)&&mousePressed);
}

void draw() {
  float x_1, y_1, x_2, y_2, phi_1, phi_2;

  fill(0);
  noStroke();
  rect(0, Height-100, Width, 100);

  fill(255);
  textSize(30);
  textAlign(CENTER);
  text("-", Width/2.0, Height-50);


  textAlign(RIGHT);
  if (left) {

    updatePixels();
    fill(0);
    rect(0, Height-100, Width, 100);
    t_eins=eins;
    for (int i=0;i<8;i++) {
      if (mouseOver(0, Height-50*(i+2), Width/2.0, 50)) {
        t_eins=i;
        textSize(35);
        fill(255, 255, 0);
      }
      else {
        textSize(30);
        fill(255);
      }

      text(l[i], Width/2.0-20, Height-50*(i+1));
    }
  }
  else {
    fill(255);
    textSize(30);
    text(l[eins], Width/2.0-20, Height-50);
  }  


  textAlign(LEFT);
  if (right) {

    updatePixels();
    fill(0);
    rect(0, Height-100, Width, 100);
    t_zwei=zwei;
    for (int i=0;i<8;i++) {

      if (mouseOver(Width/2.0, Height-50*(i+2), Width/2.0, 50)) {
        t_zwei=i;
        textSize(35);
        fill(255, 255, 0);
      }
      else {
        textSize(30);
        fill(255);
      }

      text(l[i], Width/2.0+20, Height-50*(i+1));
    }
  }
  else {
    textSize(30);
    fill(255);
    text(l[zwei], Width/2.0+20, Height-50);
  }


  if (!(left||right)) {
    if (eins!=zwei) {
      //zeichnen   
      translate(Width/2.0, Width/2.0);
      phi_1=(2*PI/(T_1*360))*time*t_skale;
      phi_2=(2*PI/(T_2*360))*time*t_skale;
      x_1=r_1*skale*cos(phi_1);
      y_1=r_1*skale*sin(phi_1);
      x_2=r_2*skale*cos(phi_2);
      y_2=r_2*skale*sin(phi_2);
      stroke(255*cos(0.0003*time), 255*sin(0.0003*time), 0, 32);
      time+=1.0;
      line(x_1, y_1, x_2, y_2);
    }
    else {

      switch(eins) {
      case 0: 
        displayPlanet(merkur);
        break;
      case 1: 
        displayPlanet(venus);
        break;
      case 2: 
        displayPlanet(erde);
        break;
      case 3: 
        displayPlanet(mars);
        break;
      case 4: 
        displayPlanet(jupiter);
        break;
      case 5: 
        displayPlanet(saturn);
        break;
      case 6: 
        displayPlanet(uranus);
        break;
      case 7: 
        displayPlanet(neptun);
        break;
      }
    }
  }
}


void mousePressed() {
  if (mouseOver(0, Height-100, Width/2.0, 100)) {
    loadPixels();
    left=true;
  }
  if (mouseOver(Width/2.0, Height-100, Width/2.0, 100)) {
    loadPixels();
    right=true;
  }
}

void mouseReleased() {
  if (left) {
    if (eins!=t_eins) {
      eins=t_eins;
      background(0);
      updateScales();
    }
    else {
      updatePixels();
    }
    left=false;
  }
  if (right) {
    if (zwei!=t_zwei) {
      zwei=t_zwei;
      background(0);
      updateScales();
    }
    else {
      updatePixels();
    }
    right=false;
  }
}

