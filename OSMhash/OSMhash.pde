import java.util.Map;

Map map;


long i;


// 4M   Nodes
// 140k Ways
// 65k  Members
// 10k  Rels

void setup() {
  size(256, 256);
  map = new Map();
 
  thread("put");
}


void draw() {
  background(0);
  text(i, 100, 110);
}

void put() {
  for (i=0L;i<4000000L;i++) {
    map.addNode(new Node());
  }
}

