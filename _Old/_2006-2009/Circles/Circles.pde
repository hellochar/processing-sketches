color dark = 0xFFCC9933, light = 0xFF996633;

void setup() {
  size(500, 500);
  smooth();
  render();
}

void render() {
  background(dark);
  fill(dark);
  stroke(light);
  float k = 3, r = 2;
  for(float x = -k; x < width+k; x += k) {
    for(float y = -k; y < height+k; y += k) {
    float dx = x+random(-r, r), dy = y+random(-r, r);
    ellipse(dx, dy, k, k);
    point(dx, dy);
    }
  }
}

void draw() {
}
