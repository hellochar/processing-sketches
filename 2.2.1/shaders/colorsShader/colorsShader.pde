PGraphics colorsGraphics;
PShader colorsShader;

void setup() {
  size(400, 400, P2D);
  colorsGraphics = createGraphics(width, height, P2D);
  colorsGraphics.noSmooth();
  colorsShader = loadShader("colors.frag");
}

void draw() {
  iterateColors();
  image(colorsGraphics, 0, 0, width, height);
}

void iterateColors() {
  colorsShader.set("time", millis() * 1.0f);
  
  colorsGraphics.beginDraw();
  colorsGraphics.background(0);
  colorsGraphics.shader(colorsShader);
  colorsGraphics.rect(0, 0, colorsGraphics.width, colorsGraphics.height);
  colorsGraphics.endDraw();
}
