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

public class Nominatim {

  PApplet applet;
  proxml.XMLInOut xmlInOut;
  OsmPlace[] places;  
  int numResults;
  proxml.XMLElement searchResults;
  String searchString="";
  boolean show=false;

  boolean error=false;

  Nominatim(PApplet _applet) {

    applet=_applet;
    xmlInOut=new XMLInOut(applet, this);
    numResults=0;
    places= new OsmPlace[500];
  }



  public void xmlEvent(proxml.XMLElement element) {
    //println(element.toString());
    searchResults=element;
    searchResults.printElementTree();
    initPlaces();
  }


  void initPlaces() {
    proxml.XMLElement place;
    numResults=searchResults.countChildren();
    println(numResults);
    for (int i=0;i<numResults;i++) {//println("ggggg "+i);
      places[i] = new OsmPlace();
      place= searchResults.getChild(i); 
      places[i].place_id=int(place.getAttribute("place_id"));
      places[i].osm_type=place.getAttribute("osm_type");      
      places[i].osm_id=int(place.getAttribute("osm_id"));
      places[i].place_rank=int(place.getAttribute("place_rank"));
      places[i].boundingbox=place.getAttribute("boundingbox");
      places[i].lat=float(place.getAttribute("lat"));      
      places[i].lon=float(place.getAttribute("lon"));
      places[i].display_name=cleanString(place.getAttribute("display_name"));
      places[i].classe=place.getAttribute("class");
      places[i].type=place.getAttribute("type");      
      places[i].icon="";    //place.getAttribute("icon");
    }
  }

  String cleanString(String s) {
    char o[]= new char[500];
    char c;
    for (int i=0;i<s.length();i++) {
      c=s.charAt(i);
      if (c=='_')c=' ';
      o[i]=c;
    }
    String out=new String(o);
    return(out.substring(0, s.length()));
  }

  String getSearchString() {
    return(searchString);
  }

  void searchPlace(String query) {

    String zeilen[] = new String[500];
    char out[]= new char[500];
    int outCount=0;

    searchString=query;

    //urlEncode(); query string   
    for (int i=0;i<query.length();i++) {
      char c=query.charAt(i);
      if (c==' ') {
        out[outCount++]='%';
        out[outCount++]='2';
        out[outCount++]='0';
      }
      else {
        out[outCount++]=c;
      }
    }
    String q= new String(out);
    q=q.substring(0, outCount);

    String url="http://nominatim.openstreetmap.org/search?q=";
    String options="&format=xml&polygon=0&addressdetails=0";
    error=false;
    try {
      zeilen=loadStrings(url+q+options);
    }
    catch(Exception e) { 
      error=true;
    }
    finally {
    }
    if (error) {
      println("error: xml not loaded");
    }
    else {
      println("ok: xml loaded");
      println(cleanQuotes(zeilen));
      xmlInOut.loadElement(cleanQuotes(zeilen));
    }
  }

  String cleanQuotes(String[] z) {
    boolean quote=false;
    char out[]=new char[20000];
    char c;

    int outCount=0;
    for (int i=0;i<z.length;i++) {
      for (int j=0;j<z[i].length();j++) {
        c=z[i].charAt(j);
        switch(c) {
        case '\'': 
          quote=!quote;
          break;
        case ' ': 
          if (quote) {
            c='_';
          }
          break;
        default:  
          break;
        }
        out[outCount++]=c;
      }
    }
    String q= new String(out);
    return(q.substring(0, outCount));
  }


  void toggleShow() {
    show=!show;
  }
  
  void hide(){
    show=false;
  }
  
  void show(){
    show=true;
  }
  
  boolean getShow(){
    return( show);
  }

  void showResults() {

    if (show) {
      fill(0);
      smooth();
      if (searchString.length()>0) {
        text(numResults+" Resultate für: "+getSearchString()+" gefunden", 50, 70);
      }
      fill(0, 0, 0, 64);
      noStroke();
      rect(10, 5, 350, 100+(numResults)*50);
      for (int i=0;i<numResults;i++) {
        fill(0);
        textSize(20);
        text(char(65+i), 20, 110+i*50);
        textSize(10);
        text(places[i].toString(), 50, 100+i*50);
      }
    }
  }
}
class OsmPlace {

  int place_id;
  String osm_type;
  int osm_id;
  int place_rank;
  String boundingbox;
  float lon;
  float lat;
  String display_name;
  String classe;
  String type;
  String icon;



  OsmPlace(){;}

  String toString(){
   return(display_name+"\n"+classe+" "+type);
  }
  
}


