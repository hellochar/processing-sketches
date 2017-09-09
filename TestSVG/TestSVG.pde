PShape shape;
import zhang.*;

Camera cam;

void setup() {
  size(500, 500);
  shape = loadShape("testShape.svg");
  cam = new Camera(this);
}

void draw() {
  background(255);
  noFill(); stroke(0); rect(0, 0, 768, 1024);
  shape(shape, 0, 0);
  
}
