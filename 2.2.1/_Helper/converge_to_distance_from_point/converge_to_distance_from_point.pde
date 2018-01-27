float x, y, dx, dy, wantDist = 100;

void setup() {
  size(800, 800);
  x = random(width);
  y = random(height);
}

void draw() {
  background(0);
  smooth();
//  stroke(255);
//  line(0, height/2, width, height/2);
  fill(255);
  ellipse(x, y, 8, 8);
  noStroke();
  fill(255, 0, 0);
  ellipse(mouseX, mouseY, 8, 8);
  
  
  float ofx = mouseX - x,
        ofy = mouseY - y;
//  float dist2 = ofx*ofx+ofy*ofy;
  float ang = atan2(ofy, ofx);
  float wantX = mouseX - wantDist * cos(ang),
        wantY = mouseY - wantDist * sin(ang);
  fill(0, 255, 0);
  ellipse(wantX, wantY, 8, 8);
  dx = (wantX - x) * .1;
  dy = (wantY - y) * .1;
  x += dx;
  y += dy;
}
