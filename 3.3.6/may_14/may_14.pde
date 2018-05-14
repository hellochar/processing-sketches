// inspired by https://www.facebook.com/groups/creativecodingp5/permalink/2042044922710207/

import java.util.*;

float[] counts;

void setup() {
  size(600, 600);
  smooth();
  background(0);
  counts = new float[width*height];
}

void draw() {
  //background(0);
  //stroke(250, 40);
  float t = cos(map(frameCount, 0, 180, 0, TWO_PI));
  if (frameCount % 180 == 0) {
    exit();
  }
  Arrays.fill(counts, 0);
  for (int i=0; i<1000000; i++) {
    float x = random(-1, 1);
    float y = random(-1, 1);
    float xx = map(noise(x, y, t), 0, 1, 50, 550);
    float yy = map(noise(y, x, t), 0, 1, 50, 550);
    int pixelIndex = int(yy) * width + int(xx);
    counts[pixelIndex]++;
    //point(xx, yy);
  }
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    pixels[i] = color(log(counts[i]) * 25);
  }
  // applying stroke(250, 5) once goes from 0 to 0 * (1 - 0.05) + (0.05) * 250 = 12.5
  // applying it again goes from 12.5 * (1 - 0.05) + 0.05 * 250 = 24.375
  // v(t+1) = v(t) * (1 - a) + a*C
  // v(0) = 0
  // v(1) = aC
  // v(2) = v(1) * (1-a) + aC
  //      = aC*(1-a) + aC
  //      = aC(1-a+1) = aC(2-a)
  // v(3) = v(2)*(1-a) + aC
  //      = aC(2-a)(1-a) + aC
  //      = aC((2-a)(1-a) + 1)
  //      = aC(
  // wait wait wait, shouldn't this just be a normal geometric sequence? We get a% closer to C every step.
  // 
  updatePixels();
  saveFrame("frames/####.png");
}