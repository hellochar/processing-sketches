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
 
 
private static final int ITERATIONS = 5000;
int[][] hits;
Flock flock;
PGraphics render;

void setup() {
  size(640,360);
  render = createGraphics(width, height, P2D);
//  smooth();
  reset();
}

void reset() {
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(new PVector(width/2,height/2),2.0,0.05));
  }
}

void render() {
  render.beginDraw();
  render.background(0);
  
  
  
  
  render.endDraw();
}

void draw() {
  background(50);
  flock.run();
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(new PVector(mouseX,mouseY),2.0f,0.05f));
}
