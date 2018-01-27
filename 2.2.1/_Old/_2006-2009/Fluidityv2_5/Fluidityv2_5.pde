import java.awt.geom.*;

color ball = color(10);

int penSize = 20;
float penPower = 15;
int ballnum = 0000;

float BALL_REPEL_RATE = 3;
float WAVE_MOMENTUM_FACTOR = .99;

float BALL_TRAIL_FACTOR = .99;

float BUFFER_RELAPSE_RATE = .2;
float BUFFER_RELAPSE_SLOW_RATE = 1;

float BUFFER_SLOW_RATE = .9;
float BUFFER_MOVE_RATE = .15;
float BUFFER_EQUALIZE_RATE = .8;
float penRise = 50;

long counter = 0;



//Ball[] balls = new Ball[ballnum];
World w = new World();
Buffer b;
Point2D.Float mp;
Point2D.Float pmp;
Point2D.Float temp;
void setup() {
  size(200, 200, P3D);
  b = new Buffer();
  mp = new Point2D.Float();
  pmp = new Point2D.Float();
  temp = new Point2D.Float();
  /*  for(int x = 0; x < width; x++)
   for(int y = 0; y < height; y++) {
   w.setpix(x, y, color((int)random(75, 255)));
   }
   counter = 0;
   for(int a = 0; a < balls.length; a++) {
   balls[a] = new Ball(random(width), random(height), 0, 0, a);
   }*/
}

int penMult = 1;
float angAll;
float ang;
float speed;

float cx;
float cy;

float dist;


bufferUnit uAt;
bufferUnit uEnum;
//bufferUnit[] nearby = new bufferUnit[9];
//bufferUnit[] surrounding = new bufferUnit[5];

float dif;
float weight;
float change;
float momen;
int index;
int mx;
int my;

void draw() {
  if(mousePressed) {
    mp.setLocation(mouseX, mouseY);
    pmp.setLocation(pmouseX, pmouseY);
    dif = (float)pmp.distance(mp);
    if(mouseButton == LEFT) penMult = 1;
    else penMult = -1;
    if(dif <= 1) {
      speed = penPower*10;
      for(mx = 0; mx <= penSize; mx++)
        for(my = 0; my <= penSize; my++) {
          cx = mp.x-penSize/2+mx;
          cy = mp.y-penSize/2+my;
          temp.setLocation(cx, cy);
          dist = (float)mp.distance(temp);
          if(dist <= penSize/2) {
            ang = radAlign(angleTo(temp, mp));
                      b.setWeight(cx, cy, b.getWeight(cx, cy)+(penRise*penMult));
            //          if(speed != 0)
            //            b.set(cx, cy, angAll, speed*(penSize/2-dist));
          }
        }
    }
    else {
      ang = radAlign(angleTo(pmp, mp));
      speed = dif*penPower;
      for(int a = 0; a < dif; a++) {
        cx = mp.x+a*(mouseX-pmouseX)/dif;
        cy = mp.y+a*(mouseY-pmouseY)/dif;
        b.setWeight(cx, cy, b.getWeight(cx, cy)+speed*penMult);
//        b.set(mp.x+a*(mouseX-pmouseX)/dif, mp.y+a*(mouseY-pmouseY)/dif, ang, speed);
      }
    }

    //          println(degrees(angAll));
  }
  /*  else if(mousePressed & mouseButton == RIGHT) {
   balls = (Ball[])append(balls, new Ball(mouseX, mouseY, 0, 0, balls.length));
   }*/
  //  nearby = new bufferUnit[9];
  for(int x = 0; x < width; x++)
    for(int y = 0; y < height; y++) {
      uAt = b.unitAt(x,y);
      weight = uAt.previous.weight;
      change = 0;
      speed = uAt.previous.speed;
      ang = uAt.previous.angle;
      mx = cosRound(ang);
      my = sinRound(ang);
      for(int dx = -1; dx < 2; dx++)
        for(int dy = -1; dy < 2; dy ++) {
          uEnum = b.unitAt(x+dx, y+dy);
          if(!uEnum.equals(uAt)) {
          index = dy+1+(dx+1)*3;
//          nearby[index] = uEnum;
          dif = (weight-uEnum.previous.weight)*BUFFER_MOVE_RATE;
          momen = (uAt.previous.weightMomentum[index] - dif)*BUFFER_EQUALIZE_RATE;
          uEnum.weight -= momen;
          uAt.weightMomentum[index] = momen;
          change += momen;
          }          
        }

/*      surrounding[0] = b.unitAt(x+mx-1, y+my);
      surrounding[1] = b.unitAt(x+mx, y+my-1);
      surrounding[2] = b.unitAt(x+mx, y+my);
      surrounding[3] = b.unitAt(x+mx, y+my+1);
      surrounding[4] = b.unitAt(x+mx+1, y+my);
      if(speed != 0) {
        for(int a = 0; a < 5; a++) {
          uEnum = surrounding[a];
          if(uEnum.speed <= speed & abs(surrounding[a].x()-x) == 1 & abs(surrounding[a].y()-y) == 1) {
            uEnum.speed = BUFFER_SLOW_RATE*(speed+uEnum.previous.speed)/2;
            uEnum.angle = (ang+uEnum.previous.angle)/2;
            uEnum.weight += uAt.previous.speed;
            change -= uAt.previous.speed;
          }
        }
      }*/
      uAt.weight += change;
    }
  for(int x = 0; x < width; x++)
    for(int y = 0; y < height; y++) {
      uAt = b.unitAt(x, y);
      uAt.updatePrevious();
      uAt.display();
    }
  /*  for(int a = 0; a < balls.length; a++) {
   balls[a].move();
   }*/
}

