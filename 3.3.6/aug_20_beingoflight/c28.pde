Config c28 = new Config(color(210, 230, 241)) {
  void init() {
    runners.clear();
    for (int x = 0; x < width; x += 10) {
      for (int y = 0; y < height; y += 10) {
        runners.add(new Runner(x, y, 0, 0));
      }
    }
    sdfSolver.set("falloff", 1.0);
  }

  void update(Runner r, PImage source) {
    r.x = r.x0;
    r.y = r.y0;
    float x = r.x, y = r.y, vx = r.vx, vy = r.vy, x0 = r.x0, y0 = r.y0;

    float dx = 0, dy = 0;

    v2.set(
      (h2(x + 1, y, source) - h2(x - 1, y, source)) / 2. * 10, 
      (h2(x, y + 1, source) - h2(x, y - 1, source)) / 2. * 10
      );
    
    if (abs(v2.x) > abs(v2.y)) {
      dx += v2.x * 500;
    } else {
      dy += v2.y * 500;
    }

    x += dx;
    y += dy;

    stroke(0);
    strokeWeight(3);
    vertex(r.x, r.y);
    vertex(x, y);

    r.x = x; 
    r.y = y;
  }

  void draw() {
    calcBodiesTexture();
    calcSourceTexture();
    calcSdfTexture(40);

    background(config.bg);

    //image(source, 0, 0, width, height);
    //filter(invert);
    
    //image(sdf, 0, 0, width, height);
    sdf.loadPixels();
    beginShape(LINES);
    for (Runner r : runners) {
      r.run(sdf);
    }
    endShape();

    //fx.render()
    //  .bloom(0.5, 20, 30)
    //  .compose();

    post.set("time", millis() / 1000f);
    //post.set("background", (float)red(config.bg) / 255., (float)green(config.bg) / 255., (float)blue(config.bg) / 255.);
    filter(post);
  }
};