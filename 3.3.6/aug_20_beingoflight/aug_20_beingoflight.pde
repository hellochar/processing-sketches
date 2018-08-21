import KinectPV2.*;
import java.util.*;
import com.hamoid.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

String filename = "6.mp4";

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

void setup() {
  size(1280, 720, P2D);
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
}

void draw() {
  bodies.beginDraw();
  bodies.image(kinect.getBodyTrackImage(), 0, 0);
  bodies.filter(kinectToSourceDrawer);
  bodies.filter(erode);
  bodies.filter(dilate);
  bodies.endDraw();
  //image(bodies, 0, 0);
  
  source.beginDraw();
  source.background(0);
  source.imageMode(CENTER);
  source.image(bodies, width/2, height/2);
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
  image(source, 0, 0);
  //println(brightness(source.get(mouseX, mouseY)));
  
  sdfSolver.set("source", source);
  sdf.beginDraw();
  for (int i = 0; i < 40; i++) {
    sdfSolver.set("diags", i % 2 == 0);
    sdf.filter(sdfSolver);
  }
  sdf.endDraw();
  image(sdf, 0, 0);
  
  fx.render()
    .bloom(0.5, 20, 30)
    .compose();
  post.set("time", millis() / 1000f);
  filter(post);

  fill(255);
  textAlign(LEFT, TOP);
  text(frameCount, 0, 0);
  
  videoExport.saveFrame();
}

void exit() {
  videoExport.endMovie();
  super.exit();
}