float x, y;
float dx, dy;

void setup() {
  size(600, 600);
  background(0);
  x = width/2;
  y = height/2;
  set(int(x), int(y), color(255, 0, 0));
  set(int(x), int(y), color(255, 0, 0));
  reRandom();
//  noLoop();
}

int counter = 0;
float radius = 4;

int rand;
void draw() {
  loadPixels();
  for(int a = 0; a < 26; a++) {
    while(!nearby()) {
      switch(int(random(4))) {
      case 0: //left
        dx--;
        break;
      case 1: //right
        dx++;
        break;
      case 2: //up
        dy--;
        break;
      case 3: //down
        dy++;
        break;
      }
      if(dist(x, y, dx, dy) > radius*1.5)
        reRandom();
    }
    setAt(dx, dy, color(0, 0, 100+155*a/26));
    reRandom();
    radius += .05;
  }
  updatePixels();
  //  println(frameRate);
}

float ang;
void reRandom() {
  ang = random(0, TWO_PI);
  dx = x+cos(ang)*radius;
  dy = y+sin(ang)*radius;
}

int nx, ny;
boolean nearby() {
  for(nx = -1; nx < 2; nx++) {
    for(ny = -1; ny < 2; ny++) {
      if(getAt(dx+nx, dy+ny) != color(0)) return true;
    }
  }
  return false;
}

void setAt(int x, int y, int c) {
  if(x < 0 | x > width-1 | y < 0 | y > height-1) return;
  pixels[y*width+x] = c;
}

void setAt(float x, float y, int c) {
  setAt(int(x), int(y), c);
}

int getAt(int x, int y) {
  if(x < 0 | x > width-1 | y < 0 | y > height-1) return 0;
  return pixels[y*width+x];
}

int getAt(float x, float y) {
  return getAt(int(x), int(y));
}
