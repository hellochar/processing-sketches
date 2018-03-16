import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PShader skybox;

void setup() {
  size(800, 600, P3D);
  PeasyCam cam = new PeasyCam(this, 800);
  skybox = loadShader("skyboxFrag.glsl", "skyboxVert.glsl");
}

void draw() {
  background(128);
  //lights();
  //directionalLight(51, 102, 126, -0.6, 0.4, 0);
  //directionalLight(151, 40, 95, 0.8, -1, 0.3);
  pointLight(51, 102, 126, 1000, 1000, 0);
  fill(255);
  noStroke();
  shader(skybox);
  translate(sin(millis() / 1000f) * 200, 0, 0);
  sphere(500);
  //box(500);
}