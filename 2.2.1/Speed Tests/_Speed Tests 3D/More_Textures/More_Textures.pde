import peasy.*;

PImage img = createImage(10, 10, RGB);

void setup() {
  size(500, 500, P3D);
  img.loadPixels();
  for(int i = 0; i < img.pixels.length; i++) {
    img.pixels[i] = color(random(255), random(255), random(255));
  }
  img.updatePixels();
  new peasy.PeasyCam(this, 500);
}

void draw() {
  background(255);
  for(int i = 0; i < 100; i++) {
    pushMatrix();
    rotateX(random(TWO_PI));
    rotateY(random(TWO_PI));
//    simple();
    textured();
    popMatrix();
  }
  println(frameRate);
}

void vS(int x, int y) {
  fill(img.pixels[y*10+x]);
  vertex(x*50, y*50);
}

void simple() {
  noStroke();
  beginShape(QUADS);
  img.loadPixels();
  for(int x = 0; x < 10 - 1; x++) {
    for(int y = 0; y < 10 - 1; y++) {
      vS(x, y); vS(x+1, y); vS(x+1, y+1); vS(x, y+1);
    }
  }
  endShape();
}

void vC(int x, int y) {
  vertex(x*50, y*50, x, y);
}

void textured() {
  noStroke();
  beginShape(QUADS);
  img.loadPixels();
  texture(img);
  for(int x = 0; x < 10 - 1; x++) {
    for(int y = 0; y < 10 - 1; y++) {
      vC(x, y); vC(x+1, y); vC(x+1, y+1); vC(x, y+1);
    }
  }
  endShape();
}
