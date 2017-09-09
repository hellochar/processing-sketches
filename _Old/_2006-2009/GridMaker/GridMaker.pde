void setup() {
  size(1+floor(12 * s), 1+floor(17 * s));

}

float s = 45;

void draw() {
  background(color(255));
  for(float x = 0; x < width; x += s) {
    for(float y = 0; y < height; y += s) {
      drawGrid(x, y, s, s);
    }
  }
  save("chargrid.png");
}

void mousePressed() {
  println(mouseX);
}

void drawGrid(float x, float y, float w, float h) {
  smooth();
  strokeWeight(1);
  stroke(color(0, 200));
  noFill();
  rect(x, y, w, h);
  //do the width
  float d = w / 13;
  beginShape(LINES);
  for(int k = 0; k < 14; k++) {
    vertex(x + k*d, y + h / 2);
  }
  endShape();
  //do the height
  d = h / 13;
  beginShape(LINES);
  for(int k = 0; k < 14; k++) {
    vertex(x + w / 2, y + k*d);
  }
}
