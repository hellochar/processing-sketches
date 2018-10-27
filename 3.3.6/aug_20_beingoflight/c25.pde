Config c25 = new Config(color(16, 18, 23)) {
  
  void init() {
    runners.clear();
    for (int i = 0; i < 1000; i++) {
      runners.add(new Runner(random(width), random(height), 0, 0));
    }
    sdfSolver.set("falloff", 10.0);
  }
  
  void update(Runner r, PImage source) {
    float num = 12;
    for (int i = 0; i < num; i++) {
      float x = r.x, y = r.y;

      r.vy += 2.0 / num;
      r.vx += 0.3 / num;

      float bodyValue = h2(x, y, source);
      // reflect vx/vy around v2 vector
      
      v2.set(
        (h2(x + 1, y, source) - h2(x - 1, y, source)) / 2., 
        (h2(x, y + 1, source) - h2(x, y - 1, source)) / 2.
      );
      v2.normalize();
      v2.mult(-1 * dist(0, 0, r.vx, r.vy) * bodyValue); // invert to point away from body
      
      r.vx += v2.x * 10 / num;
      r.vy += v2.y * 10 / num;

      r.vx += (random(1) - 0.5) * 0.2 / num;
      r.vy += (random(1) - 0.5) * 0.2 / num;
      
      r.vx *= 0.99;
      r.vy *= 0.99;

      x += r.vx;
      y += r.vy;
      boolean reset = false;
      if (x < 0 || x >= width) {
        y = 0;
        x = r.x0;
        r.vx = r.vy = 0;
        reset = true;
      }
      if (y < 0 || y >= height) {
        y = 0;
        x = r.x0;
        r.vx = r.vy = 0;
        reset = true;
      }
      stroke(color(45, 65, 120));
      if (!reset) {
        vertex(r.x, r.y);
        vertex(x, y);
      }
      
      r.x = x; r.y = y;
    }
  }
  
  void draw() {
    defaultDraw(true);
  }
};