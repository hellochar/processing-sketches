PVector direction;

void setup() {
  size(500, 500, P3D);
  direction = new PVector(mouseX, mouseY, 0);
}


void draw() {
  background(255, 220, 100);
  fill(204);
  stroke(0);
  strokeWeight(1);
  
  pushMatrix();
  translate(100, 100);
//  rotateX(map(sin(frameCount*.01), -1, 1, -PI/2, PI/2));
  rotateX(PI/3);
  rotateY(atan2(direction.y, direction.x));
  println("rotated z by "+degrees(atan2(direction.y, direction.x)));
//  rect(0, 0, 50, 50);
  ellipse(0, 0, 50, 50);
  direction.set(mouseX, mouseY, 0);
  
  popMatrix();
  stroke(0);
  strokeWeight(4);
  line(0, 0, 0, direction.x, direction.y, 0);
}
