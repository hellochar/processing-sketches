float init = .6, mult = PI;

PFont f;

void setup() {
  size(500, 500);
  f = loadFont("AbadiMT-Condensed-30.vlw");
  textFont(f, 20);
  textAlign(LEFT, BOTTOM);
}

void draw() {
  background(0);
//  init = TWO_PI* mouseX / width;
//  mult = TWO_PI* mouseY / height;
  if(keyPressed) {
    if(keyCode == UP) {
      mult += TWO_PI / 2000;
    }
    else if(keyCode == DOWN) {
      mult -= TWO_PI / 2000;
    }
  }
  float y = sin(init);
  for(float a = 0; a < 500; a += .25) {
    y = sin(y*mult);
    point(a, height/3*(y+1));
  }
  text(round(init, 3)+", "+round(mult, 3), 0, height);
}


public static float round(float val, int digit) {
  return floor(val * pow(10, digit) + .5)/pow(10, digit);
}
