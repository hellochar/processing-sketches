import JMyron.*;

import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;
JMyron my;
boolean[] changed;
int camWidth = 320, camHeight = 240;

void setup() {
  size(camWidth, camHeight, P3D);
  cam = new PeasyCam(this, width/2, height/2, 0, 500);
  my = new JMyron();
  my.start(camWidth, camHeight);
  my.findGlobs(0);
  changed = new boolean[width*height];
  my.adaptivity(4);
  colorMode(HSB, 1);
}

int[] pic;
int[] dif;

float slider = .125;
float sep = 20;

void keyPressed() {
  if(key >= '1' && key <= '9') {
    slider = map(key-'1', 0, '9'-'1', 0, 1);
    println("slider: "+slider);
  }
  else if(key == '-') {
    sep -= 10;
  }
  else if(key == '=') {
    sep += 10;
  }
  else if(key == 's') {
    smooth();
    render(.2);
    noSmooth();
//    filter(BLUR, 1);
    save("render.png");
  }
}

float[][] brightnessLevels = new float[][] {
  {.3, 1},
  {.4, 1},
  {.5, 1},
  {.6, 1},
  {.7, 1},
  {.8, 1},
  {.9, 1},
  {1, 1}
};

void render(float res) {
  noStroke();
  for(float x = 0; x < width-res; x += res) {
    for(float y = 0; y < height-res; y += res) {
      int p = picAt(x, y);
      int c = color(hue(p), saturation(p)*4, brightness(p), slider);
//      int c2 = color(map(millis(), 0, 5000, 0, 1)%1, saturation(p)*4, brightness(p), .25);
      stroke(c);
//      point(x, y, 200*round(slider*brightness(p) + (1-slider)*saturation(p)));
    for(int i = 0; i < brightnessLevels.length; i++) {
      float[] range = brightnessLevels[i];
      if(brightness(p) >= range[0] && brightness(p) <= range[1])
        point(x, y, sep*i);
    }
//    if(brightness(p) > .5)
//      point(x, y, -200+300*(int)(10*slider*brightness(p)));
      
      
//      fill(hue(p), saturation(p), brightness(p));
//      beginShape();
//      putVertex(x, y);
//      putVertex(x+res, y);
//      putVertex(x+res, y+res);
//      putVertex(x, y+res);
//      endShape(CLOSE);
    }
  }
//  endShape();
}

void draw() {
  if(frameCount < 30) my.adapt();
  my.update();
  background(0);
  pic = my.image();
  dif = my.differenceImage();
//  beginShape(POINTS);
  render(5);
}

void putVertex(int x, int y) {
  vertex(x, y, 200*sqrt(brightness(picAt(x, y))));
}

int picAt(float sX, float sY) {
  return pic[s2ca(sX, sY)];
}

int difAt(int sX, int sY) {
  return dif[s2ca(sX, sY)];
}

//screen coords to camera array (returns the associated index)
int s2ca(float sX, float sY) {
  return (int)(map(sY, 0, height, 0, camHeight))*camWidth+(int)(map(sX, 0, width, 0, camWidth));
}
