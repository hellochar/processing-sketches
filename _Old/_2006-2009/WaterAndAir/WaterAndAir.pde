Ball[] all;
int a;
float[] circvals;
float[] cirsvals;
int precision = 40;

void setup() {
  size(200, 700);
  circvals = new float[precision];
  cirsvals = new float[precision];
  for(int a = 0; a < precision; a++) {
    circvals[a] = cos(radians(a*360/precision));
    cirsvals[a] = sin(radians(a*360/precision));
  }
  all = new Ball[0];
  for( a = 0; a < all.length; a++) {
    //   all[a] = new Ball(random(width), random(height), 20, .4, .25);
  }
}

void draw() {
  background(255);
  if(mousePressed) {
    if(mouseButton == LEFT) 
      all = (Ball[])append(all, new Ball(mouseX, mouseY, 10+random(20), .5, .25, color(0, 0, 255), 12));
    else if(mouseButton == CENTER)
            all = (Ball[])append(all, new Brick(mouseX, mouseY, 25, .7));
//      for(a = 0; a < all.length; a++) {
  //      all[a].dx += random(-2, 2);
    //    all[a].dy += random(-2, 2);
      //}
    else
      all = (Ball[])append(all, new Ball(mouseX, mouseY, 10+random(20), .4, -.25, color(200, 60, 100), 12));
  }
  for( a = 0; a < all.length; a++) {
    all[a].run();
  }
  loadPixels();
  for( a = 0; a < all.length; a++) {
    all[a].updateAndShow();
  }
  updatePixels();
}

float bounds(float a, float l, float h) {
  return a > h ? h : a < l ? l : a;
}
int bounds(int a, int l, int h) {
  return a > h ? h : a < l ? l : a;
}

class Ball {
  float x, y;
  float dx, dy;
  float size;
  float power;
  Ball temp;
  int a;
  float d;
  float r;
  float p;
  float ymov;
  int col;
  final int id;

  Ball(float x, float y, float size, float power, float ymov, int col, int id) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.power = power;
    this.ymov = ymov;
    this.col = col;
    this.id = id;
  }

  void run() {
    //  dx = bounds(dx*.96, -10, 10);
    //    dy = bounds(dy*.96+ymov, -10, 10);
    dx *= .96;
    dy = dy*.96+ymov;
    for( a = 0; a < all.length; a++) {
      temp = all[a];
      if(temp != this) {
        //        println(d);
        if(abs(temp.x-x) < (size+temp.size)*2 & abs(temp.y-y) < (size+temp.size)*2) {
          d = dist(x, y, temp.x, temp.y);
          r = atan2(temp.y-y, temp.x-x);
          if(d < size/2+temp.size/2) {
            if(digit(id, 1) == 2) {
              //        p = pow(d-size/2+temp.size/2, 2)*.005;
              p = ((size/2+temp.size/2)-d)*(power+temp.power)/2;
              dx -= cos(r)*p;
              dy -= sin(r)*p;
            }
            else if(digit(id, 1) == 5) {
              x = temp.x-cos(r)*d;
              dx *= .6;
              y = temp.y-sin(r)*d;
              dy *= .6;
            }
          }
        }
      }
    }
  }

  void updateAndShow() {
    x = bounds(x+dx, size/2, width-size/2);
    y = bounds(y+dy, size/2, height-size/2);
    if(x == size/2 | x == width-size/2)
      dx *= -.6;
    if(y == size/2 | y == height-size/2)
      dy *= -.6;
    //    ellipse(x, y, size, size);
    //    pixels[(int)y*width+(int)x] = color(0);
    for(a = 0; a < precision; a++) {
      setAt(x+size/2*circvals[a], y+size/2*cirsvals[a], col);
    }
  }
}

void setAt(float x, float y, int c) {
  pixels[bounds((int)y, 0, height-1)*width+bounds((int)x, 0, width-1)] = c;
}

int digit(float num, int dig) {
  return int((num/pow(10, dig))%1*10);
}

class Brick extends Ball {

  float b;

  Brick(float x, float y, float size, float power) {
    super(x, y, size, power, 0, color(random(50), 200+random(55), 50+random(50)), 555);
  }

  void run() {
  }

  void updateAndShow() {
    for(a = 0; a < precision; a++) {
      setAt(x+size/2*circvals[a], y+size/2*cirsvals[a], col);
    }
  }
}
