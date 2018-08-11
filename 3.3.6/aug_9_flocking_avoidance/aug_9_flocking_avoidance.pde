import KinectPV2.*;

/**
 * Flocking 
 * by Daniel Shiffman.  
 * 
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on 
 * rules of avoidance, alignment, and coherence.
 * 
 * Click the mouse to add a new boid.
 */

Flock flock;
PImage toAvoid;

KinectPV2 kinect;

PShader personShader;

void setup() {
  size(1920, 1080, P2D);
  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.enableBodyTrackImg(true);
  kinect.init();
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  toAvoid = createGraphics(width, height);
  background(220);
  personShader = loadShader("personShader.glsl");
}

void draw() {
  toAvoid = kinect.getBodyTrackImage();
//  background(192);

  //toAvoid.beginDraw();
  //toAvoid.background(0);
  //toAvoid.noStroke();
  //toAvoid.fill(0, 0);
  //toAvoid.rect(0, 0, width, height);
  //toAvoid.fill(120, 255, 40);
  //toAvoid.ellipse(mouseX, mouseY, 300, 300);
  //toAvoid.endDraw();
  image(toAvoid, 0, 0, width, height);
  filter(personShader);
  
  //stroke(0, 2);
  //for (int i = 0; i < 10; i++) {
    flock.run();
  //}
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}