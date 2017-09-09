import zhang.grid.*;
import zhang.*;

Camera cam;

void setup() {
  size(500, 500);
  cam = new Camera(this);
}

void draw() {
  background(0);
  rect(0, 0, width, height);
  PVector center = cam.getCenter();
  ellipse(center.x, center.y, 20, 20);
}

void keyPressed() {
  if(key == ' ') {
    println("Corner: "+cam.getCorner()+", "+cam.getCenter());
  }
}
