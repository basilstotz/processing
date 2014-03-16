ColorLine linie;

void setup(){
  size(500,500,P2D);
  linie=new ColorLine();
  linie.blend(color(255,0,0,128),color(0,255,0,128));
}

void draw(){
  background(0);
  linie.draw(100,100,200,200);
}
