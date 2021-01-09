import java.util.*;

boolean springNeighbors = false;

List<Dot> dots = new ArrayList<Dot>();

void setup() {
  size(800, 600, P2D);
  Dot first = new Dot(width/2, height/2);
  dots.add(first);
  first.next = first;
  first.previous = first;
}

class Dot {
  float x, y;
  float vx, vy;
  float ax, ay;
  Dot next, previous;
  Dot(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void step() {
    this.ax = this.ay = 0;

    // avoid other dots
    for (Dot d : dots) {
      float dx = d.x - x;
      float dy = d.y - y;
      float dist2 = dx*dx + dy*dy;
      float dist = sqrt(dist2);
      if (dist <= 0 || dist > 100) continue;

      // at distance 10, have no force
      // 

      float powAttract = 1.5;
      float powRepel = 100;
      float fx = powAttract * dx / (dist2 + 10 * 10) - powRepel * dx / (dist2 * dist + 1);
      float fy = powAttract * dy / (dist2 + 10 * 10) - powRepel * dy / (dist2 * dist + 1);
      this.ax += fx;
      this.ay += fy;

      //if (dist < 20) {
      //  addSpringForce(d, 0.02, 10);
      //}
    }

    // drag
    this.ax += -this.vx * 0.9;
    this.ay += -this.vy * 0.9;

    // spring towards two neighbors in line

    if (springNeighbors) {
      if (next != null) {
        addSpringForce(next, 0.2, 10);
      }
      if (previous != null) {
        addSpringForce(previous, 0.2, 10);
      }
    }

    // push your two neighbors towards each other
    //if (next != null && previous != null) {
    //  next.addSpringForce(previous, 0.1, 10);
    //  previous.addSpringForce(next, 0.1, 10);
    //}

    // noise
    this.ax += (noise(x / 200, y / 200, frameCount / 20f) - 0.5) * 10;
    this.ay += (noise(x / 200, y / 200, frameCount / 20f + 12f) - 0.5) * 10;
  }

  void update() {
    PVector a = new PVector(ax, ay);
    if (a.mag() > 10) {
      a.setMag(10);
    }
    this.vx += a.x;
    this.vy += a.y;
    this.x += this.vx;
    this.y += this.vy;

    float bodyRadius = 5;

    //if (this.x - bodyRadius < 0 || this.x + bodyRadius > width) {
    //  this.x = constrain(this.x, bodyRadius, width - bodyRadius);
    //  this.vx *= 0.85;
    //}
    //if (this.y - bodyRadius < 0 || this.y + bodyRadius > height) {
    //  this.y = constrain(this.y, bodyRadius, height - bodyRadius);
    //  this.vy *= 0.85;
    //}
  }

  void multiply() {
    float nx, ny;
    if (previous != null && previous != this) {
      float ox = previous.x - x;
      float oy = previous.y - y;
      nx = x + ox;
      ny = y + oy;
    } else {
      nx = x + random(-10, 10);
      ny = y + random(-10, 10);
    }
    Dot d = new Dot(nx, ny);
    dots.add(d);
    Dot oldNext = next;
    if (oldNext != null) {
      oldNext.previous = d;
    }
    next = d;
    d.next = oldNext;
    d.previous = this;
  }

  void addSpringForce(Dot d, float springPowerCoefficient, float wantedDistance) {
    if (d == this) {
      return;
    }
    float dx = d.x - x;
    float dy = d.y - y;
    PVector dVec = new PVector(dx, dy);

    //float springPowerCoefficient = 0.1;
    //float wantedDistance = 10;

    float actualDistance = dVec.mag();
    float distanceOffset = actualDistance - wantedDistance;

    float springPower = springPowerCoefficient * distanceOffset;

    PVector direction = dVec.copy().normalize();
    PVector force = direction.copy().setMag(springPower);

    this.ax += force.x;
    this.ay += force.y;
  }

  void draw() {
    fill(255, 125, 0);
    stroke(24, 69, 180);
    ellipse(x, y, 10, 10);
    
    if (next != null) {
      //line(x, y, next.x, next.y);
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    springNeighbors = !springNeighbors;
  } else if (key == 'd') {
    List<Dot> allDots = new ArrayList<Dot>(dots.size());
    allDots.addAll(dots);
    for (Dot d : allDots) {
      d.multiply();
    }
  }
}

void draw() {
  background(0);
  if (mousePressed) {
    //dots.get(dots.size() - 1).multiply();
    //dots.get(0).multiply();
    dots.get((int)random(0f, dots.size())).multiply();
  }
  for (Dot d : dots) {
    d.step();
  }
  for (Dot d : dots) {
    d.update();
  }

  translate(width/2, height/2);
  float avgX = 0, avgY = 0;
  float minX = Float.POSITIVE_INFINITY, maxX = Float.NEGATIVE_INFINITY, minY = Float.POSITIVE_INFINITY, maxY = Float.NEGATIVE_INFINITY;
  for (Dot d : dots) {
    avgX += d.x;
    avgY += d.y;
    minX = min(minX, d.x - 5);
    maxX = max(maxX, d.x + 5);
    minY = min(minY, d.y - 5);
    maxY = max(maxY, d.y + 5);
  }
  avgX /= dots.size();
  avgY /= dots.size();
  float wormWidth = maxX - minX;
  float wormHeight = maxY - minY;
  float ratioWidth = width / wormWidth;
  float ratioHeight = height / wormHeight;
  //println(minX, maxX, minY, maxY, wormWidth, wormHeight, ratioWidth, ratioHeight);
  float minRatio = min(ratioWidth, ratioHeight);
  scale(minRatio * 0.75);
  translate(-avgX, -avgY);
  
  //strokeWeight(5);
  //stroke(255, 125, 0, 128);
  //noFill();
  //beginShape();
  //if (dots.size() >= 2) {
  //  for (Dot d = dots.get(1); d != dots.get(0) && d != null; d = d.next) {
  //    vertex(d.x, d.y);
  //  }
  //}
  //endShape();
  
  strokeWeight(1);
  for (Dot d : dots) {
    d.draw();
  }

  resetMatrix();
  fill(255);
  text(dots.size(), 20, 20);
  text("neighbor spring force: " + springNeighbors, 20, 40);
}