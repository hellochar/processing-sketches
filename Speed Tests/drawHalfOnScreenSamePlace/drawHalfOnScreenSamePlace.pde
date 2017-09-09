void setup() {
  size(500, 500);
}

void draw() {
  background(210, 160, 0);
  long before = System.currentTimeMillis();
  for(int i = 0; i < 10000; i++) {
    random(width); random(height); //included in here to even out the playing field with calls
    ellipse(500, 250, 15, 15);
  }
  long after = System.currentTimeMillis();
  println(frameCount+"-- "+(after-before));
}
