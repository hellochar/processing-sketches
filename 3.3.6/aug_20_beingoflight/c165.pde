Config c165 = new Config(color(4, 3, 2)) {
  void init() {
    runners.clear();
    for (int i = 0; i < 1000; i++) {
      float angle = i * TWO_PI / 1000;
      runners.add(new Runner(width/2 + cos(angle) * 50, height/2 + sin(angle) * 50, -cos(angle), -sin(angle)));
    }
    sdfSolver.set("falloff", 1.0);

  }

  void update(Runner r, PImage source) {
    float f = (millis() / 6000f) % 1 < 0.5 ? 1 : -1;
    
    color orange = color(154, 67, 34);
    color blue = color(34, 67, 154);
    stroke(lerpColor(blue, orange, map(f, -1, 1, 0, 1)));
    strokeWeight(2);
    
    for (int i = 0; i < 2; i++) {
      float x = r.x, y = r.y, vx = r.vx, vy = r.vy, x0 = r.x0, y0 = r.y0;

      float dx = 0, dy = 0;
      v.set(h(x, y, t) - 0.5, h(x, y, t + 10) - 0.5);
      v.mult(28);
      dx += v.x;
      dy += v.y;

      //float ox = x - width/2;
      //float oy = y - height/2;
      //dx += ox * 0.001;
      //dy += oy * 0.001;

      v2.set(
        (h2(x + 1, y, source) - h2(x - 1, y, source)) / 2. * 10, 
        (h2(x, y + 1, source) - h2(x, y - 1, source)) / 2. * 10
        );
      //v2.x += (random(1) - 0.5) * 0.01;
      //v2.y += (random(1) - 0.5) * 0.01;
      dx += v2.x * 525 * f;
      dy += v2.y * 525 * f;

      dx += vx * 6;
      dy += vy * 6;

      //dx += random(1) - 0.5;
      //dy += random(1) - 0.5;

      vertex(x, y);
      x += dx;
      y += dy;
      vertex(x, y);
      if (x < 0 || x >= width || y < 0 || y >= height) {
        x = x0;
        y = y0;
      }

      r.x = x; 
      r.y = y;
    }
  }
};