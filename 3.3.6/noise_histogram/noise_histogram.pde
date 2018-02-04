import java.util.*;

float[] countR, countG, countB;

float DATA_SPACE_EXTENT_X = 1920;
float dataSpaceExtentY;
float aspectRatio;

void setup() {
  size(displayWidth, displayHeight, P2D);
  countR = new float[width*height];
  countG = new float[width*height];
  countB = new float[width*height];
  aspectRatio = (float)width / height; // 1.788888
  dataSpaceExtentY = DATA_SPACE_EXTENT_X / aspectRatio;
}

// [-960, 960]
float dataX(float pixelX) {
  return map(pixelX, 0, width, -DATA_SPACE_EXTENT_X / 2, DATA_SPACE_EXTENT_X / 2);
}

// [-540, 540]
float dataY(float pixelY) {
  return map(pixelY, 0, height, -dataSpaceExtentY / 2, dataSpaceExtentY / 2);
}

float pixelX(float dataX) {
  return map(dataX, -DATA_SPACE_EXTENT_X / 2, DATA_SPACE_EXTENT_X / 2, 0, width);
}

float pixelY(float dataY) {
  return map(dataY, -dataSpaceExtentY / 2, dataSpaceExtentY / 2, 0, height);
}

int frame = 0;
int FRAME_END = 1000;
float secondsPerFrame = 0.02; // evens out to about 6 hours for 1000 frames

//color[] colors = {#212922, #294936, #3D604B, #5B8266, #AEF6C7};
//color[] colors = {#ff0000, #00ff00, #0000ff};
color[] colors = {#063757, #887002, #860209, #884D02};

void draw() {
  frame++;
  //if(frame >= FRAME_END) {
  //  exit();
  //  return;
  //}
  //frame = (int)map(mouseX, 0, width, 0, FRAME_END);
  //tierDist = map(frame, 0, FRAME_END, 300, 600);
  //sharpness = pow(2, map(frame, 0, FRAME_END, 2, 5));
  //float time = 0;
  //float globalScalar = 1;

  float time = map(frame, 0, FRAME_END, 0, 0.14);
  float globalScalar = 1 + sin(map(frame, 0, FRAME_END, 0, TWO_PI)) * 0.01;
  //colorMode(HSB);
  //float hue = 100 + 155 * floor(5.0 * frame / FRAME_END) / 5;
  //color col = color(hue, 255, 255);
  color col = colors[(int)map(frame, 0, FRAME_END, 0, colors.length) % colors.length];
  float startTime = millis();
  int i = 0;
  for (i = 0; millis() - startTime < secondsPerFrame * 1000; i++) {
    float x = dataX(random(0, width));
    float y = dataY(random(0, height));
    walkAndUpdateCounts(x, y, time, globalScalar, col);
  }
  
  // compute a log scalar
  float maxR = max(countR);
  float maxG = max(countG);
  float maxB = max(countB);
  float max = max(maxR, maxG, maxB); 
  print("frame" + frame, "("+i+") ", maxR, maxG, maxB, max, "]");
  
  if (mousePressed) {
    drawNoiseFn(globalScalar, time);
  } else if(keyPressed) {
    drawGammaCounts(max);
  }else {
    drawLogCounts(max);
  }
  if (frame % 100 == 0) {
    saveFrame("foo/####.png");
  }
}

void drawCounts() {
  loadPixels();
  colorMode(RGB);
  for(int i = 0; i < pixels.length; i++) {
    pixels[i] = color(countR[i], countG[i], countB[i]);
  }
  updatePixels();
}

void drawGammaCounts(float max) {
  float gamma = pow(2, map(mouseY, 0, height, -5, 0.25));
  float powScalar = 255 / (pow(max, gamma)) * 1.0;
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    pixels[i] =
      0xff << 24 |
      (int)constrain(powScalar * pow(countR[i], gamma), 0, 255) << 16 |
      (int)constrain(powScalar * pow(countG[i], gamma), 0, 255) << 8 |
      (int)constrain(powScalar * pow(countB[i], gamma), 0, 255);
  }
  updatePixels();
}

void drawLogCounts(float max) {
  // log(the highest value out of the three) * scalar = 255
  // scalar = 255 / log(highest value)
  float logScalar = 255 / log(max) * 1.0;
  println("log scalar: " + logScalar);
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    pixels[i] =
      0xff << 24 |
      (int)constrain(logScalar * log(countR[i]), 0, 255) << 16 |
      (int)constrain(logScalar * log(countG[i]), 0, 255) << 8 |
      (int)constrain(logScalar * log(countB[i]), 0, 255);
  }
  updatePixels();
}

void drawNoiseFn(float globalScalar, float time) {
  colorMode(HSB);
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    float x = dataX(i % width);
    float y = dataY(i / width);
    pixels[i] = color(0, 0, noiseFn(x, y, time, globalScalar) * 255 % 255);
  }
  updatePixels();
}