class Planet {

  String name;
  float radius;
  float period;
  float phase;
  PImage picture;
  color farbe;

  Planet(String _name, float _radius, float _period, float _phase, PImage _picture, color _farbe) {
    name=_name;
    radius=_radius;
    period=_period;
    phase=_phase;
    picture=_picture;
    farbe=_farbe;
  }


  void setName(String _name) {
    name=_name;
  }

  String getName() {
    return name;
  }

  void setRadius(float _radius) {
    radius=_radius;
  }

  float getRadius() {
    return radius;
  }

  void setPeriod(float _period) {
    period=_period;
  }

  float getPeriod() {
    return period;
  }

  void setPhase(float _phase) {
    phase=_phase;
  }

  float getPhase() {
    return phase;
  }

  void setPicture(PImage _picture) {
    picture=_picture;
  }

  PImage getPicture() {
    return picture;
  }

  void setColor(color _farbe) {
    farbe=_farbe;
  }

  color getColor() {
    return farbe;
  }
  //*****************************************************

  PVector getPosition(float _time) {
    float x, y;

    if (period>0.0) {
      float phi=2*PI*(_time/period)+phase;
      x=radius*cos(phi);
      y=radius*sin(phi);
    }
    else {
      x=0.0;
      y=0.0;
    }


    return new PVector(x, y);
  }
}

