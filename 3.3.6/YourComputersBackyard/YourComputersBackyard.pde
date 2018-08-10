
import java.util.*;
import KinectPV2.*;

KinectPV2 kinect;

enum ReasonStopped {
  Expensive, Crowded
};

Leaf leaf;

PShader personShader;
PShader post;

void setup() {
  //  fullScreen();
  //size(2400, 1350, P2D);
  size(1920, 1080, P2D);
  //pixelDensity(1);
  smooth(8);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  
  kinect = new KinectPV2(this);
  kinect.enableBodyTrackImg(true);
  kinect.enableDepthMaskImg(true);
  kinect.init();

  noiseSeed(0);
  useLeafMatrix();
  initLeafSingle();
  personShader = loadShader("personShader.glsl");
  post = loadShader("post.glsl");
}

void initLeafSingle() {
  leaf = new Leaf();
}

float wait = 0;

void draw() {
  background(0);
  PImage depth = kinect.getBodyTrackImage();
  image(depth, 0, 0, width, height);
  filter(personShader);
  useLeafMatrix();

  depth.loadPixels();
  if (leaf == null || leaf.finished) {
    if (wait <= 0) {
      initLeafSingle();
      leaf.depthImage = depth;
      leaf.firstGrow();
      wait = 60;
    } else {
      wait -= 1;
    }
  }
  leaf.depthImage = depth;
  for(int i = 0; i < 2; i++) {
    leaf.expandBoundary();
  }
//  leaf.update();
  leaf.drawWorld();
  
  post.set("time", millis() / 1000f);
  filter(post);

  fill(255);
  textAlign(LEFT, TOP);
  textSize(20);
  text(frameRate, 0, 0);
}

PMatrix2D mat;

void useLeafMatrix() {
  // translate leaf coordinates into screen coordinates
  // leaves are rooted at 0, 0, have their main axis growing towards +x
  // y is lateral "fatness".

  // on the screen we want the leaf to be rooted at width/2, height * 0.9
  // whose main axis growing towards -y

  // this will also affect processing's screenX/screenY which we use while growing the leaf!

  translate(width/2, height * 0.9);
  rotate(-PI / 2);
  scale(6);

  mat = new PMatrix2D();
  mat.translate(width/2, height * 0.9);
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