import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;

MySQL msql;
long cc;

String fileName;
BufferedReader reader;
PrintWriter nod, way, rel;

boolean apostroph;
String[] header;
final static String tags[] = {
  "timestamp", "user", "version", "changeset", "uid", "visible"
};

XML test;

long bytes;
long oldbytes;
long oldtime;
float rate;

long cnt;
long tot;
int tot20;
int hcnt;
long nc, wc, rc;
int nfc, wfc, rfc;


String line;
int print;

void setup() {
  size(256, 128);

  ////////////////////////////////////////////////////7
  //fileName="gundeli";
  fileName="schweiz";
  apostroph=false;

  //////////////////////////////////////////////////////

  bytes=oldbytes=0;
  hcnt=0;
  header = new String[3];
  rate=0.0;
  reader = createReader(fileName+".osm");

  nfc=wfc=rfc=0;

  cc=0;
  //nod = createWriter(fileName+"-nod-"+nf(nfc, 2)+".osm");

  //way = createWriter(fileName+"-way-"+nf(wfc, 2)+".osm");

  //rel = createWriter(fileName+"-rel-"+nf(rfc, 2)+".osm");


  print=1;
  cnt=0;
  tot=48318742;
  tot20=int(tot/20); 
  //tot=36971;

  nc=wc=rc=0;

  msql= new MySQL(this, "localhost", "OSM", "root", "herakles");

  thread("parseFile");
  oldtime=millis();
}

void draw() {



  //if (frameCount%30==0) {
  long time=millis();
  float nr= (bytes-oldbytes) / ( (time-oldtime)*1000.0 );
  rate+=(nr-rate)*0.01;
  oldbytes=bytes;
  oldtime=time;
  //}
  background(128);
  fill(255);
  text(cnt+"/"+tot, 30, 30);
  switch(print) {
  case 1: 
    text("processing node "+nc, 30, 50);
    break;
  case 2:
    text("processing way "+wc, 30, 50);
    break;
  case 3: 
    text("processing relations "+rc, 30, 50);
    break;
  }
  bar((1.0*cnt)/(1.0*tot), 0.0);
  bar(rate/25.0, 0.3);

  text("Rate: "+round(rate)+" MB/s", 30, 100);
  text(cc,150,100);
}

void parseFile() {

/*
  while (parseLine ()) {
    ;
  }

  nod.println("</osm>");
  nod.close();

  way.println("</osm>");
  way.close();

  //rel.println("</osm>");
  rel.close();

  println(nc+" Nodes");
  println(wc+" Ways");
  println(rc+" Relations");

*/

  nfc=8;
  msql.connect();
  for (int j=0;j<nfc;j++) {
    print("loading nodes...."+nf(j, 2));
    test=loadXML(fileName+"-nod-"+nf(j, 2)+".osm");
    println(", ok");
    XML[] node=test.getChildren("node");
    for (int i=0;i<node.length;i++) {
      XML item=node[i];
      //if(msql.connect()){cd sk  
        msql.query("INSERT INTO node (id,lat,lon) VALUES ( '"+item.getString("id")+"','"+item.getString("lat")+"','"+item.getString("lon")+"')");
        cc++;
      //}
    }
  }
  msql.close();

/*
  for (int i=0;i<wfc;i++) {
    print("loading ways...."+nf(i, 2));
    test=loadXML(fileName+"-way-"+nf(i, 2)+".osm");
    println(", ok");
  }
  for (int i=0;i<rfc;i++) {
    print("loading rels...."+nf(i, 2));
    test=loadXML(fileName+"-rel-"+nf(i, 2)+".osm");
    println(", ok");
  }
*/

  exit();
}

boolean parseLine() {
  try {
    line = reader.readLine();
    cnt++;
  } 
  catch (IOException e) {
    //e.printStackTrace();
    line = null;
  }
  if (line == null) {
    // Stop reading because of an error or file is empty
    return false;
  } 
  else {

    bytes+=line.length();

    if (cnt==2)apostroph=(line.indexOf("'")>=0);

    if (line.indexOf("<node")>=0) {
      print=1;
    }

    if (line.indexOf("<way")>=0) 
    {
      print=2;
    }

    if (line.indexOf("<relation")>=0) {
      print=3;
    }

    String zeile=cleanLine(line);

    switch(print) {
    case 1: 
      if (cnt<4) {

        header[hcnt++]=zeile;
        way.println(zeile);
        wc++;
        rel.println(zeile);
        rc++;
        nod.println(zeile);
        nc++;
      }
      else {
        nod.println(zeile);
        nc++;
      }
      break;
    case 2: 
      way.println(zeile);
      wc++;
      break;
    case 3: 
      rel.println(zeile);
      rc++;
      break;
    default: 
      break;
    }

    if ((nc>tot20/5)&&(line.indexOf("</node>")>=0)) {
      nfc++;
      nc=0;
      nod.println("</osm>");
      nod.close();
      nod = createWriter(fileName+"-nod-"+nf(nfc, 2)+".osm");
      for (int i=0;i<3;i++) {
        nod.println(header[i]);
      }
    }
    if ((wc>tot20)&&(line.indexOf("</way>")>=0)) {
      wfc++;
      wc=0;
      way.println("</osm>");
      way.close();
      way = createWriter(fileName+"-way-"+nf(wfc, 2)+".osm");
      for (int i=0;i<3;i++) {
        way.println(header[i]);
      }
    }
    if ((rc>tot20)&&(line.indexOf("</relation>")>=0)) {
      rfc++;
      rc=0;
      rel.println("</osm>");
      rel.close();
      rel = createWriter(fileName+"-rel-"+nf(rfc, 2)+".osm");
      for (int i=0;i<3;i++) {
        rel.println(header[i]);
      }
    }
    return true;
  }
}

String cleanLine(String line) {

  String temp= new String();
  temp=line.substring(0, line.length());
  int n;
  String[] m;
  if (cnt>2) {
    for (int i=0;i<6;i++) {
      n=temp.indexOf(tags[i]);
      if (n>0) {
        if (apostroph) {
          m=match(temp, tags[i]+"='[^']*'");
        }
        else {
          m=match(temp, tags[i]+"=\"[^\"]*\"");
        }
        if (m!=null)
          temp=temp.substring(0, n)+temp.substring(n+m[0].length(), temp.length());
      }
    }
  }
  return temp;
}

void bar(float value, float displace) {

  value=constrain(value, 0.0, 1.0);
  pushStyle();
  noStroke();
  fill(255, 255, 128);
  rect(0.1*width, height/2+height*displace, value*width*0.8, height*0.1);
  stroke(255, 255, 0);
  fill(0, 0);
  rect(0.1*width, height/2+height*displace, width*0.8, height*0.1);
  fill(0);
  text(int(value*100)+" %", 0.5*width, height/2+height*displace+11);
  popStyle();
}

