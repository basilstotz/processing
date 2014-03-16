

PrintWriter output;

XML root;
XML ziel;

XML node[];
XML way[];

float minlat, minlon, maxlat, maxlon;

int Width, Height;


void setup() {
  Width=500;
  Height=500;

  size(Width, Height);

  root= loadXML("map.osm");
  ziel=  parseXML("<osm></osm>"); 

  output = createWriter("mapi.osm"); 

  XML Bounds=parseXML("<bounds minlat=\"\" minlon=\"\" maxlat=\"\" maxlon=\"\"/>");
  XML Node=parseXML("<node id=\"\" lat=\"\" lon=\"\"></node>");
  XML Tag=parseXML("<tag k=\"\" v=\"\"/>");
  XML Way=parseXML("<way></way>");
  XML Nd=parseXML("<nd ref=\"\" />");

  XML child;

  //Bounds
  XML bounds=root.getChild("bounds");
  minlat= bounds.getFloat("minlat");
  maxlat= bounds.getFloat("maxlat");
  minlon= bounds.getFloat("minlon");
  maxlon= bounds.getFloat("maxlon");

  child=ziel.addChild(Bounds);
  child.setFloat("minlat", minlat);
  child.setFloat("maxlat", maxlat);
  child.setFloat("minlon", minlon);
  child.setFloat("maxlon", maxlon);


  //Nodes------------------------------------------
  node= root.getChildren("node");

  print("Nodes: "+node.length+" ");

  for (int i=0;i<node.length;i++) {

    XML item=node[i];

    if (tagsAllowed(item)) {

      child=ziel.addChild(parseXML("<node lat=\"\" lon=\"\"/>"));
      //child.setInt("id", item.getInt("id"));
      child.setFloat("lat", item.getFloat("lat"));
      child.setFloat("lon", item.getFloat("lon"));


      //Tags
      XML[] tag4=item.getChildren("tag");

      for (int j=0;j<tag4.length;j++) {
        XML item2=tag4[j];

        //String sch=item2.getString("k");
        //if (sch.equals("place")||sch.equals("natural")||sch.equals("landuse")||sch.equals("waterway")||sch.equals("name")) {

          XML child2=child.addChild(Tag);
          child2.setString("k", item2.getString("k"));
          child2.setString("v", item2.getString("v"));
        //}
      }
    }
  }
  //Ways----------------------------------------------------

  way= root.getChildren("way");
  
  
  println("Ways: "+way.length);
  
  for (int i=0;i<way.length;i++) {

    
    
   
 XML item=way[i];
    //Check Tags-----
   
    if (tagsAllowed(item)) {
   
      child=ziel.addChild(parseXML("<way g=\"\" a=\"\" n=\"\"></way>"));
      //
      //child.setInt("g",  );
      //child.setInt("a",  );
      //child.setString("n", );

      //Nds
      XML[] nd=item.getChildren("nd");

      for (int j=0;j<nd.length;j++) {
        XML item2=nd[j];
        if (false) {
          XML child3=child.addChild(parseXML("<node lat=\"\" lon=\"\"/>"));
          long ref=Long.parseLong(item2.getString("ref"));
          XML res=getNodeById(ref);
          child3.setFloat("lat", res.getFloat("lat"));
          child3.setFloat("lon", res.getFloat("lon"));
        }
        else {
          XML child2=child.addChild(Nd);
          child2.setString("ref", item2.getString("ref"));
        }
      }

      //Tags
      XML[] tag2=item.getChildren("tag");

      for (int j=0;j<tag2.length;j++) {
        XML item2=tag2[j];

        //String sch=item2.getString("k");
        //if (sch.equals("place")||sch.equals("natural")||sch.equals("landuse")||sch.equals("waterway")||sch.equals("name")) {
        XML child2=child.addChild(Tag);
        String k= item2.getString("k");
        
        if(k.equals("name"))item.setString("name",k);
        
        child2.setString("k",k);
        child2.setString("v", item2.getString("v"));
        //}
      }
    }
  }//for

  drawOSM(ziel);

  output.println(ziel.format(5));
  output.flush();
  output.close();
  noLoop();
}


boolean tagsAllowed(XML e) {

  
  
  String highway="path footway";
  String waterway="river riverbank stream canal dam";
  String tourism="alpin_hut";
  String landuse="allotments basin farm farmland farmyard forest grass greenield industrial meadow orchard pasture quarry reservoir vineyard";
  String natural="bare_rock fell grassland heath mud sand scrub stone tree tree_row wetland wood bay beach spring water arete cave_entrance cliff glacier peak ridge rock saddle scree sinkhole volcano";
  String place="city town village hamlet isolated_dwelling farm"; 
  //String area="yes"
  //String ele=""; 

  String k, v;

  XML[] tag=e.getChildren("tag");
  for (int i=0;i<tag.length;i++) {
    k=tag[i].getString("k");
    v=tag[i].getString("v");

    //if (k.equals("highway")&&(highway.indexOf(v)>=0))return true;
    if (k.equals("waterway")&&(waterway.indexOf(v)>=0))return true;
    if (k.equals("tourism")&&(tourism.indexOf(v)>=0))return true;
    if (k.equals("landuse")&&(landuse.indexOf(v)>=0))return true;
    if (k.equals("natural")&&(natural.indexOf(v)>=0))return true;
    if (k.equals("place")&&(place.indexOf(v)>=0))return true;
  }
  return false;
}


void drawOSM(XML osm) {
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

  noStroke();
  fill(c);
  ellipse(pos.x, pos.y, 2, 2);
}

void drawWay(XML way) {

  PVector pos, pos0;

  XML[] n=way.getChildren("node");
  pos0=getNode(n[0]);
  stroke(0);
  for (int j=1;j<n.length;j++) {
    pos=getNode(n[j]);
    line(pos0.x, pos0.y, pos.x, pos.y);
    pos0.set(pos);
  }
}


///////////////Utils////////////////////////////////////////
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

XML getNodeById(long id) {
  
  XML temp=parseXML("<node id=\"\" lat=\"\" lon=\"\"/>");
  for (int i=0;i<node.length;i++) {
    temp=node[i];
    if (Long.parseLong(node[i].getString("id"))==id)break;
  }

  return temp;
}  


void draw() {
}

