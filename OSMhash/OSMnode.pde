class Node {

  long id;

  float lat;
  float lon;

  int tagRef;

  Node() {
 
    this(0L, 0.0, 0.0, -1);
 
  }

  Node(long id_, float lat_, float lon) {

    this(id_, lat_, lon_, -1);
  }

  Node(long id_, float lat_, float lon_, int tagRef_) {

    id=id_;
    lat=lat_;
    lon=lon_;
    tagRef=tagRef_;
    
  }
}

