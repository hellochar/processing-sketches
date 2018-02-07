PShader shader;
PGraphics pg;

void setup() {
  size(800, 600, P3D);
  shader = loadShader("mixitup.glsl");
  shader.set("resolution", width, height);
  pg = createGraphics(width, height, P2D);
  shader.set("lastFrame", pg);
}

void draw() {
  shader.set("mouse", float(mouseX), float(mouseY));
  shader.set("lastFrame", pg);
  pg.beginDraw();
  pg.shader(shader);
  pg.rect(0, 0, width, height);
  pg.endDraw();
  image(pg, 0, 0);
}