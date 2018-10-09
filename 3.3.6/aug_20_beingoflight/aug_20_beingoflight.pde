import processing.video.*;

import KinectPV2.*;
import java.util.*;
import com.hamoid.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

PVector v = new PVector();
PVector v2 = new PVector();

KinectPV2 kinect;

// 512x424. Kinect bodies image in source format. 
PGraphics bodies;
// Shader converts:
// KinectPV2 mask img (white = no person, black 0-5 = person id)
// into source format (black = no person, white = person)
PShader kinectToSourceDrawer;
PShader erode;
PShader dilate;

// 1280x720. Black = no person, White = person
PGraphics source;
// Shader converts:
// a filled white body surface
// into white only on the edges
PShader edgeHighlighter;

// 1280x720. Black = outline far away, white = outline closer
PGraphics sdf;
// Shader converts:
// sdf + source image
// into new sdf
PShader sdfSolver;

PShader blur;

PostFX fx;
PShader post;

PVector pos;

PImage src;
PGraphics sortedImage;
PShader pixelSortShader;

float t;

float s = 150f;
float h(float x, float y, float t) {
  return noise(x / s, y / s, t);
}
float h2(float x, float y, PImage src) {
  // downscale to src's width/height
  int rx = round(x / 2);
  int ry = round(y / 2);
  if (rx < 0 || rx >= src.width || ry < 0 || ry >= src.height) {
    return 0;
  } else {
    int index = ry * src.width + rx;
    return red(src.pixels[index]) / 255.0;
  }
}

List<Runner> runners = new ArrayList();
Config config;

class Runner {
  float x, y;
  float x0, y0;
  float vx, vy;
  Runner(float x, float y, float vx, float vy) {
    this.x = x;
    this.y = y;
    this.x0 = x;
    this.y0 = y;
    this.vx = vx;
    this.vy = vy;
  }

  void run(PImage source) {
    config.update(this, source);
  }
}

void setup() {
  size(displayWidth, displayHeight, P2D);
  configs = new Config[] { c16, c17, c20, c22, c23 };
  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.init();
  bodies = createGraphics(KinectPV2.WIDTHDepth, KinectPV2.HEIGHTDepth, P2D);
  kinectToSourceDrawer = loadShader("kinectToSourceDrawer.glsl");
  erode = loadShader("erode.glsl");
  dilate = loadShader("dilate.glsl");

  source = createGraphics(width/2, height/2, P2D);
  source.noSmooth();
  edgeHighlighter = loadShader("edgeHighlighter.glsl");

  sdf = createGraphics(source.width, source.height, P2D);
  sdf.noSmooth();
  sdf.beginDraw();
  sdf.background(0);
  sdf.endDraw();
  sdfSolver = loadShader("sdfSolver.glsl");
  sdfSolver.set("falloff", 1.0);

  blur = loadShader("blur.glsl");

  fx = new PostFX(this);
  post = loadShader("post.glsl");

  pos = new PVector(width/2, height/2);
  setConfig(0);
}

int timeSwitched = 0;
Config[] configs;
int cIndex = 0;

void setConfig(int configIndex) {
  cIndex = configIndex;
  timeSwitched = millis();
  config = configs[cIndex];
  config.init();
}

void mousePressed() {
  setConfig((cIndex + 1) % configs.length);
}

void draw() {
  if( millis() - timeSwitched > 15 * 1000 ) {
    setConfig((cIndex + 1) % configs.length);
  }
  float loopT = frameCount / 100f;
  t = loopT + cos(loopT * PI) * 1; // cos(loopT * PI / 2) * 3;
  bodies.beginDraw();
  bodies.image(kinect.getBodyTrackImage(), 0, 0);
  bodies.filter(kinectToSourceDrawer);
  bodies.filter(erode);
  bodies.filter(dilate);
  bodies.endDraw();

  background(config.bg);

  source.beginDraw();
  source.background(0);
  source.imageMode(CENTER);
  source.image(bodies, source.width/2, source.height/2, source.width, source.height);
  source.filter(edgeHighlighter);
  source.endDraw();
  image(source, 0, 0, width, height);

  sdfSolver.set("source", source);
  sdfSolver.set("time", millis() / 1000f);
  sdf.beginDraw();
  for (int i = 0; i < 40; i++) {
    sdfSolver.set("diags", i % 2 == 0);
    sdf.filter(sdfSolver);
    sdf.filter(blur);
  }
  sdf.endDraw();
  //image(sdf, 0, 0);

  //background(0);
  //fill(0, 25);
  //rect(0, 0, width, height);

  beginShape(LINES);
  sdf.loadPixels();
  for (Runner r : runners) {
    r.run(sdf);
  }
  endShape();

  fx.render()
    .bloom(0.5, 20, 30)
    .compose();
  post.set("time", millis() / 1000f);
  filter(post);

  fill(255);
  textAlign(LEFT, TOP);
  text(frameCount, 0, 0);

  println(frameRate);
  //videoExport.saveFrame();
}

void exit() {
  //videoExport.endMovie();
  super.exit();
}
