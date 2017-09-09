
public void rotate(PVector v, float theta) {
    float x = v.x, y = v.y;
    float xTemp = v.x;
    // Might need to check for rounding errors like with angleBetween function?
    v.x = x*cosf(theta) - y*sinf(theta);
    v.y = xTemp*sinf(theta) + y*cosf(theta);
}

List<Dot> dots = new ArrayList();
List<Attractor> as = new ArrayList();
 
public final int DOT_NUM = 1000;
public final float DT = .2f;
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
  size(192, 157);
  //do not change, this is the refresh rate of LEDs.
  frameRate(25);
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
//  drag = pow(2, randi(0, 4))/100 - .01;//0, .01, .03, .07, .15
  drag = .1;
  goNum = randi(1, 6);
  as.add(new Attractor());
}
 
float magMin, magMax;
 
void draw() {
  //  background(0); //keep background black (LEDs are brightness based)
  fill(0, 64);
  rect(0, 0, width, height);
  stroke(255, 0, 0); //LEDs are on the scale of red
  fill(255, 0, 0);   //LEDs are on the scale of red
 
  for (int i = 0; i < 5; i++) {
    magMin = 999999;
    magMax = -1;
    for (Dot d : dots) {
      d.run();
    }
    for (Dot d : dots) {
      d.update();
    }
  }
 
  if (millis() % 8000 < 180) {
    if (as.size() > goNum) {
      reset();
    } else {
      as.add(new Attractor());
    }
  }
 
/*
  fill(255);
  for (Attractor a : as) {
    text(a.f.getClass().getSimpleName(), a.x, a.y);
  }*/
}
 
 
class Dot {
  float x, y;
  float dx, dy;
 
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
    stroke(255*(mag-magMin)/(magMax - magMin), 0, 0);
    x += dx * DT;
    y += dy * DT;
    dx = dy = 0;
    //    stroke(255, 0, 0);
    //    stroke(64 + mag * 10, 0, 0);
    line(ox, oy, x, y);
 
    if (x < 0 || x > width || y < 0 || y > height) {
      reset();
    }
  }
}
 
class Attractor {
  float x, y;
  Force f;
 
  Attractor() {
    x = random(width);
    y = random(height);
    f = randomForce();
  }
 
  public void apply(Dot d) {
    PVector ff = f.force(this, d);
    d.dx += ff.x;
    d.dy += ff.y;
  }
}
 
abstract class Force {
  abstract PVector force(Attractor a, Dot d);
}
class PushForce extends Force {
 
  float exponent, scalar;
 
  public PushForce(float scalar, float exponent) {
    this.scalar = scalar;
    this.exponent = exponent;
  }
 
  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x,
    dy = a.y - d.y,
    mag = dist(0, 0, dx, dy);
    return new PVector(scalar * dx / pow(mag, exponent), scalar * dy / pow(mag, exponent));
  }
}
 
class TwirlForce extends Force {
 
  float scalar;
  public TwirlForce(float scalar) {
    this.scalar = scalar;
  }
 
  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x,
          dy = a.y - d.y;
    PVector offset = new PVector(dx, dy);
    rotate(offset, PI/2);
    offset.normalize();
    offset.mult(scalar);
    return offset;
  }
}
 
class TanForce extends Force {
 
  float scalar, offset;
  public TanForce(float scalar) {
    this.scalar = scalar;
    this.offset = random(TWO_PI);
  }
 
  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x,
          dy = a.y - d.y,
          ang = atan2(dx, dy) + offset;
    return new PVector(scalar * cosf(ang), scalar * sinf(ang));
  }
}
 
class BarForce extends Force {
 
  float scalar, scale = scalar(2, randi(0, 3)), o = random(-PI, PI);
 
  BarForce(float scalar) {
    this.scalar = scalar;
  }
 
  PVector force(Attractor a, Dot d) {
    float scalarHere = scalar*sinf((d.x*cosf(o) + d.y*sinf(o)) / scale);
 
    return new PVector(scalarHere*cosf(o), scalarHere*sinf(o));
  }
}
 
 
class RadialBarForce extends Force {
 
  float scalar, scale = pow(2, randi(0, 3));
  public RadialBarForce(float scalar) {
    this.scalar = scalar;
  }
 
  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x,
    dy = a.y - d.y,
    dist = sqrt(dx*dx+dy*dy);
    float scalarHere = scalar*sinf(dist / scale);
 
    return new PVector(scalarHere * dx / dist, scalarHere * dy / dist);
  }
}
 
 
 
class TwistForce extends Force {
  float scalar, scale = randi(2, 6);
  public TwistForce(float scalar) {
    this.scalar = scalar;
  }
 
  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x,
    dy = a.y - d.y,
    ang = atan2(dy, dx);
    return new PVector(scalar * cosf(ang*scale), scalar * sinf(ang*scale));
  }
}
 
 
Force randomForce() {
  float scalar = 2*(.2 + randStep(5))*(random(1)<.5?-1:1);
  switch(randi(1, 1)) {
  case 0:
    return new PushForce(scalar, 1);
  case 1:
    return new TwirlForce(scalar);
  case 2:
    return new TanForce(scalar);
  case 3:
    return new BarForce(scalar);
  case 4:
    return new RadialBarForce(scalar);
  case 5:
    return new TwistForce(scalar);
  }
  return null;
}
 
float randStep(int num) {
  return randi(0, num-1) / (float)num;
}
 
void keyPressed() {
  if(key == 'r') reset();
}

