import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;

PVector[] points;

PShader f;

void setup() {
  size(800, 600, P3D);
  cam = new PeasyCam(this, 500);
  float wantedMag = 200;
  PVector p = PVector.random3D().setMag(wantedMag);
  points = new PVector[100000];
  for(int i = 0; i < points.length; i++) {
    PVector nextPoint = p.copy().add(PVector.random3D().mult(3)).setMag(wantedMag);
    //float ang = PVector.angleBetween(p, nextPoint); // 0 to PI
    // at mag 200, ang is anywhere from .5 to .85
    //println(degrees(ang));
    //wantedMag += 1*(degrees(ang) - 0.65);
    //println(wantedMag);
    wantedMag += 0.001;
    points[i] = nextPoint;
    p = nextPoint;
  }
  f = loadShader("filter2.glsl");
  colorMode(HSB);
}

void draw() {
  //f.set("u_mouse", float(mouseX) / width, 1f - float(mouseY) / height);
  //f.set("amt", 2f);
  f.set("exponent", pow(2, 5f * mouseX / width));
  f.set("u_time", millis() / 1000f);
  background(0);
  noFill();
  stroke(255, 128);
  strokeWeight(10);
  beginShape();
  for (int i = 0; i < points.length; i++) {
    PVector p = points[i];
    //p.add(PVector.random3D().mult(3)).setMag(200);
    stroke((i / 100f) % 255, 190, i % 255, 128);
    vertex(p.x, p.y, p.z);
  }
  endShape();
  filter(f);
}