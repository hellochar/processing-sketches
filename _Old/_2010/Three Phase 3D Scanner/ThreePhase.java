import processing.core.*; 
import processing.xml.*; 

import peasy.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class ThreePhase extends PApplet {

// Adapted from Florian Jennet, from Alex Evans, from Song Zhang.



float zscale = 150;
float zskew = 40;
float noiseTolerance = 0.2f;

int inputWidth = 480;
int inputHeight = 640;

PeasyCam cam;
PImage tex;

public void setup() {
  size(480, 640, P3D);
  cam = new PeasyCam(this, width);
  
  noFill();
  stroke(255);
  
  decodeData();
}

public void draw () {
  background(0);
  translate(-inputWidth / 2, -inputHeight / 2);  
  int step = 2;
  float planephase;
  for (int y = step; y < inputHeight; y += step) {
    planephase = 0.5f - (y - (inputHeight / 2)) / zskew;
    for (int x = step; x < inputWidth; x += step)
      if (!_process[y][x] && !_process[y - step][x - step])
        point(x, y, (_wrapphase[y][x] - planephase) * zscale);
  }
}
float[][] _wrapphase = new float[inputHeight][inputWidth];
boolean[][] _mask = new boolean[inputHeight][inputWidth];
boolean[][] _process = new boolean[inputHeight][inputWidth];

public void decodeData() {
  phaseUnwrapAll();
  propagatePhases();
}
/*
  Takes the amplitudes of three out of phase sine waves
  and determines the unique angle determined by those amplitudes.
*/

public float phaseUnwrap(float phase1, float phase2, float phase3) {
  boolean flip;
  int off;
  float maxPhase, medPhase, minPhase;
  if(phase1 >= phase3 && phase3 >= phase2) {
    flip = false;
    off = 0;
    maxPhase = phase1;
    medPhase = phase3;
    minPhase = phase2;
  } else if(phase3 >= phase1 && phase1 >= phase2) {
    flip = true;
    off = 2;
    maxPhase = phase3;
    medPhase = phase1;
    minPhase = phase2;
  } else if(phase3 >= phase2 && phase2 >= phase1) {
    flip = false;
    off = 2;
    maxPhase = phase3;
    medPhase = phase2;
    minPhase = phase1;
  } else if(phase2 >= phase3 && phase3 >= phase1) {
    flip = true;
    off = 4;
    maxPhase = phase2;
    medPhase = phase3;
    minPhase = phase1;
  } else if(phase2 >= phase1 && phase1 >= phase3) {
    flip = false;
    off = 4;
    maxPhase = phase2;
    medPhase = phase1;
    minPhase = phase3;
  } else {
    flip = true;
    off = 6;
    maxPhase = phase1;
    medPhase = phase2;
    minPhase = phase3;
  }
  float theta = 0;
  if(maxPhase != minPhase)
    theta = (medPhase-minPhase) / (maxPhase-minPhase);
  if (flip)
    theta = -theta;
  theta += off;
  return theta / 6;
}
/*
  Go through all the pixels in the out of phase images,
  and determine their angle (theta). Throw out noisy pixels.
*/

public void phaseUnwrapAll() { 
  PImage phase1Image = loadImage("phase1.png");
  PImage phase2Image = loadImage("phase2.png");
  PImage phase3Image = loadImage("phase3.png");
  
  for (int y = 0; y < inputHeight; y++) {
    for (int x = 0; x < inputWidth; x++) {     
      int i = x + y * inputWidth;  
      
      float phase1 = (phase1Image.pixels[i] & 255) / 255.f;
      float phase2 = (phase2Image.pixels[i] & 255) / 255.f;
      float phase3 = (phase3Image.pixels[i] & 255) / 255.f;
      
      float phaseSum = phase1 + phase2 + phase3;
      float phaseRange = max(phase1, phase2, phase3) - min(phase1, phase2, phase3);
      
      // avoid the noise floor
      float gamma = phaseRange / phaseSum;
      _mask[y][x] = gamma < noiseTolerance;
      _process[y][x] = true;

      float theta = phaseUnwrap(phase1, phase2, phase3);
      _wrapphase[y][x] = theta;
    }
  }
}
/*
  Use the phase information collected from the phase unwrapping
  and propagate it across the boundaries.
*/

LinkedList toProcess;

public void propagatePhases() {
  int startX = inputWidth / 2;
  int startY = inputHeight / 2;

  toProcess = new LinkedList();
  toProcess.add(new int[]{startX, startY});
  _process[startX][startY] = false;

  while (!toProcess.isEmpty()) {
    int[] xy = (int[]) toProcess.remove();
    int x = xy[0];
    int y = xy[1];
    float r = _wrapphase[y][x];
    
    // propagate in each direction, so long as
    // it isn't masked and it hasn't already been processed
    if (y > 0 && !_mask[y-1][x] && _process[y-1][x])
      unwrap(r, x, y-1);
    if (y < inputHeight-1 && !_mask[y+1][x] && _process[y+1][x])
      unwrap(r, x, y+1);
    if (x > 0 && !_mask[y][x-1] && _process[y][x-1])
      unwrap(r, x-1, y);
    if (x < inputWidth-1 && !_mask[y][x+1] && _process[y][x+1])
      unwrap(r, x+1, y);
  }
}

public void unwrap(float r, int x, int y) {
  float frac = r - floor(r);
  float myr = _wrapphase[y][x] - frac;
  if (myr > .5f)
    myr--;
  if (myr < -.5f)
    myr++;

  _wrapphase[y][x] = myr + r;
  _process[y][x] = false;
  toProcess.add(new int[]{x, y});
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#d4d0c8", "ThreePhase" });
  }
}
