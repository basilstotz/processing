class ColorLine {

  PImage linie;
  float breite;
  int trans;

  ColorLine() {
    linie= createImage(1024, 2, ARGB);
    breite=1.0;
    trans=255;
    blend(color(0, trans), color(0, trans));
  }


  void transparency(float _t) {
    trans=int(_t);
  }

  void width(float _s) {
    breite=_s;
  } 

  void blend(color c1, color c2) {
    for (int i=0;i<1024;i++) {
      for (int j=0;j<2;j++) {
        linie.set(i, 0, lerpColor(c1, c2, float(i)/1000.0));
      }
    }
  }


  void draw(float x1, float y1, float x2, float y2) {

    PVector v= new PVector(x2-x1, y2-y1);
    float m=v.mag();
    float h=v.heading();

    pushMatrix();

    translate(x1, y1);
    rotate(h);
    noStroke();
    beginShape(QUAD);
    texture(linie);
    vertex(0,0,0,0);
    vertex(m,0,1024,0);
    vertex(m,breite,1024,1);
    vertex(0,breite,0,1);
    endShape();
    
    //image(linie, 0, breite/-2.0, m, breite);
    
    popMatrix();
  }
}

