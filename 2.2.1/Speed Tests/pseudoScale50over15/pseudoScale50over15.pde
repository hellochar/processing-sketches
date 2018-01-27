void setup() {
  size(500, 500);
}

float scl = 50/15f;
float sclInv = 1/scl;

void draw() {
  background(210, 160, 0);
  long before = System.currentTimeMillis();
//  scale(scl);
  strokeWeight(scl);
  for(int i = 0; i < 10000; i++) {
    ellipse(scl*random(width)*sclInv, scl*random(height)*sclInv, 15*scl, 15*scl);
  }
  long after = System.currentTimeMillis();
  println(""+(after-before));
  if(frameCount > 100) exit();
}
