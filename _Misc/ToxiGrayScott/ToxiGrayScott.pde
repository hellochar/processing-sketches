import toxi.math.conversion.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh2d.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.geom.mesh.*;
import toxi.math.waves.*;
import toxi.util.*;
import toxi.math.noise.*;
import toxi.color.*;


import toxi.sim.grayscott.*;
import toxi.sim.fluids.*;
import toxi.sim.automata.*;
import toxi.sim.erosion.*;
import toxi.sim.dla.*;

MyGrayScott gs;
ToneMap toneMap;
PImage img;


void setup() {
  img = createImage(400, 400, RGB);
  size(img.width, img.height);
  gs = new MyGrayScott(img.width, img.height, true);
  gs.reset();
//  gs.setCoefficients(.0962, .05, .05, .025);
  gs.setCoefficients(0.021, 0.072, 0.05, .025);


// define a color gradient by adding colors at certain key points
// a gradient is like a 1D array with target colors at certain points
// all inbetween values are automatically interpolated (customizable too)
// this gradient here will contain 256 values
ColorGradient gradient=new ColorGradient();
gradient.addColorAt(0, NamedColor.BLACK);
gradient.addColorAt(128, NamedColor.RED);
gradient.addColorAt(192, NamedColor.YELLOW);
gradient.addColorAt(255, NamedColor.WHITE);

// now create a ToneMap instance using this gradient
// this maps the value range 0.0 .. 0.33 across the entire gradient width
// a 0.0 input value will be black, 0.33 white
toneMap=new ToneMap(0, 1, gradient);

  randomize();
//gs.update(1);
}

void randomize() {
  for(int i = 0; i < 250; i++) {
    int w = (int)random(3, 40), h = (int)random(3, 40),
        x = (int)random(width*img.width/width-w), y = (int)random(height*img.height/height-h);
    gs.setRect(x, y, w, h, random(1), random(1));
  }
}

void mousePressed() {
  if(mouseButton == RIGHT) randomize();
}

void draw() {
//  if (mousePressed) {
//    // set cells around mouse pos to max saturation
//      if(mouseButton == LEFT)
//        gs.setRect(mouseX*img.width/width, mouseY*img.height/height, 20, 20);
//  }
//  gs.setF(map(mouseX, 0, width, 0.01, .05));
//  gs.setK(map(mouseY, 0, height, .045, .1));
//  gs.setDiffuseU(map(mouseX, 0, width, 0, .5));
//  gs.setDiffuseV(map(mouseY, 0, height, 0, .5));
  for(int i=0; i<20; i++) gs.update(1);
//  if(Float.isInfinite(gs.v[0])) {
//    println("yes!!!");
//  }
  img.loadPixels();
  for(int i=0; i<gs.v.length; i++) {
    if(Float.isInfinite(gs.v[i])) {
//      print("i"+i+", ");
      gs.reset(i);
    }
    if(Float.isNaN(gs.v[i])) {
//      print("n"+i+", ");
      gs.reset(i);
    }
    img.pixels[i] = color(gs.v[i]*255, gs.u[i]*255, 0);
//    img.pixels[i]=toneMap.getARGBToneFor(gs.v[i]);
  }
  println("--------");
//  println(gs.getCurrentUAt(mouseX*img.width/width, mouseY*img.height/height)+", "+
//          gs.getCurrentVAt(mouseX*img.width/width, mouseY*img.height/height));
  img.updatePixels();
//  smooth();
  image(img, 0, 0, width, height);
  stroke(255); fill(255);
  textAlign(LEFT, TOP);
  text("f, k: "+gs.getFCoeffAt(mouseX, mouseY)+", "+gs.getKCoeffAt(mouseX, mouseY), 0, 0);
  text("u, v: "+gs.getCurrentUAt(mouseX, mouseY)+", "+gs.getCurrentVAt(mouseX, mouseY), 0, 12);
//  text("du, dv: "+gs.getDiffuseU()+", "+gs.getDiffuseV(), 0, 12);
//  println(frameRate);
}
