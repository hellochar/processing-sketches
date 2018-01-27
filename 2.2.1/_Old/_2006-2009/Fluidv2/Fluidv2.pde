WBuffer b;

int ballNum = 500;

Ball[] balls;

void setup() {
  size(300, 300);
  b = new WBuffer(width, height);
  balls = new Ball[ballNum];
  for(int a = 0; a < balls.length; a++) {
    balls[a] = new Ball(random(width), random(height), b);
  }
  /*  balls = new Ball[width*height];
   for(int a = 0; a < width; a++) {
   for(int b = 0; b < height; b++) {
   balls[a*width+b] = new Ball(a, b, this.b);
   }
   }*/
}

void draw() {
//    background(color(96, 25));
  if(mousePressed) {
    if(mouseButton == LEFT & (pmouseX != mouseX | pmouseY != mouseY)) {
      float r = atan2(pmouseY-mouseY, pmouseX-mouseX);
      float sinval = -sin(r)*2;
      float cosval = -cos(r)*2;
      for(int a = -15; a <= 15; a++) {
        for(int b = -15; b <= 15; b++) {
          if(sqrt(a*a+b*b)<=15)
            this.b.buffAt(mouseX+a, mouseY+b).addTo(cosval, sinval);
        }
      }
    }
    else if(mouseButton == RIGHT){
      b.setBlock(0, 0, b.getW(), b.getH(), 0, 0);
    }
    else if(mouseButton == CENTER) {
      for(int a = 0; a < balls.length; a++) {
        balls[a].x = random(width);
        balls[a].y = random(height);     
      }
    }
  }
  b.run();
  b.update();
  b.show();
  for(int a = 0; a < balls.length; a++)
    balls[a].runAndShow();
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
    show();
  }

  void run() {
    temp = world.buffAt(x, y);
    dx = (dx+temp.dx)/2;
    dy = (dy+temp.dy)/2;
    temp.addTo(dx, dy);
    x = wrap(x+dx, 0, width-1);
    y = wrap(y+dy, 0, height-1);
  }

  void show() {
    set(round(x), round(y), color(255));
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
        temp = world.buffAt(x+s, y+t);
        nx += temp.dx;
        ny += temp.dy;
      }
    }
    nx /= 9;
    ny /= 9;
    tx += nx;
    ty += ny;
  }

  void update() {
    setTo(tx*.9925, ty*.9925);
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
    //    println(x+", "+y+":::"+w+", "+h);
    return data[wrap(x, 0, w-1)][wrap(y, 0, h-1)];
  }

  UBuffer buffAt(float x, float y) {
    //    prfloatln(x+", "+y+":::"+w+", "+h);
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

  int getW() {
    return w;
  }

  int getH() {
    return h;
  }

  void show() {
    loadPixels();
    for(a = 0; a < w; a++) {
      for(b = 0; b < h; b++) {
        temp = buffAt(a, b);
        pixels[b*width+a] = color((abs(temp.dx)+abs(temp.dy))*10%255);
      }
    }
    updatePixels();
  }
}
