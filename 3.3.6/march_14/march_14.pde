import java.util.*;

float sinDistScalar;
float G;

float t = 0;

class Particle {
  int idx;
  float x, y, vx, vy;
  float fx, fy;
  Particle(int idx, float x, float y) {
    this.idx = idx;
    this.x = x;
    this.y = y;
    vx = vy = 0;
  }

  void computeForceSingle(Particle p) {
    
    if (p != this && this.idx < p.idx) {
      float dfx = 0, dfy = 0;

      float ox = p.x - x;
      float oy = p.y - y;
      float dist2 = ox*ox + oy*oy;
      // if (dist2 < 5 * 5) return;
      float dist = sqrt(dist2);
      float distFactor = G * sin(dist / sinDistScalar) / dist2;
      // float distFactor = min(100, 1 / (dist * dist));
      if (!Float.isNaN(distFactor)) {
        dfx += ox * distFactor;
        dfy += oy * distFactor;
      }
      // repel force when very close by
      float repelFactor = -1000 / (dist2 * dist);
      if (!Float.isNaN(repelFactor)) {
        dfx += ox * repelFactor;
        dfy += oy * repelFactor;
      }

      fx += dfx;
      fy += dfy;
      p.fx -= dfx;
      p.fy -= dfy;
    }
  }

  void computeForce() {
    int bucketCX = floor(x / PX_PER_BUCKET);
    int bucketCY = floor(y / PX_PER_BUCKET);
    for (int dBucketX = -1; dBucketX <= 2; dBucketX++) {
      for (int dBucketY = -1; dBucketY <= 2; dBucketY++) {
        int bX = bucketCX + dBucketX;
        int bY = bucketCY + dBucketY;
        if (bX >= 0 && bX < buckets.length && bY >= 0 && bY < buckets[0].length) {
          for (Particle p : buckets[bX][bY]) {
            computeForceSingle(p);
          }
        }
      }
    }
  }
  
  void computeForceSlow() {
    for (Particle p : particles) {
      computeForceSingle(p);
    }
  }

  void update(float dt) {
    vx += fx * dt;
    vy += fy * dt;
    vx *= 0.99;
    vy *= 0.99;
    float px = x;
    float py = y;
    //x += vx * dt;
    //y += vy * dt;
    x += fx * dt;
    y += fy * dt;
    
    // wrapCoordinates();
    boolean wasOutOfBounds = resetOutOfBounds();
    
    float speed = dist(px, py, x, y);
    if (!wasOutOfBounds && speed < 20) {
      color c = lerpColor(#2D728F, #F49E4C, speed / 3);
      stroke(c, 40);
      strokeWeight(6);
      line(px, py, x, y);
      noStroke();
      // fill(c);
      fill(255, 128);
//      float rad = sqrt(2 + speed / 3);
      float rad = 3;
      ellipse(x, y, rad*2, rad*2);
    }

    fx = fy = 0;
  }
  
  boolean resetOutOfBounds() {
    if (x < 0 || x > width || y < 0 || y > height) {
      x = random(width);
      y = random(height);
      vx = vy = 0;
      return true;
    }
    return false;
  }

  void wrapCoordinates() {
    x = ((x % width) + width) % width;
    y = ((y % height) + height) % height;
  }

  void drawEllipse() {
    // ellipse(x, y, 14, 14);
  }
}

final int PX_PER_BUCKET = 40;
List<Particle>[][] buckets;
Particle[] particles = new Particle[500];

void setup() {
  size(800, 800, P2D);
  buckets = new ArrayList[width / PX_PER_BUCKET][height / PX_PER_BUCKET];
  for (int x = 0; x < buckets.length; x++) {
    for (int y = 0; y < buckets[x].length; y++) {
      buckets[x][y] = new ArrayList();
    }
  }
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle(i, random(width), random(height));
  }
  background(255);
}

void clearBuckets() {
  for (int x = 0; x < buckets.length; x++) {
    for (int y = 0; y < buckets[x].length; y++) {
      buckets[x][y].clear();
    }
  }
}

void fillBuckets() {
  for (Particle p : particles) {
    List<Particle> bucket = bucketAt(p.x, p.y);
    bucket.add(p);
  }
}

List<Particle> bucketAt(float x, float y) {
  int bucketX = floor(x / PX_PER_BUCKET);
  int bucketY = floor(y / PX_PER_BUCKET);
  return buckets[bucketX][bucketY];
}

void draw() {
  noStroke();
  fill(12, 6, 19, 155);
  rect(0, 0, width, height);
  //fill(255);
  //stroke(0, 20);
  //stroke(255);
  strokeCap(SQUARE);

  for (int i = 0; i < 5; i++) {
    float dt = mousePressed? 0.02 : 0.02;
    // clearBuckets();
    // fillBuckets();
    
    // sinDistScalar = sqrt(100) / 8 * pow(2, map(sin(t / 100), -1, 1, -3, 3));
    sinDistScalar = pow(2, map(mouseX, 0, width, -5, 5)) / 32 * 1000;
    
    G = pow(map(mouseY, 0, height, 1, 10), 3);
    
    for (Particle p : particles) {
      p.computeForceSlow();
    }
    for (Particle p : particles) {
      p.update(dt);
      // p.draw();
    }
    t += dt;
  }

  for (Particle p : particles) {
    p.drawEllipse();
    // p.draw();
  }


  println(frameRate);
}