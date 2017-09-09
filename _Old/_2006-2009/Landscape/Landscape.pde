import damkjer.ocd.*;
import java.util.*;
import java.awt.event.*;

float[][] vals;
float decimate = 1.2;

Camera c;

void setup() {
  size(500, 500, P3D);
  vals = new float[(int)(width/decimate)][(int)(height/decimate)];
  float sx = 5, sy = 5;
  for(int x = 0; x < vals.length; x++) {
    for(int y = 0; y < vals[0].length; y++) {
      vals[x][y] = noise(sx * x*decimate / width, sy * y*decimate / height);
    }
  }
  c = new Camera(this, width/2, -height*.2, width);
  colorMode(RGB, 1, 1, 1);
  addMouseWheelListener(new MouseWheelListener() {
    public void mouseWheelMoved(MouseWheelEvent e) {
      c.zoom((float)e.getWheelRotation()/10);
    }
  });
}

int colorFor(float val) {
  float r = val;
  float g = 2*abs(.5-val);
  float b = 1-val;
  return color(r, g, b);
}

void draw() {
  background(.97);
  c.feed();
  noFill();
  stroke(0);
  box(25);
  line(0,0,0,100, 0, 0);
  stroke(255, 0, 0);
  line(0, 0, 0, 0, 100, 0);
  stroke(0, 255, 0);
  line(0 ,0, 0, 0, 0, -100);
  translate(-width/2, 0, -height/2);
  for(int x = 0; x < vals.length; x++) {
    for(int y = 0; y < vals[0].length; y++) {
      stroke(colorFor(vals[x][y]));
      point(x*decimate, -vals[x][y]*250, y*decimate);
    }
  }
  if(mousePressed) {
    c.circle(radians(mouseX-pmouseX));
    c.arc(radians(mouseY-pmouseY));
  }
  if(keyPressed) {
    if(key == '-') {
      c.zoom(1.000002);
    }
    else if(key == '=') {
      c.zoom(1/1.000002);
    }
  }
}
