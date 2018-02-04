import java.util.*;

float[] countR, countG, countB;

float DATA_SPACE_EXTENT_X = 1920;
float dataSpaceExtentY;
float aspectRatio;

void setup() {
  size(600, 600, P2D);
  countR = new float[width*height];
  countG = new float[width*height];
  countB = new float[width*height];
  aspectRatio = (float)width / height; // 1.788888
  dataSpaceExtentY = DATA_SPACE_EXTENT_X / aspectRatio;
  background(0);
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

color[] colors = {#ff0000, #ff0000, #FFFF00, #054EF5};
//color[] colors = {#063757, #887002, #860209, #884D02};
//color[] colors = {#E3862D, #6F2598, #CBDF2C};

float frame = 0;
int FRAME_END = colors.length;
float secondsPerFrame = 10; // evens out to about 6 hours for 1000 frames

void draw() {
  //Arrays.fill(countR, 0);
  //Arrays.fill(countG, 0);
  //Arrays.fill(countB, 0);
  blendMode(BLEND);
  noStroke();
  fill(0);
  rect(0, 0, width, height);
  blendMode(ADD);
  //for (frame = 0; frame < FRAME_END; frame++) {
    //frame = (int)map(mouseX, 0, width, 0, FRAME_END);
    //tierDist = map(frame, 0, FRAME_END, 300, 600);
    //sharpness = pow(2, map(frame, 0, FRAME_END, 2, 5));
    //float time = 0;
    //float globalScalar = 1;
  frame = map(cos(map(frameCount, 0, 5 * 60, 0, TWO_PI)), 1, -1, 0, FRAME_END);
  //if (frameCount % (5*30) == 0) background(0);
  
    noiseFactorWeight = map(frame, 0, FRAME_END, 1, 0);
    float time = map(frame, 0, FRAME_END, 0, 0.03);
    float globalScalar = 0.1 + sin(map(frame, 0, FRAME_END, 0, PI / 2));
    color col = colors[(int)map(frame, 0, FRAME_END, 0, colors.length) % colors.length];
    float startTime = millis();
    int i = 0;
    for (i = 0; millis() - startTime < secondsPerFrame * 1000; i++) {
      float x = dataX(random(0, width));
      float y = dataY(random(0, height));
      walkAndUpdateCounts(x, y, time + i / 1000000.0f, globalScalar, colors[i % colors.length]);
    }
    print("frame" + frame, "("+i+")" );
  //}
  
  // compute a log scalar
  //float maxR = max(countR);
  //float maxG = max(countG);
  //float maxB = max(countB);
  //float max = max(maxR, maxG, maxB);
  //print("[" + maxR, maxG, maxB, max + "]");
  //drawLogCounts(max);
  saveFrame("gif/####.png");
  if (frameCount > 5 * 60) { exit(); }
  //frame++;
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
  //float logScalar = 255 / log(max) * 1.0;
  //println("log scalar: " + logScalar);
  float logScalar = 25;
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