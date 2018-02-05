import java.util.*;

float[] countR, countG, countB;

float DATA_SPACE_EXTENT_X = 1920;
float dataSpaceExtentY;
float aspectRatio; 

int frame = 0;
int FRAME_END = 5 * 30;
float secondsPerFrame = 30;

void setup() {
  size(1920, 1080, P2D);
  countR = new float[width*height];
  countG = new float[width*height];
  countB = new float[width*height];
  aspectRatio = (float)width / height; // 1.788888
  dataSpaceExtentY = DATA_SPACE_EXTENT_X / aspectRatio;
  reset();
}

void reset() {
  frame = 0;
  loadRandomColourLoversPalette();
  randomizeParameters();
  println(name);
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

void draw() {
  float globalScalar = 1 + sin(map(frame, 0, FRAME_END, 0, TWO_PI)) * 0.03;
  Arrays.fill(countR, 0);
  Arrays.fill(countG, 0);
  Arrays.fill(countB, 0);
  //frame = (int)map(mouseX, 0, width, 0, FRAME_END);
  for (int colorIndex = 0; colorIndex < colors.length; colorIndex++) {
    color col = colors[colorIndex];
    float startTime = millis();
    float colorAngle = PI * (colorIndex + 0.2) / colors.length;
    float directionalBiasX = cos(colorAngle);
    float directionalBiasY = sin(colorAngle);
    for (int i = 0; millis() - startTime < secondsPerFrame * 1000 / colors.length; i++) {
      float incrementalFrame = frame + (float)colorIndex / colors.length;
      float normalizedFrame = (incrementalFrame) / FRAME_END;
      float smoothedFrame = bezierPoint(0, 0, 1, 1, normalizedFrame); 
      float biasMagnitude = lerp(0.1, 0.75, smoothedFrame);
      float time = lerp(0, 0.84, smoothedFrame);
      
      float x = dataX(random(0, width));
      float y = dataY(random(0, height));
      walkAndUpdateCounts(x, y, time, globalScalar, directionalBiasX * biasMagnitude, directionalBiasY * biasMagnitude, col);
    }
  }
  
  // compute a log scalar
  float maxR = max(countR);
  float maxG = max(countG);
  float maxB = max(countB);
  float max = max(maxR, maxG, maxB); 
  drawLogCounts(max);
  //drawGammaCounts(max);
  frame++;
  println(" frame", frame, "(", maxR, maxG, maxB, ")");  
  saveFrame(name + "/" + nf(frame, 4) + ".png"); //<>//
  if(frame >= FRAME_END) {
    reset();
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
  float gamma = 0.1;
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
  print("logScalar: " + logScalar);
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