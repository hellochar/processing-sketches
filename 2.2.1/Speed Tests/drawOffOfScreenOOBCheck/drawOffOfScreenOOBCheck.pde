void setup() {
  size(500, 500);
}

void draw() {
  background(210, 160, 0);
  long before = System.currentTimeMillis();
  for(int i = 0; i < 10000; i++) {
    random(width); random(height); //included in here to even out the playing field with calls
    if(!outOfBounds(600, 600))
      ellipse(600, 600, 15, 15);
  }
  long after = System.currentTimeMillis();
  println(frameCount+"-- "+(after-before));
}

boolean outOfBounds(float x, float y) {
  if(x < 0 || x > width || y < 0 || y > height) return true;
  return false;
}
