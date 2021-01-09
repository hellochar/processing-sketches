PVector p;

void setup() {
  size(500, 500);
  p = new PVector(random(-width, width) / 2, random(-height, height) / 2);
}

void draw() {
  background(200);
  translate(width/2, height/2);
  line(-width/2, 0, width/2, 0);
  line(0, -height/2, 0, height/2);
  ellipse(p.x, p.y, 10, 10);
  text("" + p.x + ", " + p.y, p.x, p.y);
  
  PVector force = new PVector();
  String direction = Math.abs(p.x) > Math.abs(p.y) ? "y" : "x";
  if (direction == "x") {
    //force.x += -p.x * 0.01;
    p.x = min(max(p.x, -10f), 10f);
  } else {
    p.y = min(max(p.y, -10f), 10f);
    //force.y += -p.y * 0.01;
  }
  p.add(force);
}

void mousePressed() {
  p.x = mouseX - width/2;
  p.y = mouseY - height/2;
}