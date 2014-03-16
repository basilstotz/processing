// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// Example demonstrating distance joints 
// A bridge is formed by connected a series of particles with joints

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
PBox2D box2d;

// An object to describe a Bridget (a list of particles with joint connections)
Bridge bridge;

// A list for all of our rectangles
ArrayList<Box> boxes;

void setup() {
  size(640,360);
  smooth();

  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  
  
  // Make the bridge
  bridge = new Bridge(width,width/10);
  
  // Create ArrayLists	
  boxes = new ArrayList<Box>();

}

void draw() {
  background(255);

  // We must always step through time!
  box2d.step();


  // When the mouse is clicked, add a new Box object
  if (mousePressed) {
    Box p = new Box(mouseX,mouseY);
    boxes.add(p);
  }

  // Display all the boxes
  for (Box b: boxes) {
    b.display();
  }

  // Boxes that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }

  // Draw the windmill
  bridge.display();
  
  
   fill(0);
  text("Click mouse to add boxes.",10,height-10);
  
 
}










// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// A rectangular box
class Box  {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;

  // Constructor
  Box(float x, float y) {
    w = random(4,16);
    h = random(4,16);
    // Add the box to the box2d world
    makeBody(new Vec2(x,y),w,h);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(175);
    stroke(0);
    rect(0,0,w,h);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
    //body.setMassFromShapes();

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }

}



// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// Series of Particles connected with distance joints

class Bridge {

  // Bridge properties
  float totalLength;  // How long
  int numPoints;      // How many points

  // Our chain is a list of particles
  ArrayList<Particle> particles;

  // Chain constructor
  Bridge(float l, int n) {

    totalLength = l;
    numPoints = n;

    particles = new ArrayList();

    float len = totalLength / numPoints;

    // Here is the real work, go through and add particles to the chain itself
    for(int i=0; i < numPoints+1; i++) {
      // Make a new particle
      Particle p = null;
      
      // First and last particles are made with density of zero
      if (i == 0 || i == numPoints) p = new Particle(i*len,height/2,4,true);
      else p = new Particle(i*len,height/2,4,false);
      particles.add(p);

      // Connect the particles with a distance joint
      if (i > 0) {
         DistanceJointDef djd = new DistanceJointDef();
         Particle previous = particles.get(i-1);
         // Connection between previous particle and this one
         djd.bodyA = previous.body;
         djd.bodyB = p.body;
         // Equilibrium length
         djd.length = box2d.scalarPixelsToWorld(len);
         // These properties affect how springy the joint is 
         djd.frequencyHz = 0;
	 djd.dampingRatio = 0;
         
         // Make the joint.  Note we aren't storing a reference to the joint ourselves anywhere!
         // We might need to someday, but for now it's ok
         DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
      }
    }
  }

  // Draw the bridge
  void display() {
    for (Particle p: particles) {
      p.display();
    }
  }

}



// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// A circular particle

class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  
  color col;

  Particle(float x, float y, float r_, boolean fixed) {
    r = r_;
    
    // Define a body
    BodyDef bd = new BodyDef();
    if (fixed) bd.type = BodyType.STATIC;
    else bd.type = BodyType.DYNAMIC;

    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    
    body.createFixture(fd);

    col = color(175);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  // 
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    ellipse(0,0,r*2,r*2);
    // Let's add a line so we can see the rotation
    line(0,0,r,0);
    popMatrix();
  }


}



