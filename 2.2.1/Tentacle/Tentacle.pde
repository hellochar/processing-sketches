import zhang.*;

import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

//draw an arbitrary 3d radial shape, given the radius as a function of how far up the tentacle you are.

float radius(float time) {
  return 10*(2+sin(DIST/4));
//  return .3*(DIST-time);
}

PeasyCam cam;
final static float DIST = TWO_PI,
            interval = .04;
final PVector xDir = new PVector(10, 0, 0),
              yDir = new PVector(0, 10, 0),
              zDir = new PVector(0, 0, 10);

void setup() {
  size(500, 500, P3D);
  cam = new PeasyCam(this, 100);
}

void draw() {
  background(0);
  drawAxes();
  
  
  drawTentacle();
}

void drawAxes() {
  strokeWeight(1);
  stroke(255, 0, 0);
  Methods.drawArrow(g, xDir);
  stroke(0, 255, 0);
  Methods.drawArrow(g, yDir);
  stroke(0, 0, 255);
  Methods.drawArrow(g, zDir);
}

void drawTentacle() {
  //outline the spine
  strokeWeight(4);
  stroke(255);
  noFill();
  beginShape();
  for(float t = 0; t < DIST; t += interval) {
    PVector loc = loc(t);
    vertex(loc.x, loc.y, loc.z);
  }
  endShape();
//  
  //outline the edge
  strokeWeight(1);
  stroke(255, 255, 128);
  for(float t = 0; t < DIST; t += interval) {
    PVector loc = loc(t),
            deriv = deriv(t);

    pushMatrix();
    translate(loc.x, loc.y, loc.z);
    float alpha = asin(deriv.z/dist(0, 0, deriv.x, deriv.z)),
          beta = asin(deriv.x/dist(0, 0, deriv.x, deriv.y));
    rotateY(alpha); //at a derivative of 0, i want to rotate 0, and at a derivative of infinity, i want to rotate 90. 
    rotateZ(beta);
//    rotateX(slope.x);
//    rotateZ(slope.z);
    
    float radius = radius(DIST);
    ellipse(0, 0, radius, radius);
    popMatrix();
  }
  
}

  
