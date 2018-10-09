Config c17 = new Config(color(1, 26, 39)) {
  void init() {
    runners.clear();
    for (int i = 0; i < 1000; i++) {
      float angle = i * TWO_PI / 1000;
      runners.add(new Runner(width/2 + cos(angle) * 350, height/2 + sin(angle) * 350, -cos(angle), -sin(angle)));
    }
    sdfSolver.set("falloff", 1.0);

  }

  void update(Runner r, PImage source) {
    stroke(255);
    for (int i = 0; i < 12; i++) {
      float x = r.x, y = r.y, vx = r.vx, vy = r.vy, x0 = r.x0, y0 = r.y0;

      float dx = 0, dy = 0;
      v.set(h(x, y, t) - 0.5, h(x, y, t + 10) - 0.5);
      v.mult(5);
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
      v2.rotate(PI / 2 * 0.99);
      //v2.x += (random(1) - 0.5) * 0.01;
      //v2.y += (random(1) - 0.5) * 0.01;
      dx += v2.x * 525;
      dy += v2.y * 525;

      dx += vx * 2;
      dy += vy * 2;

      //dx += random(1) - 0.5;
      //dy += random(1) - 0.5;

      x += dx;
      y += dy;
      int rx = round(x);
      int ry = round(y);
      //int index = ry * source.width + rx;
      //    red(source.pixels[index]) > 0) {
      //  vertex(x, y);  
      //  x = x0;
      //  y = y0;
      //  vertex(x, y);
      //}
      vertex(x, y);
      if (rx < 0 || rx >= width || ry < 0 || ry >= height || dist(0, 0, dx, dy) < 3) {
        x = x0;
        y = y0;
      }

      r.x = x; 
      r.y = y;
    }
  }
};
