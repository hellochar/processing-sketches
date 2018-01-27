void setup() {
  size(500, 500);
}

void draw() {
  background(210, 160, 0);
  long before = System.currentTimeMillis();
  translate(5000, 5000);
  for(int i = 0; i < 10000; i++) {
    ellipse(random(width) - 5000, random(height) - 5000, 15, 15);
  }
  long after = System.currentTimeMillis();
  println(frameCount+"-- "+(after-before));
}
