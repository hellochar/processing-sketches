void drawArrow(float x, float y, float z, float headLength) {
//        line(0, 0, 0, x, y, z);
  float mag = (float) Math.sqrt(x * x + y * y + z * z);
  pushMatrix();
  rotateY(atan2(-z, x));
  rotateZ(atan2(y, x));
  line(0, 0, 0, mag, 0, 0);
  float oneMinus = 1 - headLength;
  line(mag, 0, 0, mag * oneMinus, 0, mag * -headLength);
  line(mag, 0, 0, mag * oneMinus, 0, mag * +headLength);
  line(mag, 0, 0, mag * oneMinus, mag * -headLength, 0);
  line(mag, 0, 0, mag * oneMinus, mag * +headLength, 0);
  popMatrix();
}

void drawArrow(float x, float y, float z) {
        drawArrow(x, y, z, .1f);
    }
    
void drawArrow(PVector v) {
  drawArrow(v.x, v.y, v.z);
}

void drawArrow(PVector v, float len) {
  v = v.get();
  v.normalize();
  v.mult(len);
  drawArrow(v);
}
