import KinectPV2.*;

KinectPV2 kinect;

PShader post;

PVector[] pos = new PVector[1000];
PVector[] posOriginal = new PVector[1000];

float goldenRatio = (1 + sqrt(5)) / 2;
void setup() {
  size(800, 600, P2D);
  smooth(8);
  float xR = random(1);
  float yR = random(1);
  for (int i = 0; i < pos.length; i++) {
    pos[i] = new PVector(random(width), random(height));
    //pos[i] = new PVector(xR * width, yR * height);
    //xR = (xR + goldenRatio) % 1;
    yR = (yR + goldenRatio) % 1;
    //pos[i] = new PVector(i * 1f * width / pos.length, 0);
    //pos[i] = new PVector(i * 1f * width / pos.length, yR * 10);
    posOriginal[i] = pos[i].copy();
  }
  //kinect = new KinectPV2(this);
  //kinect.enableBodyTrackImg(true);
  //kinect.init();
  background(0);
  noiseDetail(8);
  noiseSeed(7);
  post = loadShader("post.glsl");
}

float s = 100f;
float h(float x, float y, float t) {
  return noise(x / s, y / s, t);
}

float smoothstep(float t) {
  return t * t * (3 - 2 * t);
}

void draw() {
  //fill(0, 128);
  //noStroke();
  //rect(0, 0, width, height);
  //if (frameCount >= 150) {
  //  exit();
  //}
  float loopT = frameCount / 150f % 1;
  //background(0);
  //PImage body = kinect.getBodyTrackImage();
  //float t = smoothstep(map(cos(loopT * TWO_PI), -1, 1, 0, 1));
  //float t = millis() * 0.001f;
  float t = loopT * 10;
  //float pullCenter = mouseX * 1.0 / width;
  //blendMode(ADD);
  stroke(255, 5);
  beginShape(LINES);
  //for (PVector p : pos) {
  //  p.set(random(width), random(height));
  //}
  for (int z = 0; z < 10; z++) {
    for( int i = 0; i < pos.length; i++) {
      PVector p = pos[i];
      //if (random(1) < 0.01) {
      //  p.set(random(width), random(height));
      //}
      //PVector v = new PVector(
      //  noise(p.x + 0.5, p.y, t) - noise(p.x - 0.5, p.y, t),
      //  noise(p.x, p.y + 0.5, t) - noise(p.x, p.y - 0.5, t)
      //  //noise(-p.y / s - 9.153, p.x / s + 23.14, t + 13) - 0.5
      //);
      //float offsetCenterX = p.x - width/2;
      //float offsetCenterY = p.y - height/2;
      //float od2 = offsetCenterX * offsetCenterX + offsetCenterY * offsetCenterY;
      //float od = sqrt(od2);
      PVector v = new PVector(h(p.x, p.y, t) - 0.5, h(p.x, p.y, t + 10) - 0.5);
      v.mult(20);
      //v.x -= offsetCenterX / od * pullCenter;
      //v.y -= offsetCenterY / od * pullCenter;
      v.y += 1;
      v.mult(1);
      //v.y += (1.0 - p.y / height) * 0.5;
      //v.y += 1;
      vertex(p.x, p.y);
      p.add(v);
      vertex(p.x, p.y);
      //if (v.magSq() < 0.01 * 0.01) {
      //  p.set(random(width), random(height));
      //}
      if (p.x < 0 || p.x > width) {
        //p.x = random(width);
        //p.y = random(height);
        p.set(posOriginal[i]);
      }
      if (p.y < 0 || p.y > height) {
        p.set(posOriginal[i]);
        //p.x = random(width);
        //p.y = random(height);
      }
    }
  }
  endShape();
  //filter(post);
  //fill(255);
  //textAlign(LEFT, TOP);
  //text(t, 0, 0);
  saveFrame("frames6/####.tif");
}