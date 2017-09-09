void setup() {
  size(500, 500);
}

void draw() {
  background(210, 160, 0);
  long before = System.currentTimeMillis();
  for(int i = 0; i < 10000; i++) {
    pushMatrix();
    float x = random(width), 
          y = random(height);
    translate(x, y);
    ellipse(0, 0, 15, 15);
    popMatrix();
  }
  long after = System.currentTimeMillis();
  println(frameCount+"-- "+(after-before));
}
