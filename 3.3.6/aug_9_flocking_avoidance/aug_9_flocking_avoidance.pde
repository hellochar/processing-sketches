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
PGraphics toAvoid;

void setup() {
  size(640, 360);
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  toAvoid = createGraphics(width, height);
  background(220);
}

void draw() {
//  background(192);
  toAvoid.beginDraw();
  toAvoid.background(0);
  toAvoid.noStroke();
  toAvoid.fill(0, 0);
  toAvoid.rect(0, 0, width, height);
  toAvoid.fill(120, 255, 40);
  toAvoid.ellipse(mouseX, mouseY, 300, 300);
  toAvoid.endDraw();
  image(toAvoid, 0, 0);
  //stroke(0, 2);
  //for (int i = 0; i < 10; i++) {
    flock.run();
  //}
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}