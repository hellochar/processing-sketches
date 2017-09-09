float n = 7;

void setup() {
  size(500, 500);
  colorMode(HSB);
  noStroke();
}

void draw() {
  n = (int)map(mouseX, 0, width, 0, width);
  for(int x = 0; x < n; x++) {
    for(int y = 0; y < n; y++) {
      fill(color(256/n*((x*y)%n), 255, 255));
      rect(width/n*x, height/n*y, width/n, height/n);
    }
  }
}
