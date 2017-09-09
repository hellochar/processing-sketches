import peasy.*;

PImage img;
void setup() {
  size(500, 500, P3D);
  img = loadImage("test.png");
//  new PeasyCam(this, 500);
}

void draw() {
  background(255);
  for(int i = 0; i < 1000; i++) {
    pushMatrix();
    rotateX(random(TWO_PI));
    rotateY(random(TWO_PI));
    rotateZ(random(TWO_PI));
    myTexture(random(width), random(height), random(width), random(height));
    popMatrix();
  }
  println(frameRate); //getting frameRates of ~11.5
}

void myTexture(float x, float y, float w, float h) {
  noStroke();
  beginShape();
  texture(img);
  randFill();
  vertex(x, y, 0, 0);
  randFill();
  vertex(x, y+h, 0, 500);
  randFill();
  vertex(x+w, y+h, 500, 500);
  randFill();
  vertex(x+w, y, 500, 0);
  endShape();
}

void randFill() { /*fill(random(255), random(255), random(255));*/ }
