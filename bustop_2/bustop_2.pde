
public void rotate(PVector v, float theta) {
    float x = v.x, y = v.y;
    float xTemp = v.x;
    // Might need to check for rounding errors like with angleBetween function?
    v.x = x*cosf(theta) - y*sinf(theta);
    v.y = xTemp*sinf(theta) + y*cosf(theta);
}

ArrayList<Dot> dots = new ArrayList();
ArrayList<Attractor> as = new ArrayList();
 
public final int DOT_NUM = 20000;
public final float DT = 1f;
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

int[] lastIterationOccupied;

final int NUM_ITERATIONS = 5;
 
public void setup() {
  size(displayWidth, displayHeight, P2D);
  lastIterationOccupied = new int[width*height]; 
  for (int i = 0; i < DOT_NUM; i++) {
    dots.add(new Dot());
  }
  for (int i = 0; i < cosCache.length; i++) {
    cosCache[i] = cos(map(i, 0, 360, -PI, PI));
    sinCache[i] = sin(map(i, 0, 360, -PI, PI));
  }
  background(255);
  reset();
  colorMode(HSB);
}
 
void reset() {
  as.clear();
  background(255);
  for (Dot d : dots) {
    d.reset();
  }
//  drag = pow(2, randi(0, 4))/100 - .01;//0, .01, .03, .07, .15
  drag = .1;
  goNum = randi(3, 6);
  as.add(new Attractor());
}
 
float magMin, magMax;

int iterationCount = 0;

void draw() {
  println(frameRate);
//    background(0); //keep background black (LEDs are brightness based)
  fill(255, 17); noStroke();
  rect(0, 0, width, height);
//  stroke(255, 0, 0); //LEDs are on the scale of red
//  fill(255, 0, 0);   //LEDs are on the scale of red
 
  beginShape(LINES);
  for (int i = 0; i < NUM_ITERATIONS; i++) {
    magMin = 999999;
    magMax = -1;
    for (Dot d : dots) {
      d.run();
    }
    for (Dot d : dots) {
      d.update();
    }
    iterationCount++;
  }
  endShape();
 
//  if (millis() % 8000 < 180) {
//    if (as.size() > goNum) {
//      reset();
//    } else {
//      as.add(new Attractor());
//    }
//  }
 
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
    for (Attractor a : as) {
      a.apply(this);
    }
//    for(Dot d : dots) {
//      if(d != this) {
//        float ox = x - d.x,
//              oy = y - d.y,
//              distance = dist(0, 0, ox, oy); 
//        if(distance < 3) {
//          dx += ox / distance;
//          dy += oy / distance;
//        }
//      }
//    }
    computeMags();
    float d = mag;
    if (d > magMax) magMax = d;
    if (d < magMin) magMin = d;
  }
 
  void update() {
    float ox = x, oy = y;
    stroke(map(atan2(dy, dx), -PI, PI, 0, 255/2), 255, 255*sqrt(map(mag, magMin, magMax, .5, 1)));
//    stroke(0, 255, 255);
    x += dx * DT;
    y += dy * DT;
    dx = dy = 0;
//    stroke(255, 0, 0);
//    stroke(64 + mag * 10, 0, 0);
//    line(ox, oy, x, y);
    vertex(ox, oy);
    vertex(x, y);
    
    if (x < 0 || x >= width || y < 0 || y >= height) {
      reset();
    }
    int pixelIndex = (int)y * width + (int)x;
    if(lastIterationOccupied[pixelIndex] != iterationCount) {
      lastIterationOccupied[pixelIndex] = iterationCount;
    } else {
      // someone else has already claimed this spot
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
 
  float scalar, scale = min(width, height) / 20 * pow(2, randi(0, 3)), o = random(-PI, PI),
        timer = 0f;
 
  BarForce(float scalar) {
    this.scalar = scalar;
  }
 
  PVector force(Attractor a, Dot d) {    
    float scalarHere = scalar*sinf((d.x*cosf(o) + d.y*sinf(o)) / scale + millis() / 1000f);
 
    return new PVector(scalarHere*cosf(o), scalarHere*sinf(o));
  }
}
 
 
class RadialBarForce extends Force {
 
  float scalar, scale = min(width, height) / 20 * pow(2, randi(0, 3));
  public RadialBarForce(float scalar) {
    this.scalar = scalar;
  }
 
  PVector force(Attractor a, Dot d) {
    float dx = a.x - d.x,
    dy = a.y - d.y,
    dist = sqrt(dx*dx+dy*dy);
    float directionScalar = 2 / (1 + exp(-5 * sinf(millis() / 1000f))) - 1;
    float scalarHere = directionScalar*scalar*sinf(dist / scale);
 
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
  return randomForce(randi(0,5));
}
 
Force randomForce(int idx) {
//  float scalar = 2*(.2 + randStep(5))*(random(1)<.5?-1:1);
  float scalar = .5 * (random(1)<.5?-1:1);
  switch(idx) {
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

// random from 0 - 1, subdivided into num buckets
float randStep(int num) {
  return randi(0, num-1) / (float)num;
}
 
void keyPressed() {
  if(key == 'r') reset();
  if(key == ' ') as.add(new Attractor());
  if(key >= '0' && key <= '5') {
    randomForce(key - '0');
  }
}
