/**
 * oscP5message by andreas schlegel
 * example shows how to create osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

color bg;

boolean kreis;
String v;
float v0,v1,v2;
float c0,c1,c2;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  //size(displayWidth, displayHeight);
  size(400,400);
  bg=color(128, 64, 64);
  kreis=false;
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  //myRemoteLocation = new NetAddress("192.168.1.27", 12000);
}


void draw() {
   c0+=(v0-c0)*0.1;
    c1+=(v1-c1)*0.1;
    c2+=(v2-c2)*0.1;
    bg=color(c0,c1,c2);
  background(bg);
  if (kreis) {
    fill(255);
    ellipse(150, 150, 50, 50);
  }
}



/* incoming osc message are forwarded to the oscEvent method. */

void oscEvent(OscMessage theOscMessage) {
  
  String tt;
  String ad;
  String vv="";
  
  int i;
  float f;
  String s;
  String e;
  
  tt=theOscMessage.typetag();
  ad=theOscMessage.addrPattern();

  for(int l=0;l<tt.length();l++){
    char c=tt.charAt(l);
    switch(c){
      case 'i': i = theOscMessage.get(l).intValue();
                vv+=" "+i;
                break;
      case 'f': f = theOscMessage.get(l).floatValue();
                vv+=" "+f;
                break;
      case 's': s = theOscMessage.get(l).stringValue();
                vv+=" "+s;
                break;
      default:  e = "unknown_typetag_"+c;
                vv+=" "+e;
                break;
    }
  }

  println(ad+" "+tt+" "+vv);

////////////////////////////////////////////////////////777

  //println(v);

  if (theOscMessage.checkAddrPattern("/seekBar1")) {
    //print("%");
    if (theOscMessage.checkTypetag("f")) {
      float ss=theOscMessage.get(0).floatValue();
      bg= color(ss, 64.0, 64.0);
      println(ss);
    }
  }
  if (theOscMessage.checkAddrPattern("/btn1")) {
    //print("%");
    if (theOscMessage.checkTypetag("i")) {
      int ss=theOscMessage.get(0).intValue();
      kreis= (ss==1); 
      println(ss);
    }
  }
  if (theOscMessage.checkAddrPattern("/tog1")) {
    //print("%");
    if (theOscMessage.checkTypetag("i")) {
      int ss=theOscMessage.get(0).intValue();
      kreis= (ss==1); 
      println(ss);
    }
  }
  
}

