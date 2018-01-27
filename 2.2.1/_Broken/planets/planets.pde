import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

public static final float DELTA_T = .02,
                          GRAV_POW = 20;

Set<Planet> planets;
Set<Planet> toAdd, toRemove;
PeasyCam cam;

void setup() {
  size(800, 600, P3D);
  planets = new HashSet();
  toAdd = new HashSet();
  toRemove = new HashSet();
  cam = new PeasyCam(this, 1000);
  for(int i = 0; i < 20; i++) {
    planets.add(new Planet(new PVector(random(-width, width), random(-height, height), random(-width, width)), random(10, 100000)));
  }
//  noLoop();
  colorMode(HSB, 5);
}

//void mousePressed() { redraw(); }

PVector avg(PVector a, PVector b) {
  return PVector.div(PVector.add(a, b), 2);
}

void draw() {
  background(0);
  lights();
  for(Planet p : planets) {
    p.run();
  }
  PVector mid = new PVector();
  for(Planet p : planets) {
    p.update();
    mid.add(p.loc);
  }
  mid.div(planets.size());
  cam.lookAt(mid.x, mid.y, mid.z);
  for(Planet p : planets) {
    p.draw();
  }
  planets.addAll(toAdd);
  planets.removeAll(toRemove);
//  println("-----------");
}
