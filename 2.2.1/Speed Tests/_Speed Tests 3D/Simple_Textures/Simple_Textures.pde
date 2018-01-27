import peasy.*;


void setup() {
  size(500, 500, P3D);
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
  println(frameRate); //Getting framerates of ~30
}

void myTexture(float x, float y, float w, float h) {
  noStroke();
  beginShape();
  randFill();
  vertex(x, y);
  randFill();
  vertex(x, y+h);
  randFill();
  vertex(x+w, y+h);
  randFill();
  vertex(x+w, y);
  endShape();
}

void randFill() { fill(random(255), random(255), random(255)); }
