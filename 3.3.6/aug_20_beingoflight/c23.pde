Config c23 = new Config(color(6, 5, 2)) {
  
  void init() {
    runners.clear();
    for (int i = 0; i < 2000; i++) {
      runners.add(new Runner(random(width), random(height), 0, 0));
    }
    sdfSolver.set("falloff", 1.0);
  }
  
  void update(Runner r, PImage source) {
    for (int i = 0; i < 3; i++) {
      float x = r.x, y = r.y, vx = r.vx, vy = r.vy, x0 = r.x0, y0 = r.y0;
      float bodyValue = h2(x, y, source);
      float dx = 0, dy = 0;
      v.set(h(x, y, t) - 0.5, h(x, y, t + 10) - 0.5);
      v.mult(4);
      v.rotate(PI * 4 * bodyValue);
      dx += v.x;
      dy += v.y;
      dx += 15 - bodyValue * 15;

      //float ox = x - width/2;
      //float oy = y - height/2;
      //dx += ox * 0.001;
      //dy += oy * 0.001;

      v2.set(
        (h2(x + 1, y, source) - h2(x - 1, y, source)) / 2. * 10, 
        (h2(x, y + 1, source) - h2(x, y - 1, source)) / 2. * 10
        );
      v2.rotate(PI / 2);
      dx += v2.x * 555;
      dy += v2.y * 555;

      dx += vx * 1;
      dy += vy * 1;

      dx += (random(1) - 0.5);
      dy += (random(1) - 0.5);

      stroke(lerpColor(color(164, 59, 41), color(112, 154, 255), bodyValue), 164 + bodyValue * 128);
      vertex(x, y);
      x += dx;
      y += dy;
      int rx = round(x);
      int ry = round(y);
      vertex(x, y);
      if (rx < 0 || rx >= width) {
        x = 0;
        y = y0;
        //x = ((x%width)+width)%width;
      }
      if (ry < 0 || ry >= height) {
        //x = x0;
        //y = y0;
        y = ((y%height)+height)%height;
      }
      if (dist(0, 0, dx, dy) < 5) {
        //x = x0;
        //y = y0;
      }
      
      r.x = x; r.y = y;
    }
  }
};
