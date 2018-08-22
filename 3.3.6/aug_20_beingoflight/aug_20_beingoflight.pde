import processing.video.*;

import KinectPV2.*;
import java.util.*;
import com.hamoid.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

Movie movie;

String filename = "beingoflight13.mp4";

VideoExport videoExport;

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

PostFX fx;
PShader post;

PVector pos;

PImage src;
PGraphics sortedImage;
PShader pixelSortShader;

float t;

float s = 700f;
float h(float x, float y, float t) {
  return noise(x / s, y / s, t);
}

List<Runner> runners = new ArrayList();

class Runner {
  float x, y;
  float x0, y0;
  float vx, vy;
  Runner(float x, float y, float vx) {
    this.x = x;
    this.y = y;
    this.x0 = x;
    this.y0 = y;
    this.vx = vx;
    this.vy = 0;
  }
  void run() {
    vertex(x, y);
    for (int i = 0; i < 50; i++) {
      PVector v = new PVector(h(x, y, t) - 0.5, h(x, y, t + 10) - 0.5);
      x += v.x;
      y += v.y;
      x += vx;
      y += vy;
      int rx = round(x);
      int ry = round(y);
      int index = ry * source.width + rx;
      if (rx < 0 || rx >= width || ry < 0 || ry >= height ||
          red(source.pixels[index]) > 0) {
        vertex(x, y);
        x = x0;
        y = y0;
        vertex(x, y);
      }
    }
    vertex(x, y);
  }
}

void setup() {
  size(1280, 720, P2D);
  
  for (int y = 0; y < height; y++) {
    runners.add(new Runner(0, y, 1));
    runners.add(new Runner(width-1, y, -1));
  }
  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.init();
  bodies = createGraphics(KinectPV2.WIDTHDepth, KinectPV2.HEIGHTDepth, P2D);
  kinectToSourceDrawer = loadShader("kinectToSourceDrawer.glsl");
  erode = loadShader("erode.glsl");
  dilate = loadShader("dilate.glsl");
  
  source = createGraphics(width, height, P2D);
  source.noSmooth();
  edgeHighlighter = loadShader("edgeHighlighter.glsl");
  
  sdf = createGraphics(width, height, P2D);
  sdf.noSmooth();
  sdf.beginDraw();
  sdf.background(0);
  sdf.endDraw();
  sdfSolver = loadShader("sdfSolver.glsl");
  
  videoExport = new VideoExport(this);
  videoExport.setMovieFileName(filename);
  videoExport.startMovie();
  
  fx = new PostFX(this);
  post = loadShader("post.glsl");

  frameRate(30);
  
  pos = new PVector(width/2, height/2);
  movie = new Movie(this, "depthMask.mp4");
  movie.loop();
  
  src = loadImage("johannes-plenio-629984-unsplash-small.jpg");
  sortedImage = createGraphics(width, height, P2D);
  sortedImage.beginDraw();
  sortedImage.image(src, 0, 0);
  sortedImage.endDraw();
  pixelSortShader = loadShader("pixelSort.glsl");
}

//void movieEvent(Movie m) {
//  //m.read();
//}

void draw() {
  float loopT = frameCount / 250f;
  t = loopT; // cos(loopT * PI / 2) * 3;
  movie.read();
  bodies.beginDraw();
  bodies.image(movie, 0, 0);
  //bodies.image(kinect.getBodyTrackImage(), 0, 0);
  bodies.filter(kinectToSourceDrawer);
  bodies.filter(erode);
  bodies.filter(dilate);
  bodies.endDraw();
  //image(bodies, 0, 0);
  
  source.beginDraw();
  source.background(0);
  source.imageMode(CENTER);
  source.image(bodies, width/2, height/2, width, height);
  //source.noFill();
  //source.stroke(255);
  //source.strokeWeight(5);
  //source.rectMode(CENTER);
  //source.rect(width/2, height/2, bodies.width - 2, bodies.height - 2);
  //for (int x = 0; x < width; x += 10) {
  //  source.line(
  //    x, 0,
  //    x, height
  //  );
  //}
  //for (int y = 0; y < height; y += 10) {
  //  source.line(
  //    0, y,
  //    width, y
  //  );
  //}
  source.filter(edgeHighlighter);
  //source.filter(edgeHighlighter);
  //source.filter(edgeHighlighter);
  source.endDraw();
  //image(source, 0, 0);
  //background(0);
  fill(0, 25);
  rect(0, 0, width, height);
  source.loadPixels();
  beginShape(LINES);
  stroke(255);
  for (Runner r : runners) {
    r.run();
  }
  endShape();
  
  //sdfSolver.set("source", source);
  //sdfSolver.set("time", millis() / 1000f);
  //sdf.beginDraw();
  //for (int i = 0; i < 2; i++) {
  //  sdfSolver.set("diags", i % 2 == 0);
  //  sdf.filter(sdfSolver);
  //}
  //sdf.endDraw();
  //image(sdf, 0, 0);
  
  //fx.render()
  //  .bloom(0.5, 20, 30)
  //  .compose();
  //post.set("time", millis() / 1000f);
  //filter(post);
  
  //sortedImage.beginDraw();
  //sortedImage.image(src, 0, 0);
  //pixelSortShader.set("sdf", sdf);
  //for (int i = 0; i < 20*sin(frameCount / 20f) + 20; i++) {
  //  sortedImage.filter(pixelSortShader);
  //}
  //sortedImage.endDraw();
  //image(sortedImage, 0, 0);

  fill(255);
  textAlign(LEFT, TOP);
  text(frameCount, 0, 0);
  
  videoExport.saveFrame();
}

void exit() {
  videoExport.endMovie();
  super.exit();
}