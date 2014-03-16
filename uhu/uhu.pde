/*
Here's a Processing sketch that will draw a color wheel and send a serial
string with the color you click on:

// Subtractive Color Wheel with Serial
// Based on a Processing example by Ira Greenberg. 
// Serial output added by Tom Igoe
// 
// The primaries are red, yellow, and blue. The secondaries are green, 
// purple, and orange. The tertiaries are  yellow-orange, red-orange, 
// red-purple, blue-purple, blue-green, and yellow-green.
// 
// Create a shade or tint of the subtractive color wheel using
// SHADE or TINT parameters.

// Updated 29 November 2010.

*/

import processing.serial.*;

int segs = 12;
int steps = 6;
float rotAdjust = TWO_PI / segs / 2;
float radius;
float segWidth;
float interval = TWO_PI / segs;

Serial myPort;

void setup() {
  size(200, 200);
  background(127);
  smooth();
  ellipseMode(RADIUS);
  noStroke();
  // make the diameter 90% of the sketch area
  radius = min(width, height) * 0.45;
  segWidth = radius / steps;

  // swap which line is commented out to draw the other version
  //drawTintWheel();
  drawShadeWheel();
  // open the first serial port in your computer's list
  myPort = new Serial(this, Serial.list()[0], 9600);
}


void drawShadeWheel() {
  for (int j = 0; j < steps; j++) {
    color[] cols = { 
      color(255-(255/steps)*j, 255-(255/steps)*j, 0), 
      color(255-(255/steps)*j, (255/1.5)-((255/1.5)/steps)*j, 0), 
      color(255-(255/steps)*j, (255/2)-((255/2)/steps)*j, 0), 
      color(255-(255/steps)*j, (255/2.5)-((255/2.5)/steps)*j, 0), 
      color(255-(255/steps)*j, 0, 0), 
      color(255-(255/steps)*j, 0, (255/2)-((255/2)/steps)*j), 
      color(255-(255/steps)*j, 0, 255-(255/steps)*j), 
      color((255/2)-((255/2)/steps)*j, 0, 255-(255/steps)*j), 
      color(0, 0, 255-(255/steps)*j),
      color(0, 255-(255/steps)*j, (255/2.5)-((255/2.5)/steps)*j), 
      color(0, 255-(255/steps)*j, 0), 
      color((255/2)-((255/2)/steps)*j, 255-(255/steps)*j, 0)
    };
    for (int i = 0; i < segs; i++) {
      fill(cols[i]);
      arc(width/2, height/2, radius, radius, 
      interval*i+rotAdjust, interval*(i+1)+rotAdjust);
    }
    radius -= segWidth;
  }
}


void drawTintWheel() {
  for (int j = 0; j < steps; j++) {
    color[] cols = { 
      color((255/steps)*j, (255/steps)*j, 0), 
      color((255/steps)*j, ((255/1.5)/steps)*j, 0), 
      color((255/steps)*j, ((255/2)/steps)*j, 0), 
      color((255/steps)*j, ((255/2.5)/steps)*j, 0), 
      color((255/steps)*j, 0, 0), 
      color((255/steps)*j, 0, ((255/2)/steps)*j), 
      color((255/steps)*j, 0, (255/steps)*j), 
      color(((255/2)/steps)*j, 0, (255/steps)*j), 
      color(0, 0, (255/steps)*j),
      color(0, (255/steps)*j, ((255/2.5)/steps)*j), 
      color(0, (255/steps)*j, 0), 
      color(((255/2)/steps)*j, (255/steps)*j, 0)
    };
    for (int i = 0; i < segs; i++) {
      fill(cols[i]);
      arc(width/2, height/2, radius, radius, 
      interval*i+rotAdjust, interval*(i+1)+rotAdjust);
    }
    radius -= segWidth;
  }
}

void draw() {
  // nothing happens here
}

void mouseReleased() {
  // get the color of the mouse position's pixel:
  color targetColor = get(mouseX, mouseY);
  // get the component values:
  int r = int(red(targetColor));
  int g = int(green(targetColor));
  int b = int(blue(targetColor));
  // make a comma-separated string:
  String colorString = r + "," + g + "," + b + "\n";
  // send it out the serial port:
  myPort.write(colorString );
}




