// Adapted from Florian Jennet, from Alex Evans, from Song Zhang.

import peasy.*;

float zscale = 150;
float zskew = 40;
float noiseTolerance = 0.2;

int inputWidth = 480;
int inputHeight = 640;

PeasyCam cam;
PImage tex;

void setup() {
  size(480, 640, P3D);
  cam = new PeasyCam(this, width);
  
  noFill();
  stroke(255);
  
  decodeData();
}

void draw () {
  background(0);
  translate(-inputWidth / 2, -inputHeight / 2);  
  int step = 2;
  float planephase;
  for (int y = step; y < inputHeight; y += step) {
    planephase = 0.5 - (y - (inputHeight / 2)) / zskew;
    for (int x = step; x < inputWidth; x += step)
      if (!_process[y][x] && !_process[y - step][x - step])
        point(x, y, (_wrapphase[y][x] - planephase) * zscale);
  }
}
