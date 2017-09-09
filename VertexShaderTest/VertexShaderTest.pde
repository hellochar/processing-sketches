import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;
PShader s;

void setup() {
  size(500, 500, P3D);
  cam = new PeasyCam(this, 200);
  s = loadShader("frag.glsl", "vert.glsl");
}

void draw() {
  shader(s);
  sphereDetail(6);
  background(0);
  noStroke();
  fill(255);
  sphere(100);
}
