void setup() {
  size(500, 500);
}

float scl = 50/15f;
float sclInv = 1/scl;

void draw() {
  background(210, 160, 0);
  long before = System.currentTimeMillis();
  scale(scl);
  for(int i = 0; i < 10000; i++) {
    ellipse(random(width)*sclInv, random(height)*sclInv, 15, 15);
  }
  long after = System.currentTimeMillis();
  println(""+(after-before));
  if(frameCount > 100) exit();
}
