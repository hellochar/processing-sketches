import processing.video.*;

import KinectPV2.*;
import java.util.*;
import com.hamoid.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

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

PShader warpShader;
PShader gravityShader;

KinectPV2 kinect;

Movie movie;

void setup() {
  //size(1280, 800, P2D);
  fullScreen(P2D);
  textureWrap(REPEAT);
  //pixelDensity(1);
  //kinect = new KinectPV2(this);
  //kinect.enableDepthMaskImg(true);
  //kinect.init();
  
  bodies = createGraphics(KinectPV2.WIDTHDepth, KinectPV2.HEIGHTDepth, P2D);
  kinectToSourceDrawer = loadShader("kinectToSourceDrawer.glsl");
  erode = loadShader("erode.glsl");
  dilate = loadShader("dilate.glsl");
  
  if (kinect == null) {
    movie = new Movie(this, "depthMask.mp4");
    movie.loop();
  }
  //movie.speed(0.5);

  source = createGraphics(width/2, height/2, P2D);
  source.noSmooth();
  edgeHighlighter = loadShader("edgeHighlighter.glsl");

  sdf = createGraphics(source.width, source.height, P2D);
  sdf.noSmooth();
  sdf.beginDraw();
  sdf.background(0);
  sdf.endDraw();
  sdfSolver = loadShader("sdfSolver.glsl");
  sdfSolver.set("falloff", 4.0);

  blur = loadShader("blur.glsl");

  fx = new PostFX(this);
  post = loadShader("post.glsl");
  
  warpShader = loadShader("warp.glsl");
  gravityShader = loadShader("gravityShader.glsl");
  gravityShader.set("iMouse", (float)mouseX, (float)mouseY);
  gravityShader.set("iMouseFactor", (float)1 / 15f);
  gravityShader.set("iResolution", (float)width, (float)height);
  gravityShader.set("G", 10000.0);
  gravityShader.set("gamma", 1.0);
  
  frameRate(30);
  //noCursor();
}

float t;
void draw() {
  float loopT = frameCount / 100f;
  t = loopT; // + cos(loopT * PI) * 1;
  
  movie.read();
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

  source.beginDraw();
  source.background(0);
  source.imageMode(CENTER);
  source.image(bodies, source.width/2, source.height/2, source.width, source.height);
  source.filter(edgeHighlighter);
  source.endDraw();
  //image(source, 0, 0, width, height);

  sdfSolver.set("source", source);
  sdfSolver.set("time", millis() / 1000f);
  sdf.beginDraw();
  for (int i = 0; i < 10; i++) {
    sdfSolver.set("diags", i % 2 == 0);
    sdf.filter(sdfSolver);
    sdf.filter(blur);
  }
  sdf.endDraw();
  image(sdf, 0, 0, width, height);
  
  //gravityShader.set("iMouse", (float)mouseX, (float)mouseY);
  //filter(gravityShader);
  
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

  fill(255);
  textAlign(LEFT, TOP);
  text(frameCount, 0, 0);

  //videoExport.saveFrame();
}

void exit() {
  //videoExport.endMovie();
  super.exit();
}