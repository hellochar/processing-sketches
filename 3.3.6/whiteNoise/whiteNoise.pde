void setup() {
  size(2048, 2048, P2D);
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = color(random(255));
  }
  updatePixels();
  saveFrame("whiteNoise.png");
}

void draw() {
}