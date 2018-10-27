Config cg1 = new Config(color(6, 5, 2)) {
  PShader warpShader;
  
  void init() {
    if (warpShader == null) {
      warpShader = loadShader("warp.glsl");
    }
    runners.clear();
    sdfSolver.set("falloff", 4.0);
  }
  
  void update(Runner r, PImage source) {
  }
  
  void draw() {
    calcBodiesTexture();
    calcSourceTexture();
    calcSdfTexture(10);
    image(sdf, 0, 0, width, height);

    fx.render()
      .bloom(0.5, 20, 30)
      .sobel()
      .compose();
  
    //warpShader.set("u_mouse", (float)mouseX / width, (float)mouseY / height);
    warpShader.set("u_mouse",
      map(sin(t * PI / 3), -1, 1, 0.2, 0.9),
      map(sin(t * 0.74), -1, 1, 0.05, 0.45)
    );
    //warpShader.set("u_mouse", 0.75, 0.8);
    warpShader.set("u_time", millis() / 1000f);
    filter(warpShader);  
  
    post.set("time", millis() / 1000f);
    post.set("background", 2 / 255., 4 / 255., 5 / 255.);
    filter(post);
  }
};