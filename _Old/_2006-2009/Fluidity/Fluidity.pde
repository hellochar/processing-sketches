import java.awt.geom.*;

color ball = color(10);

int penSize = 20;
float penPower = .6;
int ballnum = 20000;

float BALL_REPEL_RATE = 3;
float WAVE_MOMENTUM_FACTOR = .2;

float BALL_TRAIL_FACTOR = .9;

float BUFFER_RELAPSE_RATE = 0;
float BUFFER_RELAPSE_SLOW_RATE = .6;
float BUFFER_SLOW_RATE = .96;

long counter = 0;

class Ball {
  float x;
  float y;
  float dx;
  float dy;
  color prevc = 0;
  int index;

  Ball(float x, float y, float dx, float dy, int index) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    prevc = w.getpix(x, y);
    w.setpix(x, y, ball);
    this.index = index;
  }

  void move() {
    if(prevc != ball) w.setpix(x, y, prevc);
    for(int mx = -1; mx < 2; mx++)
      for(int my = -1; my < 2; my++) {
        dx += wb.dxAt(x+mx, y+my);
        if(w.getpix(x+mx, y+my) == ball) {
          dx -= mx*BALL_REPEL_RATE;
          dy -= my*BALL_REPEL_RATE;
        }
        dy += wb.dyAt(x+mx, y+my);
      }
    dx /= 9;
    dy /= 9;
    if(x > width) x -= width;
    else if(x < 0) x += width;
    x += dx;
    if(y > height) y -= height;
    else if(y < 0) y += height;
    y += dy;
    if(w.getpix(x, y) == ball) {
      wb.setDxAt(x, y, wb.dxAt(x, y)*WAVE_MOMENTUM_FACTOR);
      wb.setDyAt(x, y, wb.dyAt(x, y)*WAVE_MOMENTUM_FACTOR);
      x -= dx;
      y -= dy;
    }
    else {
      prevc = w.getpix(x, y);
      w.setpix(x, y, ball);
    }
    wb.setDxAt(x, y, dx*BALL_TRAIL_FACTOR);
    wb.setDyAt(x, y, dy*BALL_TRAIL_FACTOR);
  }
}

float angleTo(Point2D.Float which, Point2D.Float to) {
  float degs = atan2(to.y-which.y, to.x-which.x);
  return degs;
}

Ball[] balls = new Ball[ballnum];
World w = new World();
Buffer wb;
void setup() {
  size(300, 300, P3D);
  wb = new Buffer();
  background(96);
  /*  for(int x = 0; x < width; x++)
   for(int y = 0; y < height; y++) {
   w.setpix(x, y, color((int)random(75, 255)));
   }*/
  counter = 0;
  for(int a = 0; a < balls.length; a++) {
    balls[a] = new Ball(random(width), random(height), 0, 0, a);
  }
}

void draw() {
  for(int a = 0; a < balls.length; a++) {
    balls[a].move();
  }
  if(mousePressed && mouseButton == LEFT) {
    Point2D.Float mp = new Point2D.Float(mouseX, mouseY);
    Point2D.Float pmp = new Point2D.Float(pmouseX, pmouseY);
    Point2D.Float temp = new Point2D.Float();
    float angAll = angleTo(pmp, mp);
    float ang;
    float speed = (float)pmp.distance(mp)*penPower;
    for(int x = 0; x <= penSize; x++)
      for(int y = 0; y <= penSize; y++) {
        float cx = mp.x-penSize/2+x;
        float cy = mp.y-penSize/2+y;
        temp.setLocation(cx, cy);
        float dist = (float)mp.distance(temp);
        if(dist <= penSize/2)
          wb.setAt(cx, cy, angAll, speed*(penSize/2-dist));
      }
  }
  else if(mousePressed && mouseButton == RIGHT) {
    balls = (Ball[])append(balls, new Ball(mouseX, mouseY, 0, 0, balls.length));
  }
  
  for(int x = 0; x < width; x++)
    for(int y = 0; y < height; y++) {
      float dx = wb.dxAt(x, y);
      float dy = wb.dyAt(x, y);
      wb.dxMomentum[x][y] += (0-dx*BUFFER_RELAPSE_SLOW_RATE)*BUFFER_RELAPSE_RATE;
      wb.dyMomentum[x][y] += (0-dy*BUFFER_RELAPSE_SLOW_RATE)*BUFFER_RELAPSE_RATE;
      wb.setDxAt(x, y, (dx*BUFFER_SLOW_RATE)+wb.dxMomentum[x][y]);
      wb.setDyAt(x, y, (dy*BUFFER_SLOW_RATE)+wb.dyMomentum[x][y]);
    }
}

class Buffer {

  float[][] dxArray;
  float[][] dyArray;
  float[][] dxMomentum;
  float[][] dyMomentum;


  Buffer() {
    dxArray = new float[width][height];
    dyArray = new float[width][height];
    dxMomentum = new float[width][height];
    dyMomentum = new float[width][height];
  }

  float dxAt(int x, int y) {
    while(x < 0) x += width;
    while(x > width - 1) x -= width;
    while(y < 0) y += height;
    while(y > height - 1) y -= height-1;
    return dxArray[x][y];
  }

  float dyAt(int x, int y) {
    while(x < 0) x += width;
    while(x > width - 1) x -= width;
    while(y < 0) y += height;
    while(y > height - 1) y -= height-1;
    return dyArray[x][y];
  }

  float dxAt(float x, float y) {
    return dxAt((int)x, (int)y);
  }
  float dyAt(float x, float y) {
    return dyAt((int)x, (int)y);
  }

  void setAt(int x, int y, float angle, float speed) {
    float xmove = cos(angle)*speed;
    float ymove = sin(angle)*speed;
    setDxAt(x, y, xmove);
    setDyAt(x, y, ymove);
  }

  void setAt(float x, float y, float angle, float speed) {
    setAt((int)x, (int)y, angle, speed);
  }

  void setDxAt(int x, int y, float val) {
    while(x < 0) x += width;
    while(x > width - 1) x -= width;
    while(y < 0) y += height;
    while(y > height - 1) y -= height-1;
    dxArray[x][y] = val;
  }

  void setDyAt(int x, int y, float val) {
    while(x < 0) x += width;
    while(x > width - 1) x -= width;
    while(y < 0) y += height;
    while(y > height - 1) y -= height-1;
    dyArray[x][y] = val;
  }

  void setDxAt(float x, float y, float val) {
    setDxAt((int)x, (int)y, val);
  }

  void setDyAt(float x, float y, float val) {
    setDyAt((int)x, (int)y, val);
  }
}



class World
{
  void setpix(float x, float y, int c) {
    while(x < 0) x += width;
    while(x > width - 1) x -= width;
    while(y < 0) y += height;
    while(y > height - 1) y -= height-1;
    set((int)x, (int)y, c);
  }

  color getpix(float x, float y) {
    while(x < 0) x += width;
    while(x > width - 1) x -= width;
    while(y < 0) y += height;
    while(y > height - 1) y -= height-1;
    return get((int)x, (int)y);
  }
}