float angAlign(float ang) {
  ang = ang%360;
  if(ang < 0) ang = 180 + (180-ang);
  return ang;
}

float radAlign(float ang) {
  ang = ang%TWO_PI;
  if(ang < 0) ang = PI+(PI-ang);
  return ang;
}




int cosRound(float ang) {
  ang = angAlign(degrees(ang));
  if( (ang >= 0 & ang <= 60) || (ang >= 300 & ang <= 360) )
    return 1;
  else if(ang >= 120 & ang <= 240)
    return -1;
  return 0;
}

/*cos: 0-60 = 1
 
 120-240 = -1
 
 300 - 360 = 1*/

int sinRound(float ang) {
  ang = angAlign(degrees(ang));
  if( ang >= 30 & ang <= 150)
    return 1;
  else if(ang >= 210 & ang < 330)
    return -1;
  return 0;
}



float angleTo(Point2D.Float which, Point2D.Float to) {
  float degs = atan2(to.y-which.y, to.x-which.x);
  return degs;
}

int wrapScrnX(int x) {
 while(x < 0) x += width;
 while(x > width-1) x -= width-1;
 return x;
 }
 
 int wrapScrnY(int y) {
 while(y < 0) y += height;
 while(y > height-1) y -= height-1;
 return y;
 }

/*sin: 30 - 150: 1
 
 210 - 330 = -1*/

/*class Ball {
 float x;
 float y;
 float dx;
 float dy;
 float px;
 float py;
 color prevc = 0;
 int index;
 
 Ball(float x, float y, float dx, float dy, int index) {
 this.x = x;
 this.y = y;
 this.dx = dx;
 this.dy = dy;
 this.px = px;
 this.py = py;
 prevc = w.getpix(x, y);
 w.setpix(x, y, ball);
 this.index = index;
 }
 
 void move() {
 if(prevc != ball) {
 //      stroke(prevc);
 //      if(abs(px-x) < width-100 & abs(py-y) < height-100) line(px, py, x, y);
 w.setpix(x, y, prevc);
 }
 px = x;
 py = y;
 dx = 0;
 dy = 0;
 nearby = b.adjacentBuffers((int)x, (int)y);
 for(int mx = 0; mx < 9; mx++) {
 uEnum = nearby[mx];
 if(w.getpix(uEnum.x(), uEnum.y()) == ball) {
 dx -= mx*BALL_REPEL_RATE;
 dy -= my*BALL_REPEL_RATE;
 }
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
 b.setDxAt(x, y, b.dxAt(x, y)*WAVE_MOMENTUM_FACTOR);
 b.setDyAt(x, y, b.dyAt(x, y)*WAVE_MOMENTUM_FACTOR);
 x -= dx;
 y -= dy;
 }
 else {
 prevc = w.getpix(x, y);
 //      stroke(ball);
 //      if(abs(px-x) < width-100 & abs(py-y) < height-100) line(px, py, x, y);
 w.setpix(x, y, ball);
 }
 b.setDxAt(x, y, dx*BALL_TRAIL_FACTOR);
 b.setDyAt(x, y, dy*BALL_TRAIL_FACTOR);
 }
 }*/


