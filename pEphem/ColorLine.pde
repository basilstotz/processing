class ColorLine {

  PImage linie;
  float breite;
  int trans;

  ColorLine() {
    linie= createImage(1000, 1, ARGB);
    breite=1.0;
    blend(color(255), color(255));
    trans=255;
  }


  void transparency(float _t){
    trans=int(_t);
  }

  void width(float _s) {
    breite=_s;
  } 

  void blend(color c1, color c2) {
    for (int i=0;i<1000;i++) {
      linie.set(i, 0, lerpColor(c1, c2, float(i)/1000.0));
    }
  }


  void draw(float x1, float y1, float x2, float y2) {

    PVector v= new PVector(x2-x1, y2-y1);
    float m=v.mag();
    float h=v.heading();

    pushMatrix();

    translate(x1, y1);
    rotate(h);
    tint(255,trans);
    image(linie, 0, breite/-2.0, m, breite);
    noTint();
    popMatrix();
  }
}

