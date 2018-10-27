Config c26 = new Config(color(2, 1, 3)) {

  void init() {
    runners.clear();
    for (int i = 0; i < 2000; i++) {
      runners.add(new Runner(random(width), random(height), 0, 0));
    }
    sdfSolver.set("falloff", 5.0);
  }

  void update(Runner r, PImage source) {
    float x = r.x, y = r.y;
    Runner closest = closest(r);
    v.set(closest.x - r.x, closest.y - r.y);
    float rad = v.mag();

    float dx = 0, dy = 0;
    dx -= v.x * 0.01;
    dy -= v.y * 0.01;

    v.set(h(x, y, t) - 0.5, h(x, y, t + 10) - 0.5);
    v.mult(3);
    dx += v.x;
    dy += v.y;

    
    //v2.set(
    //  (h2(x + 1, y, source) - h2(x - 1, y, source)) / 2., 
    //  (h2(x, y + 1, source) - h2(x, y - 1, source)) / 2.
    //  );

    //dx += v2.x * 240;
    //dy += v2.y * 240;

    r.vx += dx * 10;
    r.vy += dy * 10;

    r.vx *= 0.5;
    r.vy *= 0.5;

    x += r.vx;
    y += r.vy;
    if (x < 0 || x >= width) {
      r.vx = 0;
      r.vy = 0;
      x = r.x0;
      y = r.y0;
    }
    if (y < 0 || y >= height) {
      r.vx = 0;
      r.vy = 0;
      y = r.y0;
      x = r.x0;
    }
    
    float bodyValue = h2(x, y, source);
    noStroke();
    fill(255, bodyValue * 255);
    ellipse(x, y, rad, rad);

    r.x = x; 
    r.y = y;
  }

  void draw() {

    calcBodiesTexture();
    background(config.bg);

    calcSourceTexture();
    
    source.beginDraw();
    source.background(0);
    source.imageMode(CENTER);
    source.image(bodies, source.width/2, source.height/2, source.width, source.height);
    source.endDraw();

    calcSdfTexture(10);

    //image(source, 0, 0, width, height);
    //filter(edgeHighlighter);

    sdf.loadPixels();
    for (Runner r : runners) {
      r.run(sdf);
    }

    fx.render()
      .bloom(0.5, 20, 30)
      .compose();

    post.set("time", millis() / 1000f);
    post.set("background", (float)red(config.bg) / 255., (float)green(config.bg) / 255., (float)blue(config.bg) / 255.);
    filter(post);
  }
};