Config c27 = new Config(color(5, 9, 2)) {
  void init() {
    runners.clear();
    for (int i = 0; i < 6000; i++) {
      float angle = i * TWO_PI / 1000;
      runners.add(new Runner(random(width), random(height), -cos(angle), -sin(angle)));
    }
    sdfSolver.set("falloff", 1.0);
  }

  void update(Runner r, PImage source) {

    float x = r.x, y = r.y, vx = r.vx, vy = r.vy, x0 = r.x0, y0 = r.y0;

    float dx = 0, dy = 0;

    //v.set(h(x, y, t) - 0.5, h(x, y, t + 10) - 0.5);
    //v.mult(8);
    //dx += v.x;
    //dy += v.y;

//    float ox = x - x0;
//    float oy = y - y0;
//    dx += ox * 0.1;
//    dy += oy * 0.1;

    v2.set(
      (h2(x + 1, y, source) - h2(x - 1, y, source)) / 2. * 10, 
      (h2(x, y + 1, source) - h2(x, y - 1, source)) / 2. * 10
      );
    dx += v2.x * 500;
    dy += v2.y * 500;

    //v2.x += (random(1) - 0.5) * 0.01;
    //v2.y += (random(1) - 0.5) * 0.01;

    //dx += vx * 2;
    //dy += vy * 2;

    //dx += random(1) - 0.5;
    //dy += random(1) - 0.5;

    r.vx += dx;
    r.vy += dy;

    r.vx *= 0.9;
    r.vy *= 0.9;

    x += r.vx;
    y += r.vy;

    boolean reset = false;
    if (x < 0 || x >= width || y < 0 || y >= height) {
      x = x0;
      y = y0;
      r.vx = r.vy = 0;
      reset = true;
    }
    stroke(26, 76, 160);
    if (!reset) {
      vertex(r.x, r.y);
      vertex(x, y);
    }

    r.x = x; 
    r.y = y;
  }

  void draw() {
    calcBodiesTexture();
    calcSourceTexture();
    calcSdfTexture(40);

    background(config.bg);
    //image(source, 0, 0, width, height);
    //image(sdf, 0, 0, width, height);
    sdf.loadPixels();
    beginShape(LINES);
    for (Runner r : runners) {
      r.run(sdf);
    }
    endShape();

    fx.render()
      .bloom(0.5, 20, 30)
      .compose();

    post.set("time", millis() / 1000f);
    post.set("background", (float)red(config.bg) / 255., (float)green(config.bg) / 255., (float)blue(config.bg) / 255.);
    filter(post);
  }
};