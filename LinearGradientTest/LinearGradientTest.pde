import toxi.color.*;
import toxi.math.*;
import zhang.*;

ColorGradient cg;
LinearGradient heights;

void setup() {
  size(800, 600);
  cg = new ColorGradient();
  heights = new LinearGradient();
  heights.setStrategy(new SigmoidInterpolation());
  
  heights.addPoint(0, 0);
  cg.addColorAt(0, randomColor());
  
  heights.addPoint(width, height);
  cg.addColorAt(width, randomColor());
  smooth();
}

void draw() {
  background(0);
  ColorList gradient = cg.calcGradient();
  for(int x = 0; x < width; x++) {
    stroke(gradient.get(x).toARGB());
    float height = heights.get(x);
    line(x, 0, x, height);
  }
}

void mousePressed() {
  cg.addColorAt(mouseX, randomColor());
  heights.addPoint(mouseX, mouseY);
}

ReadonlyTColor randomColor() {
  return TColor.newRGB(random(1), random(1), random(1));
}
