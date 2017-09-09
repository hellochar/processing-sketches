import zhang.*;

import peasy.*;

List dots;
int thisMillis, lastMillis;
PeasyCam cam;
PImage grass;

PVector landscapeMin = new PVector(-1000, -1000),
        landscapeMax = new PVector(1000, 1000);

void setup() {
  size(screenWidth, screenHeight, P3D);
  grass = loadImage("grass-tile-200.jpg");
  colorMode(HSB, 256, 100, 100);
  cam = new PeasyCam(this, (landscapeMax.x-landscapeMin.x)/2, (landscapeMax.y-landscapeMin.y)/2, scl/2, 500);
  dots = new ArrayList();
  for(int i= 0;  i< 100; i++) {
    dots.add(new Dot(new PVector(random(landscapeMin.x, landscapeMax.x), random(landscapeMin.y, landscapeMax.y)),
                     color(random(20, 40), random(80, 100), random(1))
                     ));
  }
//  smooth();
  drawNoise();
}

void draw() {
  thisMillis = millis();
  background(0);
  
  if(mousePressed) {
    //where is the dot when you click the mouse?
    
//    Dot d = new Dot(new PVector(
//    dots.add(d);
  }
  
  //the sun
  
  //a rotation per 6 seconds
  float ang = map(millis(), 0, 6000, 0, TWO_PI);
  float sunX = (landscapeMax.x-landscapeMin.x)*(1/2f+.8*cos(ang));
//  float sunX = width/2;
  float sunY = (landscapeMax.y-landscapeMin.y)/2;
  float sunZ = scl/3+(landscapeMax.x-landscapeMin.x)*.8*sin(ang);
  
  pushMatrix();
  translate(sunX, sunY, sunZ);
  noStroke();
  fill(23, 100, 100);
  sphere(12);
  popMatrix();
  
//  pushMatrix();
//  translate(width/2, height/2, scl/2);
//  fill(0, 0, 100);
//  box(50);
//  popMatrix();
  
//  lights();
  ambientLight(26, 65, 35);
  spotLight(23, 4, 35, (landscapeMax.x-landscapeMin.x)/2, (landscapeMax.y-landscapeMin.y)/2, scl*20, 0, 0, -1, PI/2, 2);
//  pointLight(26, 45, 80, sunX, sunY, sunZ);
//  pointLight(0, 0, 50, (landscapeMax.x-landscapeMin.x)/2, height/2, scl*2);
  
  //the landscape
  fill(0, 0, 100);
  drawNoise();
  
  //the dots
  for(int i = 0; i < dots.size(); i++) {
    Dot d = (Dot) dots.get(i);
    d.run();
    d.draw();
  }
  lastMillis = thisMillis;
}

int prec = 25;
float[][] noiseCache;
void drawNoise() {
  //2D
//  loadPixels();
//  for(int i = 0; i < pixels.length; i++) {
//    pixels[i] = color(map(noiseAt(i%width, i/width), 0, 1, 0, 255));
//  }
//  updatePixels();

  //3D
  if(noiseCache == null) {
    noiseCache = new float[(int)(landscapeMax.x-landscapeMin.x)/prec+1][(int)(landscapeMax.y-landscapeMin.y)/prec+1];
//        println("Made with dim "+noiseCache.length+", "+noiseCache[0].length+"!");
    for(float x = landscapeMin.x; x < landscapeMax.x; x += prec) {
      for(float y = landscapeMin.y; y < landscapeMax.y; y += prec) {
        noiseCache[(int)(x-landscapeMin.x)/prec][(int)(y-landscapeMin.y)/prec] = noiseAt(x, y);
      }
    }
  }

  for(float x = landscapeMin.x; x < landscapeMax.x-prec; x += prec) {
    beginShape(QUAD_STRIP);
    for(float y = landscapeMin.y; y < landscapeMax.y; y += prec) {
      vertex(x, y, noiseCache[(int)(x-landscapeMin.x)/prec][(int)(y-landscapeMin.y)/prec]);
      vertex(x+prec, y, noiseCache[(int)(x-landscapeMin.x)/prec+1][(int)(y-landscapeMin.y)/prec]);
    }
    endShape();
  }
  
  
  for(float x = landscapeMin.x; x < landscapeMax.x-prec; x += prec*2) {
    for(float y = landscapeMin.y; y < landscapeMax.y; y += prec*2) {
      
      PVector norm = velAt(x, y);
      norm.mult(100);
      stroke(0, 100, 100);
      
      pushMatrix();
      translate(x, y, noiseAt(x, y)+30);
//      PVector norm = normalAt(x, y);
//      line(0, 0, 0, norm.x, norm.y, norm.z);
//      drawArrow(norm);
      popMatrix();
//      Methods.drawVector(g, normalAt(x, y), 10, "");
    }
  }

//  for(int x = 0; x < landscapeMax.x-prec; x += prec) {
//    for(int y = 0; y < height-prec; y += prec) {
//      beginShape();
//      texture(grass);
//      textureMode(NORMALIZED);
//      vertex(x, y, noiseCache[x/prec][y/prec], 0, 0);
//      vertex(x+prec, y, noiseCache[x/prec+1][y/prec], 1, 0);
//      vertex(x+prec, y+prec, noiseCache[x/prec+1][y/prec+1], 1, 1);
//      vertex(x, y+prec, noiseCache[x/prec][y/prec+1], 0, 1);
//      endShape();
//    }
//  }
}


int millisThisFrame() {
  return lastMillis - thisMillis;
}


float scl = 700;

PVector velAt(float x, float y) {
  //we want the gradient of the noise map. unfortunately we don't
  //have a function so we'll use some good old slope approximating
  float h = 1;
  float dx = (noiseAt(x+h, y)-noiseAt(x-h, y))/(2*h),
        dy = (noiseAt(x, y+h)-noiseAt(x, y-h))/(2*h);
  return new PVector(dx, dy);
}

PVector velAt(PVector v) {
  return velAt(v.x, v.y);
}

float L = 5;
float noiseAt(float x, float y) {
  return scl*noise(map(x, 0, width, 0, L), map(y, 0, height, 0, L));
}

float noiseAt(PVector v) {
  return noiseAt(v.x, v.y);
}

PVector normalAt(float x, float y) {
  PVector grad = velAt(x, y);
  grad.mult(-1);
  grad.z = 1;
  return grad;
  
}
