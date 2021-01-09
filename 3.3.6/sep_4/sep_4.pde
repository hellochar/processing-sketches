PGraphics whiteNoise;
PShader lic;
PImage img;
void setup() {
  size(1280, 720, P2D);
  img = loadImage("johannes-plenio-629984-unsplash-small.jpg");
  whiteNoise = createGraphics(width, height, P2D);
  whiteNoise.beginDraw();
  
  //whiteNoise.loadPixels();
  //for (int i = 0; i < whiteNoise.pixels.length; i++) {
  //  float x = i % width;
  //  float y = i / width;
  //  //whiteNoise.pixels[i] = color(noise(x / 100, y / 100) * 255);
  //  whiteNoise.pixels[i] = color(random(255));
  //}
  //whiteNoise.updatePixels();
  
  //whiteNoise.background(0);
  //whiteNoise.strokeWeight(2.5);
  //whiteNoise.colorMode(HSB);
  //whiteNoise.stroke(255);
  //for (int x = 0; x < width; x += 100) {
  //  whiteNoise.line(x, 0, x, height);
  //}
  //for (int y = 0; y < height; y += 100) {
  //  whiteNoise.line(0, y, width, y);
  //}
  //whiteNoise.image(img, 0, 0, width, height);
  whiteNoise.endDraw();
  lic = loadShader("lic.glsl");
}

void draw() {
  lic.set("source", whiteNoise);
  //lic.set("time", (float)mouseX / width + (float)mouseY / height);
  lic.set("time", millis() / 2000f);
  textureWrap(REPEAT);
  filter(lic);
}