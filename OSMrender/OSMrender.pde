
import java.util.Map;

XML root;


XML node[];
XML way[];

float minlat, minlon, maxlat, maxlon;


int Width, Height;

HashMap<Long,Long> hm = new HashMap<Long,Long>();


void setup() {
  Width=800;
  Height=600;

  size(Width, Height);

  //root= loadXML("schweiz_natural.osm");

  hm.put(35464356L,3453242L);
  //println(hm.get(Long.parseLong("35464356")));

  exit();
  
  //Bounds
  XML bounds=root.getChild("bounds");
  minlat= bounds.getFloat("minlat");
  maxlat= bounds.getFloat("maxlat");
  minlon= bounds.getFloat("minlon");
  maxlon= bounds.getFloat("maxlon");





  drawOSM(root);


  noLoop();
}


void drawOSM(XML osm) {
  background(200, 255, 200);
  XML[] node=osm.getChildren("node");
  for (int i=0;i<node.length;i++) {
    drawNode(node[i], color(0, 255, 0));
  }
  XML[] way=osm.getChildren("way");
  for (int i=0;i<way.length;i++) {
    drawWay(way[i]);
  }
}

void drawNode(XML node, color c) {




  PVector pos=getNode(node);

  String name="*";
  String was="";

  XML[] tag=node.getChildren("tag");
  for (int i=0;i<tag.length;i++) {
    String theKey=tag[i].getString("k");
    if (theKey.equals("name")) {
      name=tag[i].getString("v");
    }
    else {
      was=tag[i].getString("v");
    }
  }

  noStroke();
  fill(c);
  ellipse(pos.x, pos.y, 10, 10);

  if (was.equals("hamlet")) {
    fill(255, 120, 0);
    text(name, pos.x+10, pos.y-10);
    ellipse(pos.x, pos.y, 20, 20);
  }

  if (was.equals("peak")) {
    fill(120, 120, 120);
    text(name, pos.x+5, pos.y-5);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    vertex(0, -10);
    vertex(-10, 5);
    vertex(10, 5);
    endShape(CLOSE);
  }
}

void drawWay(XML way) {

  PVector pos, pos0;
  String was="";
  String name="*";

  XML[] tag=way.getChildren("tag");
  for (int i=0;i<tag.length;i++) {
    if (tag[i].getString("k")=="name") {
      name=tag[i].getString("v");
    }
    else {
      was=tag[i].getString("v");
    }
  }

  stroke(255);
  strokeWeight(1);
  if (was.equals("forest")||was.equals("wood"))stroke(0, 126, 0);
  if (was.equals("water")||was.equals("stream")||was.equals("river"))stroke(50, 50, 256);
  if (was.equals("glacier"))stroke(240);
  if (was.equals("rock"))stroke(128);
  if (was.equals("allotments"))stroke(0, 200, 0);
  if (was.equals("meadow"))stroke(128, 128, 0);
  if (was.equals("beach"))stroke(0, 0, 128);
  if (was.equals("farmland"))stroke(0, 255, 255);

  if (was.equals("river"))strokeWeight(3);

  XML[] n=way.getChildren("node");
  pos0=getNode(n[0]);

  if (name.equals("*")) {
    //text("("+was+")", pos0.x, pos0.y);
  }
  else {
    text(name+" ("+was+")", pos0.x, pos0.y);
  }

  for (int j=1;j<n.length;j++) {

    pos=getNode(n[j]);
    line(pos0.x, pos0.y, pos.x, pos.y);
    pos0.set(pos);
  }
}

PVector getNode(XML node) {
  PVector temp= new PVector(0, 0);

  temp.x=lat2X(node.getFloat("lat"));
  temp.y=lon2Y(node.getFloat("lon"));
  return temp;
}

float lat2X(float lat) {
  return map(lat, minlat, maxlat, 0, Width);
}

float lon2Y(float lon) {
  return map(lon, minlon, maxlon, 0, Height);
}



void draw() {
}

