import processing.video.*;

import processing.sound.*;

import KinectPV2.*;
import java.util.*;
import com.hamoid.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

Amplitude ampNode;
AudioIn input;
float amplitude;

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

PShader invert;

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
  int i = 0;
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

Movie movie;

void setup() {
  //size(1280, 720, P2D);
  fullScreen(P2D);
  //pixelDensity(1);
  textureWrap(REPEAT);
  input = new AudioIn(this, 0);
  input.start();
  ampNode = new Amplitude(this);
  ampNode.input(input);

  configs = new Config[] { c16, c165, c17, c20, c22, c23, c24, c25, c26, c27, c28, cg1 };

  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.init();

  if (kinect == null) {
    movie = new Movie(this, "depthMask.mp4");
    movie.loop();
  }

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
  
  invert = loadShader("invert.glsl");

  pos = new PVector(width/2, height/2);
  pushStyle();
  setConfig(0);
  frameRate(30);
  noCursor();
}

int timeSwitched = 0;
Config[] configs;
int cIndex = 0;

void setConfig(int configIndex) {
  popStyle();
  pushStyle();
  cIndex = configIndex;
  timeSwitched = millis();
  config = configs[cIndex];
  config.init();
}

void mousePressed() {
  if (mouseButton == LEFT) {
    setConfig((cIndex + 1) % configs.length);
  } else {
    setConfig(((cIndex - 1) + configs.length) % configs.length);
  }
}

PGraphics calcBodiesTexture() {
  bodies.beginDraw();
  if (kinect != null) {
    bodies.image(kinect.getBodyTrackImage(), 0, 0);
  } else {
    bodies.image(movie, 0, 0);
  }
  bodies.filter(kinectToSourceDrawer);
  bodies.filter(erode);
  bodies.filter(dilate);
  bodies.endDraw();
  return bodies;
}

PGraphics calcSourceTexture() {
  source.beginDraw();
  source.background(0);
  source.imageMode(CENTER);
  source.image(bodies, source.width/2, source.height/2, source.width, source.height);
  source.filter(edgeHighlighter);
  source.endDraw();
  return source;
}

PGraphics calcSdfTexture(int times) {
  sdfSolver.set("source", source);
  sdfSolver.set("time", millis() / 1000f);
  sdf.beginDraw();
  for (int i = 0; i < times; i++) {
    sdfSolver.set("diags", i % 2 == 0);
    sdf.filter(sdfSolver);
    sdf.filter(blur);
  }
  sdf.endDraw();
  return sdf;
}

void updateRunners() {
  beginShape(LINES);
  sdf.loadPixels();
  for (Runner r : runners) {
    r.run(sdf);
  }
  endShape();
}

float CONFIG_DURATION = 25 * 1000;

void draw() {
  amplitude = amplitude * 0.25 + ampNode.analyze() * 0.75;
  float currentDuration = millis() - timeSwitched;
  if ( currentDuration > CONFIG_DURATION ) {
    setConfig((cIndex + 1) % configs.length);
  }
  float loopT = frameCount / 100f;
  t = loopT + cos(loopT * PI) * 1; // cos(loopT * PI / 2) * 3;

  if (movie != null) {
    movie.read();
  }
  post.set("chromaticZoom", map(amplitude, 0, 0.5, 0.8, 0.5));
  config.draw();
  //fill(255);
  //textAlign(LEFT, TOP);
  //text(frameCount, 0, 0);

  println(frameRate);
  //videoExport.saveFrame();

  noStroke();
  fill(17, 191, 180);
  rect(0, 0, map(currentDuration / CONFIG_DURATION, 0, 1, 0, width), 5);

  textAlign(LEFT, TOP);
  fill(255);
  stroke(0);
  text("Experiment " + (cIndex + 1) + " / " + configs.length, 0, 0);
}

void defaultDraw(boolean drawSilhouette) {
  calcBodiesTexture();
  background(config.bg);

  calcSourceTexture();
  if (drawSilhouette) {
    image(source, 0, 0, width, height);
  }

  calcSdfTexture(40);
  //image(sdf, 0, 0, width, height);

  updateRunners();

  fx.render()
    .bloom(0.5, 20, 30)
    .compose();

  post.set("time", millis() / 1000f);
  post.set("background", (float)red(config.bg) / 255., (float)green(config.bg) / 255., (float)blue(config.bg) / 255.);
  filter(post);
}

void exit() {
  //videoExport.endMovie();
  super.exit();
}

Runner closest(Runner r) {
  Runner closest = null;
  for ( Runner r2 : runners ) {
    if (r2 == r) continue;
    if (closest == null) {
      closest = r2;
      continue;
    }
    if ( dist(r.x, r.y, closest.x, closest.y) > dist(r.x, r.y, r2.x, r2.y) ) {
      closest = r2;
    }
  }
  return closest;
}