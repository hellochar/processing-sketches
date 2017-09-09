float time;
float scl = PI;

void setup() {
  size(500, 500);
}

void draw() {
  time = millis() / 1000;
  loadPixels();
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) {
      pixels[y*width+x] = color(bright(func(x, y)));
    }
  }
  updatePixels();
  println(frameRate);
}

//maps between 0-1 to 0 - 255
float bright(float val) {
  return map(val, -1, 1, 0, 255);
}

//maps the screen coords to graph coords
float func(int x, int y) {
  return func(map(x, 0, width, -scl, scl), map(y, 0, height, -scl, scl));
}

float func(float x, float y) {
//  return sin(-time()+(x*x+y*y));
//  float k = 40;
//  return sq(sq(sin(k*x)*cos(k*y))) / (1 + 10*sq(time() - radius(x, y)));
  return 1/(1+sq(sin(radius(x, y)-sqrt(time()))));
//  return 1/(1+time()*sq(sin(y*x+time())));
//  return sin(x+time())*cos(y+time());
}

float time() {
//  return 10 * (1/(1+2*sq(sin(2*map(millis(), 0, 1000, 0, 1)))));
  return sq(map(millis(), 0, 1000, 0, 1));
}

float radius(float x, float y) {
  return sqrt(x*x+y*y);
}

float angle(float x, float y) {
  return atan2(y, x);
}
