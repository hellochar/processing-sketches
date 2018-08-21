import KinectPV2.*;
import java.util.*;
import com.hamoid.*;

VideoExport videoExport;

KinectPV2 kinect;

PGraphics source;
PShader drawPerson;

PGraphics sdf;
PShader sdfSolver;

PShader erode;
PShader dilate;

void setup() {
  size(1280, 720, P2D);
  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.init();
  source = createGraphics(width, height, P2D);
  source.noSmooth();
  drawPerson = loadShader("personShader.glsl");
  
  sdf = createGraphics(width, height, P2D);
  sdf.noSmooth();
  sdf.beginDraw();
  sdf.background(0);
  sdf.endDraw();
  sdfSolver = loadShader("sdfSolver.glsl");

  erode = loadShader("erode.glsl");
  dilate = loadShader("dilate.glsl");
  
  videoExport = new VideoExport(this);
  videoExport.startMovie();
  
  frameRate(30);
}

void draw() {
  source.beginDraw();
  source.background(0);
  source.imageMode(CENTER);
  //source.shader(drawPerson);
  source.image(kinect.getBodyTrackImage(), width/2, height/2);
  source.filter(erode);
  source.filter(dilate);
  source.filter(drawPerson);
  source.endDraw();
  image(source, 0, 0);
  
  //sdfSolver.set("source", source);
  //sdf.beginDraw();
  //for (int i = 0; i < 100; i++) {
  //  sdfSolver.set("diags", i % 2 == 0);
  //  sdf.filter(sdfSolver);
  //}
  //sdf.endDraw();
  //image(sdf, 0, 0);
  
  fill(0);
  textAlign(CENTER, BOTTOM);
  text(frameRate, width/2, height);

  videoExport.saveFrame();
}

void exit() {
  videoExport.endMovie();
  super.exit();
}