import KinectPV2.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

PostFX fx;

KinectPV2 kinect;

PShader post;

PVector[] pos; // = new PVector[10000];
PVector[] posOriginal; // = new PVector[10000];
PVector[] posForce;
PGraphics trace;

float goldenRatio = (1 + sqrt(5)) / 2;
void setup() {
  size(800, 600, P2D);
  trace = createGraphics(width, height, P2D);  
  trace.smooth(8);
  fx = new PostFX(this);
  float xR = random(1);
  float yR = random(1);
  int gridSize = 1;
  pos = new PVector[(width * height) / (gridSize * gridSize)];
  posOriginal = new PVector[pos.length];
  posForce = new PVector[pos.length];
  for (int i = 0; i < pos.length; i++) {
    float a = TWO_PI * i / pos.length;
    float forceA = a;
    if (i % 2 == 0) forceA += PI;
    posForce[i] = new PVector(cos(forceA), sin(forceA));
    //pos[i] = new PVector((i % (width / gridSize)) * gridSize, (i / (width / gridSize)) * gridSize);
    //pos[i] = new PVector(width/2 + cos(a), height/2 + sin(a));
    pos[i] = new PVector(random(width), random(height));
    //pos[i] = new PVector(xR * width, yR * height);
    xR = (xR + goldenRatio) % 1;
    yR = (yR + goldenRatio) % 1;
    //pos[i] = new PVector(width/2 + cos(a) * width * 0.2, height/2 + sin(a) * width * 0.2);
    //pos[i] = new PVector(i * 1f * width / pos.length, height/2);
    //pos[i] = new PVector(i * 1f * width / pos.length, yR * 10);
    posOriginal[i] = pos[i].copy();
  }
  kinect = new KinectPV2(this);
  kinect.enableBodyTrackImg(true);
  kinect.init();
  trace.beginDraw();
  trace.background(0, 0);
  trace.endDraw();
  noiseDetail(8);
  noiseSeed(18);
  post = loadShader("post.glsl");
}

float s = 700f;
float h(float x, float y, float t) {
  return noise(x / s, y / s, t);
}

float smoothstep(float x, float min, float max) {
  float t = constrain( (x - min) / (max - min), 0, 1);
  return t * t * (3 - 2 * t);
}

// sigmoid is ~1 at x < c-k, ~0 at x > c+k, and decreases in a sigmoid pattern in the middle 
float sigmoid(float x, float c, float k) {
  return (float)Math.tanh((-x + c) * PI / k) * 0.5 + 0.5;
}

void draw() {
  //fill(0, 128);
  //noStroke();
  //rect(0, 0, width, height);
  if (frameCount >= 250) {
    exit();
  }
  float loopT = frameCount / 250f % 1;
  background(color(1, 26, 39));
  //background(color(4, 7, 8));
  PImage body = kinect.getBodyTrackImage();
  //float t = smoothstep(map(cos(loopT * TWO_PI), -1, 1, 0, 1));
  //float t = millis() * 0.001f;
  float t = cos(loopT * PI / 2) * 1;
  //float t = loopT;
  //float pullCenter = 1 - 4 * loopT * (1 - loopT);
  //float pullCenter = 1.0 * mouseX / width;
  float velScalar = min(sigmoid(loopT, 0.9, 0.1), sigmoid(1-loopT, 0.9, 0.1));
  //blendMode(ADD);
  //stroke(255, 26);
  //beginShape(LINES);
  //for (PVector p : pos) {
  //  p.set(random(width), random(height));
  //}
  trace.beginDraw();
  trace.background(0, 0);
  for(int i = 0; i < pos.length; i++) {
    PVector p = pos[i];
    //p.set(random(width), random(height));
    //p.set(posOriginal[i]);
    //p.set(width/2, height/2);
    //p.lerp(new PVector(width/2, height/2), pullCenter);
    for (int z = 0; z < 10; z++) {
      //if (random(1) < 0.01) {
      //  p.set(random(width), random(height));
      //}
      //PVector v = new PVector(
      //  noise(p.x + 0.5, p.y, t) - noise(p.x - 0.5, p.y, t),
      //  noise(p.x, p.y + 0.5, t) - noise(p.x, p.y - 0.5, t)
      //  //noise(-p.y / s - 9.153, p.x / s + 23.14, t + 13) - 0.5
      //);
      //float offsetCenterX = posOriginal[i].x - width/2;
      //float offsetCenterY = posOriginal[i].y - height/2;
      //float od2 = offsetCenterX * offsetCenterX + offsetCenterY * offsetCenterY;
      //float od = sqrt(od2);
      
      float d = dist(p.x, p.y, width/2, height/2);
      
      //boolean insideCenter = d < width * 2f / 8;
       float insideCenterAmount = sigmoid(d, width * 0.25, width * 0.3);
      //float insideCenterAmount = 1;
      
      PVector v = new PVector(h(p.x, p.y, t) - 0.5, h(p.x, p.y, t + 10) - 0.5);
      PVector v2 = new PVector(h(p.x * 3, p.y * 3, t) - 0.5, h(p.x * 3, p.y * 3, t + 10) - 0.5);
      v.lerp(v2, insideCenterAmount);
      //float l = v.magSq() / (0.1 * 0.1);
      //v.normalize();

      v.mult(10);
      //v.mult(map(insideCenterAmount, 1, 0, 1, -1));
      //v.y += 1;
      //v.x += offsetCenterX / od * 2;
      //v.y += offsetCenterY / od * 2;
      v.x += posForce[i].x * 1;
      v.y += posForce[i].y * 1;
      v.mult(0.8);
      v.mult(velScalar);
      
      //v.mult(insideCenterAmount);
      
      //v.x += (posOriginal[i].x - width/2) * pullCenter;
      //v.y += (posOriginal[i].y - height/2) * pullCenter;
      //v.x -= offsetCenterX / od * pullCenter;
      //v.y -= offsetCenterY / od * pullCenter;
      
      v.rotate(PI/2 * insideCenterAmount);
      float outOfFocusAmount = abs(d) / (height/2) * 2;
      float size = 1 * (1 + outOfFocusAmount);
      trace.strokeWeight(size);
      float opacityScalar = 1 / pow(1 + outOfFocusAmount, 2);
      float opacity = max(3, 12 * opacityScalar);
      trace.stroke(lerpColor(color(255, 128, 12), color(12, 182, 255), insideCenterAmount), opacity);
      //v.y += (1.0 - p.y / height) * 0.5;
      //v.y += 1;
      //vertex(p.x, p.y);
      trace.line(p.x, p.y, p.x + v.x, p.y + v.y);
      p.add(v);
      //vertex(p.x, p.y);
      if (v.magSq() < 0.01 * 0.01) {
        //break;
         //p.set(random(width), random(height));
        p.set(posOriginal[i]);
      }
      if (p.x < 0 || p.x > width) {
        //break;
        //p.x = random(width);
        p.x = posOriginal[i].x;
        //p.y = random(height);
        //p.set(posOriginal[i]);
      }
      if (p.y < 0 || p.y > height) {
        //break;
        //p.set(posOriginal[i]);
        //p.x = random(width);
        //p.y = random(height);
        p.y = posOriginal[i].y;
      }
    }
  }
  trace.endDraw();
  //endShape();
  
  image(trace, 0, 0);
  fx.render()
    .bloom(0.5, 20, 30)
    .compose();

  post.set("time", millis() / 1000f);
  filter(post);
  fill(255);
  textAlign(LEFT, TOP);
  //text(frameCount, 0, 0);
  text(velScalar, 0, 0);
  saveFrame("frames23/####.tif");
}