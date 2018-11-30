Config c22 = new Config(color(1, 3, 2)) {
  void init() {
    runners.clear();
    for (int i = 0; i < 4000; i++) {
      runners.add(new Runner(random(width), random(height), 0, 0));
    }
    sdfSolver.set("falloff", 5.0);

  }

  void update(Runner r, PImage source) {
    r.x = r.x0;
    r.y = r.y0;
    for (int i = 0; i < 5; i++) {
      float x = r.x, y = r.y, vx = r.vx, vy = r.vy, x0 = r.x0, y0 = r.y0;
      float bodyValue = h2(x, y, source);
      float dx = 0, dy = 0;
      v.set(h(x, y, t) - 0.5, h(x, y, t + 10) - 0.5);
      v.mult(bodyValue * 255);
      dx += v.x;
      dy += v.y;
      
      //float ox = x - width/2;
      //float oy = y - height/2;
      //dx += ox * 0.001;
      //dy += oy * 0.001;
      
      //PVector v2 = new PVector(
      //  (h2(x + 1, y, source) - h2(x - 1, y, source)) / 2. * 10,
      //  (h2(x, y + 1, source) - h2(x, y - 1, source)) / 2. * 10
      //);
      //v2.rotate(PI);
      //v2.x += (random(1) - 0.5) * 0.01;
      //v2.y += (random(1) - 0.5) * 0.01;
      //dx += v2.x * 155;
      //dy += v2.y * 155;
      
      dx += vx * 1;
      dy += vy * 1;
      
      dx += (random(1) - 0.5);
      dy += (random(1) - 0.5);

      stroke(lerpColor(color(0, 128, 255), color(255, 255, 220), (dx*dx+dy*dy) / 15), dist(0, 0, dx, dy) * 10);
      vertex(x, y);
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
      if (rx < 0 || rx >= width || ry < 0 || ry >= height) {
        x = x0;
        y = y0;
      }
      
      r.x = x; r.y = y;
    }
  }
};