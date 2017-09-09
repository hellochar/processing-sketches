WBuffer b;

int ballNum;

Ball[] balls;
float r;
float sinval;
float cosval;

int a, c;

void setup() {
  size(300, 300);
  ballNum = width * height / 10;
  background(0);
  b = new WBuffer(width, height);
  balls = new Ball[ballNum];
  for(int a = 0; a < balls.length; a++) {
    balls[a] = new Ball(random(width), random(height), b);
  }
  //  b.setBlock(0, 0, b.getW(), b.getH(), 0, 1);
  //  frameRate(15);
}

void draw() {
//  background(0);
  loadPixels();
  if(mousePressed) {
    if(mouseButton == LEFT & (pmouseX != mouseX | pmouseY != mouseY)) {
      r = atan2(pmouseY-mouseY, pmouseX-mouseX);
      sinval = -sin(r)*2;
      cosval = -cos(r)*2;
      for(a = -20; a <= 20; a++) {
        for(c = -20; c <= 20; c++) {
          if(sqrt(a*a+c*c)<=20) {
            this.b.buffAt(mouseX+a, mouseY+c).addTo(cosval, sinval);
          }
        }
      }
    }
    else if(mouseButton == RIGHT){
      b.setBlock(0, 0, b.getW(), b.getH(), 0, 0);
    }
    else if(mouseButton == CENTER) {
      for(int a = 0; a < balls.length; a++) {
        pixels[(((int)balls[a].y)*width+(int)balls[a].x)] = color(0);
        balls[a].x = random(width);
        balls[a].y = random(height);
      }
    }
  }
  b.run();
  b.update();
//  b.show();
  for(int a = 0; a < balls.length; a++)
    balls[a].runAndShow();
  updatePixels();
}


float wrap(float a, float low, float high) {
  if(low < high) {
    while(a < low) a += (high-low);
    while(a > high) a -= (high-low);
  }
  return a;
}

int wrap(int a, int low, int high) {
  if(low < high) {
    while(a < low) a += (high-low);
    while(a > high) a -= (high-low);
  }
  return a;
}

class Ball {
  float x;
  float y;
  float dx;
  float dy;
  UBuffer temp;
  WBuffer world;

  Ball(float x, float y, WBuffer world) {
    this.x = x;
    this.y = y;
    this.world = world;
    dx = 0;
    dy = 0;
  }

  void runAndShow() {
    run();
  }

  void run() {
    temp = world.buffAt(x, y);
    float tx = (temp.dx-dx)*.5;
    float ty = (temp.dy-dy)*.5;
    temp.dx -= tx;
    temp.dy -= ty;
    dx += tx;
    dy += ty;
    move(dx, dy);
  }

  void move(float nx, float ny) {
    pixels[(((int)y)*width+(int)x)] = color(0);
    x = wrap(x+nx, 0, width-1);
    y = wrap(y+ny, 0, height-1);
    pixels[(((int)y)*width+(int)x)] = color(255);
  }
}

class UBuffer {
  final int x;
  final int y;
  float dx;
  float dy;
  float nx;
  float ny;
  float tx;
  float ty;
  WBuffer world;
  int s;
  int t;
  int ds;
  int dt;
  UBuffer temp;

  UBuffer(int x, int y, WBuffer world) {
    this.x = x;
    this.y = y;
    this.world = world;
  }

  void setTo(float dx, float dy) {
    this.dx = dx;
    this.dy = dy;
  }

  void addTo(float dx, float dy) {
    this.dx += dx;
    this.dy += dy;
  }

  void run() {
    nx = 0;
    ny = 0;
    for(s = -1; s < 2; s++) {
      for(t = -1; t < 2; t++) {
        ds = x+s;
        dt = y+t;
        temp = world.buffAt(ds, dt);
        nx += temp.dx;
        ny += temp.dy;
        if(pixels[wrap(dt, 0, world.w-1)*world.w+wrap(ds, 0, world.h-1)] == color(255)) {
          nx -= s;
          ny -= t;
        }
      }
    }
    nx /= 9;
    ny /= 9;
    tx += nx;
    ty += ny;
  }

  void update() {
    setTo(tx, ty);
    tx = 0;
    ty = 0;
  }
}

class WBuffer {
  UBuffer[][] data;
  final int w;
  final int h;
  int a;
  int b;
  UBuffer temp;

  WBuffer(int w, int h) {
    this.w = w;
    this.h = h;
    data = new UBuffer[w][h];
    for(a = 0; a < w; a++) {
      for(b = 0; b < h; b++) {
        data[a][b] = new UBuffer(a, b, this);
      }
    }
  }

  UBuffer buffAt(int x, int y) {
    return data[wrap(x, 0, w-1)][wrap(y, 0, h-1)];
  }

  UBuffer buffAt(float x, float y) {
    return data[round(wrap(x, 0, w-1))][round(wrap(y, 0, h-1))];
  }

  void run() {
    for(a = 0; a < w; a++) {
      for(b = 0; b < h; b++) {
        buffAt(a, b).run();
      }
    }
  }

  void update() {
    for(a = 0; a < w; a++) {
      for(b = 0; b < h; b++) {
        buffAt(a, b).update();
      }
    }
  }

  void setBlock(int x, int y, int h, int w, float dx, float dy) {
    for(a = 0; a < w; a++) {
      for(b = 0; b < h; b++) {
        buffAt(x+a, y+b).setTo(dx, dy);
      }
    }  
  }
  void addBlock(int x, int y, int h, int w, float dx, float dy) {
    for(a = 0; a < w; a++) {
      for(b = 0; b < h; b++) {
        buffAt(x+a, y+b).addTo(dx, dy);
      }
    }  
  }

  int getW() {
    return w;
  }

  int getH() {
    return h;
  }

  void show() {
    for(a = 0; a < w; a++) {
      for(b = 0; b < h; b++) {
        temp = buffAt(a, b);
        pixels[b*width+a] = color((abs(temp.dx)+abs(temp.dy))*10%255);
      }
    }
  }
}
