PShape shape;

void setup() {
  size(500, 500, P2D);
  PImage img = loadImage("Zyra_Splash_0.jpg");
//  beginShape();
//  texture(img);
//  vertex(25, 25, 100, 200);
//  vertex(25, 75, 100, 250);
//  vertex(75, 75, 150, 250);
//  vertex(75, 25, 150, 200);
//  endShape();
  shape = createShape();
  shape.beginShape();
  shape.texture(img);
  shape.vertex(25, 25, 100, 200);
  shape.vertex(25, 75, 100, 250);
  shape.vertex(75, 75, 150, 250);
  shape.vertex(75, 25, 150, 200);
  shape.endShape();
}

void draw() {
  shape(shape);
  shape.translate(10, 10);
  shape.scale(1.1);
}
