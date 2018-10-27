Config c24 = new Config(color(6, 5, 2)) {
  
  void init() {
    runners.clear();
    for (int i = 0; i < 5000; i++) {
      runners.add(new Runner(random(width), random(height), 0, 0));
    }
    sdfSolver.set("falloff", 4.0);
  }
  
  void update(Runner r, PImage source) {
    for (int i = 0; i < 3; i++) {
      float x = r.x, y = r.y, vx = r.vx, vy = r.vy, x0 = r.x0, y0 = r.y0;
      //float bodyValue = h2(x, y, source);
      float dx = 0, dy = 0;
      //v.set(h(x, y, t) - 0.5, h(x, y, t + 10) - 0.5);
      //v.mult(4);
      //dx += v.x;
      //dy += v.y;
      dy += 2;

      v2.set(
        (h2(x + 1, y, source) - h2(x - 1, y, source)) / 2. * 10, 
        (h2(x, y + 1, source) - h2(x, y - 1, source)) / 2. * 10
        );
      dx += v2.x * 555;
      dy += v2.y * 555;

      dx += (random(1) - 0.5);
      dy += (random(1) - 0.5);

      stroke(color(68, 165, 193));
      vertex(x, y);
      x += dx;
      y += dy;
      vertex(x, y);
      if (x < 0 || x >= width) {
        x = ((x%width)+width)%width;
      }
      if (y < 0 || y >= height) {
        y = 0;
        x = x0;
        //y = ((y%height)+height)%height;
      }
      
      r.x = x; r.y = y;
    }
  }
  
  void draw() {
    defaultDraw(false);
  }
};