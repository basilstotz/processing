// Daniel Shiffman
// Hanukkah 2011
// 8 nights of Processing examples
// http://www.shiffman.net

// An example that demonstrates how to have several instances
// of the same animation sequence on screen, each playing
// back in different locations and at different speeds

// @pjs preload must be used to preload media if the program is 
// running with Processing.js
/* @pjs preload="stick/stick01.png, stick/stick02.png, stick/stick03.png, stick/stick04.png, stick/stick05.png, 
stick/stick06.png, stick/stick07.png, stick/stick08.png, stick/stick09.png, stick/stick10.png, stick/stick11.png, 
stick/stick12.png, stick/stick13.png, stick/stick14.png, stick/stick15.png, stick/stick16.png, stick/stick17.png, 
stick/stick18.png, stick/stick19.png, stick/stick20.png, stick/stick21.png, stick/stick22.png, stick/stick23.png, 
stick/stick24.png, stick/stick25.png, stick/stick26.png, stick/stick27.png, stick/stick28.png, stick/stick29.png, 
stick/stick30.png, stick/stick31.png, stick/stick32.png, stick/stick33.png, stick/stick34.png, stick/stick35.png, 
stick/stick36.png, stick/stick37.png, stick/stick38.png, stick/stick39.png, stick/stick40.png"; */ 

// An array of "Animation" objects
Animation[] animations = new Animation[6];

// The image sequence will be loaded outside of the object
// We don't want multiple instances of an object
// to load images again and again, just to point to an array
// of pre-loaded images

void setup() {
  size(640,360);
  frameRate(30);
  
  // Load the image sequence
  PImage[] seq = new PImage[40];
  for (int i = 0; i < seq.length; i++) {
    seq[i] = loadImage("stick/stick"+nf(i+1,2)+".png"); 
  }
  
  // Make all the objects
  float y = 0;
  for (int i = 0; i < animations.length; i ++ ) {
    // Each object gets an image array and an x,y location
    animations[i] = new Animation(seq,0,y);
    y += seq[0].height;
  }
}

void draw() {

  background(255);
  
  // Display, cycle, and move all the animation objects
  for (int i = 0; i < animations.length; i ++ ) {
    animations[i].display();
    animations[i].next();
    animations[i].move();
  }
}


