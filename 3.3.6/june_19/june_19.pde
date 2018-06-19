PGraphics img; //<>//

void setup() {
  size(1920, 600, P2D);
  img = createGraphics(width, height, P2D);
  img.beginDraw();
  img.background(255);
  img.endDraw();
  followers = new Follower[400];
  for (float i = 0; i < followers.length; i++) {
    float lx = pow(0.02 + (i + 1) / followers.length / 10, 2);
    float ly = pow(0.02 + (i + 1) / followers.length / 10, 2);
    followers[(int)i] = new Follower(lx, ly);
  }
}

Follower[] followers;

void draw() {
  img.beginDraw();
  for (Follower f : followers) {
    f.draw();
  }
  img.endDraw();
  image(img, 0, 0);
  
  for (Follower f : followers) {
    float rad = f.radius();
    ellipse(f.x, f.y, rad, rad);
  }
}

class Follower {
  float x = 400;
  float y = 300;

  float dx;
  float dy;
  
  float lerpX = 0.25;
  float lerpY = 0.25;
  
  float opacity = 0;

  Follower(float lx, float ly) {
    lerpX = lx;
    lerpY = ly;
  }
  
  float radius() {
    return 1 + dist(0, 0, dx, dy);
  }

  void draw() {
    float ox = x;
    float oy = y;

    float tX = mouseX;
    float tY = mouseY;
    if (tY > height) {
      tY = height + (height - tY);
    } 
    float wantedDx = -(x - tX);
    float wantedDy = -(y - tY);
    
    if (keyPressed) {
      dx = lerp(dx, wantedDx, lerp(lerpX, 1, 0.2));
      dy = lerp(dy, wantedDy, lerp(lerpY, 1, 0.2));
    } else {
      dx = lerp(dx, wantedDx, lerpX);
      dy = lerp(dy, wantedDy, lerpY);
    }
    avoid();
    float len = dist(0, 0, dx, dy);
    if (len > 12) {
      dx = dx / len * 12;
      dy = dy / len * 12;
    }
    dx *= 0.98;
    dy *= 0.98;
    x += dx;
    y += dy;

    x = constrain(x, 0, width);
    if (x == 0 || x == width) dx *= -1;
    y = constrain(y, 0, height);
    if (y == 0 || y == height) dy *= -1;

    img.strokeWeight(this.radius());
    // img.strokeCap(PROJECT);
    if (mousePressed) {
      opacity = lerp(opacity, 9, 0.1);
    } else {
      opacity = lerp(opacity, 0, 0.1);
    }
    img.stroke(0, opacity);
    img.noFill();
    img.line(ox, oy, x, y);
  }
  
  void avoid() {
    float ax = 0, ay = 0;
    for (Follower f : followers) {
      float ox = f.x - x;
      float oy = f.y - y;
      float d2 = ox*ox + oy*oy;
      if (d2 > 0) {
        ax += -0.2 * ox / d2;
        ay += -0.2 * oy / d2;
      }
    }
    if (abs(ax) < 100) {
      dx += ax;
    }
    if (abs(ay) < 100) {
      dy += ay;
    }
  }
}