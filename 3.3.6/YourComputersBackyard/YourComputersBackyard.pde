import processing.video.*;

import java.util.*;
import KinectPV2.*;

color branchStartColor = #2B6A26;
color branchEndColor = #A7FAA2;

color leafColor = #EA351C;

KinectPV2 kinect;

enum ReasonStopped {
  Expensive, Crowded
};

Leaf leaf;

PShader personShader;
PShader post;

PImage depthImage;

Movie movie;

void setup() {
  fullScreen(P2D);
  //size(2400, 1350, P2D);
  //size(1920, 1080, P2D);
  //pixelDensity(1);
  //smooth(3);
  noCursor();
  strokeCap(ROUND);
  strokeJoin(ROUND);
  
  //kinect = new KinectPV2(this);
  //kinect.enableBodyTrackImg(true);
  //kinect.enableDepthMaskImg(true);
  //kinect.init();

  noiseSeed(0);
  useLeafMatrix();
  initLeafSingle();
  personShader = loadShader("personShader.glsl");
  post = loadShader("post.glsl");
  
  movie = new Movie(this, "depthMask.mp4");
  movie.loop();
  //movie.speed(0.5);
}

void initLeafSingle() {
  leaf = new Leaf();
}

float wait = 0;

void draw() {
  //background(255);
  if (movie != null) {
    movie.read();
    depthImage = movie;
  } else if (kinect != null) {
    depthImage = kinect.getBodyTrackImage();
  } else {
    throw new Error("bad");
  }
  image(depthImage, 0, 0, width, height);
  filter(personShader);
  useLeafMatrix();

  depthImage.loadPixels();
  if (leaf == null || leaf.finished) {
    if (wait <= 0) {
      initLeafSingle();
      leaf.firstGrow();
      wait = 60;
    } else {
      wait -= 1;
    }
  }
  //for(int i = 0; i < 2; i++) {
  if (frameCount % 2 == 0) {
    leaf.expandBoundary();
  }
  //}
//  leaf.update();
  leaf.drawWorld();
  
  post.set("time", millis() / 1000f);
  filter(post);

  resetMatrix();
  fill(255);
  textAlign(LEFT, TOP);
  textSize(20);
  //text(frameRate, 0, 0);
}

PMatrix2D mat;

void useLeafMatrix() {
  // translate leaf coordinates into screen coordinates
  // leaves are rooted at 0, 0, have their main axis growing towards +x
  // y is lateral "fatness".

  // on the screen we want the leaf to be rooted at width/2, height * 0.9
  // whose main axis growing towards -y

  // this will also affect processing's screenX/screenY which we use while growing the leaf!

  translate(width/2, height * 0.85);
  rotate(-PI / 2);
  scale(6);

  mat = new PMatrix2D();
  mat.translate(width/2, height * 0.85);
  mat.rotate(-PI / 2);
  mat.scale(6);
}

float leafToScreenX(float x, float y) {
  return mat.multX(x, y);
}

float leafToScreenY(float x, float y) {
  return mat.multY(x, y);
}

void keyPressed() {
}