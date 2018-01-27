float angOffset = 0,
      length = .3,
      factor = .01;

void setup() {
  size(500, 500);
//  noLoop();
  noFill();
  strokeWeight(3);
  strokeCap(ROUND);
  smooth();
  vals = new int[500];
  for(float a = 0; a < vals.length; a++) {
    vals[(int)a] = colorLerp(red, blue, a / 150);
  }
  fIncr = .09 / height;
}

int[] vals;

void mouseMoved() {
//  factor = .09 * mouseY / height;
//  redraw();
}

void keyPressed() {
  if(keyCode == LEFT) angOffset -= 1 * PI / width;
  else if(keyCode == RIGHT) angOffset += 1 * PI / width;
//  redraw();
}

int red = color(255, 0, 0), blue = color(0, 0, 255);
float fIncr;

void draw() {
  background(204);
  if(mouseY > height - 15) factor = (factor+fIncr) * 1.005;
  else if(mouseY < 15) factor = (factor-fIncr) / 1.005;
  println(factor);
  float x = width / 2,
        y = height / 2,
        l = length,
        ang = 0, lx, ly;
//  beginShape();
  for(int a = 0; a < 500; a++) {
    lx = x;
    ly = y;
//    vertex(x, y);
//    stroke(colorLerp(red, blue, (float)a / 150) );
    stroke(vals[a]);
    x += l * cos(ang);
    y += l * sin(ang);
    if(abs(x) > 10 * width | abs(y) > 10 * height) break;
    l *= (1+factor);
    ang += angOffset;
    line(x, y, lx, ly);
  }
//  println("l: "+l+" and ("+x+", "+y+")");
//  endShape();
//  println(frameRate);
}

int colorLerp(int c1, int c2, float amount) {
  return color( lerp( (c1 >> 16 & 0xFF), (c2 >> 16 & 0xFF), amount), lerp( (c1 >> 8 & 0xFF), (c2 >> 8 & 0xFF), amount), lerp( (c1 & 0xFF), (c2 & 0xFF), amount) );
}

