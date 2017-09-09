float phi = (1+sqrt(5))/2;

int h = int(1024/phi);
float a, nextA;
float x, y;

void setup() {
  size(int(h*phi), h);
  background(0);
  noFill();
  stroke(255);
  strokeWeight(2);
  strokeJoin(ROUND);
  smooth();
  a = nextA = -180;
  x = h;
  y = h;
}

void draw() {
  beginShape();
  for(int z = 0; z < 10; z++) {
    nextA += 90;
    for( ; a < nextA; a += .5) {
      vertex(x+cos(radians(a))*h, y+sin(radians(a))*h);
    }
    h /= phi;
    x += cos(radians(a))*(h/phi);
    y += sin(radians(a))*(h/phi);
  }
  endShape();
  noLoop();
}
