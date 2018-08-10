// This sketch is an experiment in numerically computing a signed distance field from an arbitrary black/white source image.
// It is used to process e.g. a Kinect user mask such that other code can query "how close am I to the body" and "which 
// direction towards the body" in O(1) time at every pixel.
// 
// This is basically a floodfill from white 

// source image in black and white
PGraphics source;

// sdf in grayscale - 255 is inside; every value v < 255 is distance (255 - v) away from the boundary.
// Stretch: use full 32bit number.
// Stretch: put the boundary in the middle and make every value v > 128 distance (v - 128) away, inside the boundary.
PGraphics sdf;

PShader sdfSolver;

void setup() {
  size(displayWidth, displayHeight, P2D);
  source = createGraphics(width, height, P2D);
  source.noSmooth();

  sdf = createGraphics(width, height, P2D);
  sdf.noSmooth();
  sdf.beginDraw();
  sdf.background(0);
  sdf.endDraw();
  sdfSolver = loadShader("sdfSolver.glsl");
}

void draw() {
  source.beginDraw();
  source.background(0, 0);
  source.colorMode(HSB);
  if (false) {
    source.fill(255);
    source.noStroke();
    source.ellipse(mouseX, mouseY, 5, 5);
  }
  if (true) {
    source.stroke(255);
    source.line(mouseX, mouseY, pmouseX, pmouseY);
  }
  source.endDraw();

  sdfSolver.set("time", millis() / 1000f);
  sdfSolver.set("mouse", float(mouseX) / width, float(mouseY) / height);
  sdfSolver.set("resolution", float(width), float(height));
  sdfSolver.set("source", source);
  sdf.beginDraw();
  for (int i = 0; i < 100; i++) {
    sdfSolver.set("diags", i % 2 == 0);
    sdf.filter(sdfSolver);
  }
  sdf.endDraw();

  // image(source, 0, 0);
  image(sdf, 0, 0);

  fill(0);
  textAlign(LEFT, TOP);
  text(frameRate, 0, 0);
}