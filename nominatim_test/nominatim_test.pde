import damkjer.ocd.*;

import controlP5.*;

import proxml.*;

Nominatim nominatim;

ControlP5 controlP5;
Textfield query;

boolean zeige=false;

void setup() {

  size(400, 800);

  controlP5 = new ControlP5(this);
  query= controlP5.addTextfield("query", 50, 20, 250, 20);
  query.hide();
  query.setLabel("");
  PFont p = createFont("Georgia", 12); 
  controlP5.setControlFont(p, 12);

  nominatim = new Nominatim(this);
}

void draw() {
  background(255);
  if (zeige) {
    query.show();
    nominatim.showResults();
  }
  else {
    query.hide();
  }
}

public void query(String theQuery) {//println("aha");
  nominatim.searchPlace(theQuery);
}


void keyPressed() {
  switch(key) {
  case 's': zeige=!zeige;
            break;
            default: break;
  }
}

