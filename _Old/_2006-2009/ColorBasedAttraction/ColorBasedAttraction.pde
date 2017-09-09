int initNum = 150;

Dot[] all;

int a;
void setup() {
  size(700, 700);
  all = new Dot[initNum];
  smooth();
  for(a = 0; a < all.length; a++)
    all[a] = new Dot(random(width), random(height), 8, color(random(255), 0*random(255), 0*random(255)));
}


void draw() {
  background(255);
  noStroke();
  for(a = 0; a < all.length; a++)
    all[a].next(a);
}

class Dot {

  float x,
  y,
  size,
  dx,
  dy,
  temp,
  angle;
  int dispColor;
  Dot tempDot;

  Dot(float ix, float iy, float isize, int ic) {
    x = ix;
    y = iy;
    size = isize;
    dispColor = ic;
  }

  float dist;
  void next(int a) {
    for(a = 0; a < all.length; a++) {
      tempDot = all[a];
      if(!tempDot.equals(this)) {
        dist = dist(x, y, tempDot.x, tempDot.y);
        temp = similarity(tempDot)/dist;
        angle = atan2(y-tempDot.y, x-tempDot.x);
        addVelocity(temp*cos(angle), temp*sin(angle));
      }
    }
    x = bounds(x+(dx *= .95), random(1), width-random(1));
    if(x <= size | x >= width-size) dx *= -1;
    y = bounds(y+(dy *= .95), random(1), height-random(1));
    if(y <= size | y >= height-size) dy *= -1;
    show();
  }

  float similarity(Dot which) {
    return map(abs(red(dispColor)-red(which.dispColor))+abs(green(dispColor)-green(which.dispColor))+abs(green(dispColor)-green(which.dispColor)), 128, 256, 0, 2);
  }

  float equality(Dot which) {
    return map(abs(size-which.size), 2, 9, 1, 0);
  }

  void addVelocity(float adx, float ady) {
    setVelocity(dx+adx, dy+ady);
  }

  void setVelocity(float adx, float ady) {
    dx = adx;
    dy = ady;
  }

  void show() {
    fill(dispColor);
    ellipse(x, y, size*2, size*2);
  }

}

float bounds(float a, float l, float h) {
  return a > h ? h : a < l ? l : a;
}
