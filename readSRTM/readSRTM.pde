int count;
boolean running;
int Width,Height;

void setup() {
  Width=512;
  Height=256;
  size(Width, Height);
  count=0;
  running=true;
  frameRate(5);
  thread("readAll");
}

void draw() {
  background(128);
  bar( (float)count/6.0, 0.0);
  if (!running)exit();
}

void readAll() {
  running=true;
  readAsc("srtm_38_02");
  count++;
  readAsc("srtm_38_03");
  count++;
  readAsc("srtm_38_04");
  count++;
  readAsc("srtm_38_02");
  count++;
  readAsc("srtm_38_03");
  count++;
  readAsc("srtm_38_04");
  count++;
  running=false;
}


void readAsc(String s) {

  BufferedReader reader;
  String line;
  PImage bild;

  // Open the file from the createWriter() example
  try {
    bild=createImage(6000, 6000, ARGB);

    reader = createReader(s+".asc");  
    for (int i=0;i<6;i++)line=reader.readLine();
    for (int i=0;i<6000;i++) {
      //print(i+" ");
      line = reader.readLine();
      String[] pieces = split(line, ' ');
      for (int j=0;j<pieces.length;j++) {
        int v=int(pieces[j]);
        if (-9999)v=(int)color(255, 255, 255, 255);
        bild.set(j, i, (color)v);
      }
    }

    bild.save(s+".tiff");
  }
  catch( IOException e) {
  }
  finally {
  }
}

void bar(float value, float displace) {

  value=constrain(value, 0.0, 1.0);
  pushStyle();
  noStroke();
  fill(255, 255, 128);
  rect(0.1*Width, Height/2+Height*displace, value*Width*0.8, Height*0.1);
  stroke(255, 255, 0);
  fill(0, 0);
  rect(0.1*Width, Height/2+Height*displace, Width*0.8, Height*0.1);
  fill(0);
  text(int(value*100)+" %", 0.5*Width, Height/2+Height*displace+20);
  popStyle();
}

/*
color intToColor(int _val) {
 int a=floor(_val/pow(2, 24));
 _val-=a*pow(2, 24);
 int r=floor(_val/pow(2, 16));
 _val-=r*pow(2, 16);
 int g=floor(_val/pow(2, 8));
 _val-=g*pow(2, 8);
 int b=floor(_val);
 return(color(r, g, b, 255));
 }
 
 int colorToInt(color c) {
 int a=0; //alpha(c); // war: alpha(c);
 int r=red(c);
 int g=green(c);
 int b=blue(c);
 return(a*pow(2, 24)+r*pow(2, 16)+g*pow(2, 8)+b);
 }
 */
