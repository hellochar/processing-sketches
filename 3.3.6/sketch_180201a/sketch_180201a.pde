PShader shader;
PGraphics pg;

void setup() {
  size(800, 600, P2D);
  pg = createGraphics(width, height, P2D);
  pg.noSmooth();
  shader = loadShader("fbmHisto.glsl");
  shader.set("resolution", width, height);
}

void draw() {
  //shader.set("time", millis()/1000.0);
  shader.set("mouse", mouseX, mouseY);
  pg.beginDraw();
  pg.background(0);
  pg.shader(shader);
  pg.rect(0, 0, pg.width, pg.height);
  pg.endDraw();
  image(pg, 0, 0);
}