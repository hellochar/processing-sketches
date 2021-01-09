void setup() {
  size(800, 600, P2D);
}

void draw() {
  background(200);
  // draw a single hex tile
  translate(width/2, height/2);
  drawHexTile();
}

void drawHexTile() {
  // you can imagine a hex tile being made up of 6 equilateral triangles
  String orientation = "horizontal"; // "vertical";
  beginShape();
  float radius = 100;
  // for(float angle = orientation == "horizontal" ? 0 : TWO_PI / 12; angle < TWO_PI; angle += TWO_PI / 6) {
  for (int i = 0; i < 6; i++) {
    float angle = i * TWO_PI / 6.0 + (orientation == "horizontal" ? 0 : TWO_PI / 12.0);
    vertex(cos(angle) * radius, sin(angle) * radius, 25, 25);
  }
  endShape(CLOSE);
}