class bufferUnit {
  private int x;
  private int y;
  float angle;
  float speed;
  float weight;
  float[] weightMomentum;
  bufferUnit previous;

  bufferUnit(int x, int y) {
    this.x = x;
    this.y = y;
    angle = 0;
    speed = 0;
    weight = 96;
    weightMomentum = new float[9];
    previous = new bufferUnit();
    previous.x = x;
    previous.y = y;
  }

  bufferUnit() {
    x = 0;
    y = 0;
    angle = 0;
    speed = 0;
    weight = 96;
    weightMomentum = new float[9];
  }

  int x() {
    return x;
  }

  int y() {
    return y;
  }

  void display() {
    w.setpix(x, y, color(weight));
  }

  void updatePrevious() {
    previous.weight = weight;
    previous.speed = speed;
    previous.angle = angle;
    for(int x = 0; x < 9; x++)
      previous.weightMomentum[x] = weightMomentum[x];
  }
}

class Buffer {

  bufferUnit[][] units;

  Buffer() {
    units = new bufferUnit[width][height];
    for(int x = 0; x < width; x++)
      for(int y = 0; y < height; y++)
        units[x][y] = new bufferUnit(x, y);
  }

  bufferUnit unitAt(int x, int y) {
    return units[wrapScrnX(x)][wrapScrnY(y)];
  }

  float getAngle(int x, int y) {
    return unitAt(x, y).angle;
  }

  float getAngle(float x, float y) {
    return getAngle(round(x), round(y));
  }

  float getSpeed(int x, int y) {
    return unitAt(x, y).speed;
  }

  float getSpeed(float x, float y) {
    return getSpeed(round(x), round(y));
  }


  float getWeight(int x, int y) {
    return unitAt(x, y).weight;
  }

  float getWeight(float x, float y) {
    return getWeight(round(x), round(y));
  }



  void setAngle(int x, int y, float angle) {
    unitAt(x, y).angle = angle;
  }

  void setAngle(float x, float y, float angle) {
    setAngle(round(x), round(y), angle);
  }

  void setSpeed(int x, int y, float speed) {
    unitAt(x, y).speed = speed;
  }

  void setSpeed(float x, float y, float speed) {
    setSpeed(round(x), round(y), speed);
  }

  void setWeight(int x, int y, float weight) {
    unitAt(x, y).weight = weight;
  }

  void setWeight(float x, float y, float weight) {
    setWeight(round(x), round(y), weight);
  }

  void set(int x, int y, float angle, float speed) {
    setAngle(x, y, angle);
    setSpeed(x, y, speed);
  }

  void set(float x, float y, float angle, float speed) {
    set(round(x), round(y), angle, speed);
  }

  bufferUnit[] adjacentBuffers(int x, int y) {
    bufferUnit[] bu = {
      unitAt(x-1, y-1), unitAt(x-1, y), unitAt(x-1, y+1),
      unitAt(x, y-1), unitAt(x, y), unitAt(x, y+1),
      unitAt(x+1, y-1), unitAt(x+1, y), unitAt(x+1, y+1)                };
    return bu;
  }
}


class World
{
  void setpix(float x, float y, int c) {
    set(wrapScrnX(round(x)), wrapScrnY(round(y)), c);
  }

  color getpix(float x, float y) {
    return get(wrapScrnX(round(x)), wrapScrnY(round(y)));
  }
}

