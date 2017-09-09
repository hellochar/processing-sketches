import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

PGraphics gg;
PeasyCam cam;

void setup() {
  size(500, 500);
  gg = createGraphics(width, height, JAVA2D); gg.beginDraw();
  gg.background(255, 2);
  gg.smooth();
  gg.fill(0);
  gg.endDraw();
}

float rad_min = 5, rad_max = 15;

void draw() {
  println(frameRate);
  gg.beginDraw();
  gg.background(255, 2);
//  gg.fill(255, 5);
//  gg.rect(0, 0, width, height);
//  gg.fill(0);
  List<PVector> list = new ArrayList();
  float goal = map(mouseX, 0, width, 0, 1);
  for(float x = random(rad_min); x < width; x+=rad_min) {
    for(float y = random(rad_min); y < height; y+=rad_min) {
      float val = noise(x*.0025f, y*.0025f, millis()/10000f);
      if(abs(val - goal) < .0015) list.add(new PVector(x, y, val));
    }
  }
  
  for(PVector p : list) {
    float r = map(p.z, goal-.0015, goal+.0015, rad_min, rad_max);
//    float r = p.z*4;
    gg.ellipse(p.x, p.y, r, r);
  }
  gg.endDraw();
  gg.loadPixels();
  
  loadPixels();
  arraycopy(gg.pixels, pixels);
  updatePixels();
//  int v = get(mouseX, mouseY);
//  println(red(v)+", "+green(v)+", "+blue(v)+", "+alpha(v));
}

void boxAt(float x, float y, float z, float size) {
  translate(x, y, z);
  box(size);
  translate(-x, -y, -z);
}
