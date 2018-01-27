import processing.video.*;
import java.util.*;

List<Dot> dots = new ArrayList();
List<Attractor> as = new ArrayList();

public final int DOT_NUM = 1000;
public final float DT = .1f;
float drag;

float cosCache[] = new float[360], 
sinCache[] = new float[360];

int goNum;

float cosf(float rad) {
  int idx = (int)(360 * ((rad+PI)/TWO_PI)) % 360;
  if (idx < 0) idx += 360;
  return cosCache[idx];
}

float sinf(float rad) {
  int idx = (int)(360 * ((rad+PI)/TWO_PI)) % 360;
  if (idx < 0) idx += 360;
  return sinCache[idx];
}

int randi(int low, int high) {
  return (int)random(low, high+1);
}


public void setup() {
  //do not change, this is fixed for LED screens.
  size(500, 500, P2D);
  noiseSeed(1);
  randomSeed(1);
  //do not change, this is the refresh rate of LEDs.
  for (int i = 0; i < DOT_NUM; i++) {
    dots.add(new Dot());
  }
  for (int i = 0; i < cosCache.length; i++) {
    cosCache[i] = cos(map(i, 0, 360, -PI, PI));
    sinCache[i] = sin(map(i, 0, 360, -PI, PI));
  }
  background(0);
  reset();
}

void reset() {
  as.clear();
  background(0);
  for (Dot d : dots) {
    d.reset();
  }
  drag = .001;
//  drag = pow(2, rrandi(0, 4))/100 - .01;//0, .01, .03, .07, .15
  goNum = rrandi(1, 6);
  as.add(new Attractor());
}

float magMin, magMax;

void draw() {
  println(frameCount +"\t"+frameRate);
  //  background(0); //keep background black (LEDs are brightness based)
  fill(0, 64);
  rect(0, 0, width, height);
  stroke(255, 0, 0); //LEDs are on the scale of red
  fill(255, 0, 0);   //LEDs are on the scale of red

  for (int i = 0; i < 10; i++) {
    magMin = 999999;
    magMax = -1;
    for (Dot d : dots) {
      d.run();
    }
    loadPixels();
    for (Dot d : dots) {
      d.update();
    }
    updatePixels();
  }

  if ((frameCount % (30*5)) == 0) { //at 30 frames/sec * 8 sec = 240 frames
    if (as.size() > goNum) {
      reset();
    } else {
      as.add(new Attractor());
      if(rrandom(1) < .2) as.add(new Attractor()); //add a second one on occasion, just for fucks sake
    }
  }
}


class Dot {
  float x, y;
  float dx, dy;
  float ax, ay;

  float mag;

  Dot() {
    reset();
  }

  void reset() {
    x = random(width);
    y = random(height);
    dx = dy = 0;
    computeMags();
  }

  void computeMags() {
    mag = sqrt(dx*dx+dy*dy);
  }

  void run() {
    computeMags();
    float d = mag;
    if (d > magMax) magMax = d;
    if (d < magMin) magMin = d;
    for (Attractor a : as) {
      a.apply(this);
    }
  }

  void update() {
    float ox = x, oy = y;
    int c = color(255*(mag-magMin)/(magMax - magMin), 0, 0);
    stroke(c);
    dx += ax * DT;
    dy += ay * DT;
    dx *= 1 - drag;
    dy *= 1 - drag;
    x += dx * DT;
    y += dy * DT;
    ax = ay = 0;
    //    stroke(255, 0, 0);
    //    stroke(64 + mag * 10, 0, 0);
//    vertex(ox, oy);
//    vertex(x, y);
    line(ox, oy, x, y);

    if (x < 0 || x >= width || y < 0 || y >= height) {
      reset();
    }
    else {
//      pixels[(int)y*width+(int)x] = c;
    }
  }
}

Random ra = new java.util.Random(1);

int rrandi(int low, int high) {
  return ra.nextInt(high-low) + low;
}

float rrandom(float low, float high) {
  return ra.nextFloat()*(high-low) + low;
}
float rrandom(float high) {
  return rrandom(0, high);
}
float rrandom() {
  return rrandom(1);
}

class Attractor {
  float x, y;
  Force f;

  Attractor() {
    x = rrandom(width);//random(width);
    y = rrandom(height);//random(height);
    f = randomForce();
  }

  public void apply(Dot d) {
    PVector ff = f.force(this, d);
    d.ax += ff.x;
    d.ay += ff.y;
  }
}

abstract class Force {
  abstract PVector force(Attractor a, Dot d);
}
class PushForce extends Force {

  float exponent, pow;

  public PushForce(float pow, float exponent) {
    this.pow = pow;
    this.exponent = exponent;
  }

  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x, 
    dy = a.y - d.y, 
    mag = dist(0, 0, dx, dy);
    return new PVector(pow * dx / pow(mag, exponent), pow * dy / pow(mag, exponent));
  }
}

class TwirlForce extends Force {

  float pow;
  public TwirlForce(float pow) {
    this.pow = pow;
  }

  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x, 
    dy = a.y - d.y, 
    ang = atan2(dy, dx);
    return new PVector(pow * cosf(ang+PI/2), pow * sinf(ang+PI/2));
  }
}

class TanForce extends Force {

  float pow, offset;
  public TanForce(float pow) {
    this.pow = pow;
    this.offset = rrandom(TWO_PI);
  }

  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x, 
          dy = a.y - d.y, 
          ang = atan2(dx, dy) + offset;
    return new PVector(pow * cosf(ang), pow * sinf(ang));
  }
}

class BarForce extends Force {

  float pow, scale = pow(2, rrandi(0, 3)), o = rrandom(-PI, PI);

  BarForce(float pow) {
    this.pow = pow;
  }

  PVector force(Attractor a, Dot d) {
    float powHere = pow*sinf((d.x*cosf(o) + d.y*sinf(o)) / scale);

    return new PVector(powHere*cosf(o), powHere*sinf(o));
  }
}


class RadialBarForce extends Force {

  float pow, scale = pow(2, rrandi(0, 3));
  public RadialBarForce(float pow) {
    this.pow = pow;
  }

  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x, 
    dy = a.y - d.y, 
    dist = sqrt(dx*dx+dy*dy);
    float powHere = pow*sinf(dist / scale);

    return new PVector(powHere * dx / dist, powHere * dy / dist);
  }
}



class TwistForce extends Force {
  float pow, scale = rrandi(2, 6);
  public TwistForce(float pow) {
    this.pow = pow;
  }

  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x, 
    dy = a.y - d.y, 
    ang = atan2(dy, dx);
    return new PVector(pow * cosf(ang*scale), pow * sinf(ang*scale));
  }
}


Force randomForce() {
  float pow = 2*(.2 + randStep(5))*(rrandom(1)<.5?-1:1);
  switch(rrandi(0, 5)) {
  case 0:
    return new PushForce(pow, 1);
  case 1:
    return new TwirlForce(pow);
  case 2:
    return new TanForce(pow);
  case 3:
    return new BarForce(pow);
  case 4:
    return new RadialBarForce(pow);
  case 5:
    return new TwistForce(pow);
  }
  return null;
}

float randStep(int num) {
  return rrandi(0, num-1) / (float)num;
}

void keyPressed() {
  if(key == 'r') reset();
}
