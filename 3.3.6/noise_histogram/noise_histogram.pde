import java.util.*;

float[] countR, countG, countB;

float DATA_SPACE_EXTENT_X = 1920;
float dataSpaceExtentY;
float aspectRatio; 

int frame = 0;
int FRAME_END = 5 * 30;
float secondsPerFrame = 30;

PShader logDrawer;

void setup() {
  size(displayWidth, displayHeight, P2D);
  //randomSeed(0);
  countR = new float[width*height];
  countG = new float[width*height];
  countB = new float[width*height];
  aspectRatio = (float)width / height; // 1.788888
  dataSpaceExtentY = DATA_SPACE_EXTENT_X / aspectRatio;
  noiseDetail(16, 0.5);
  reset();
  logDrawer = loadShader("logDrawer.glsl");
}

void reset() {
  frame = 0;
  Arrays.fill(countR, 0);
  Arrays.fill(countG, 0);
  Arrays.fill(countB, 0);
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

void keyPressed() {
  if (key == 'r') {
    reset();
  }
}

void draw() {
  float globalScalar = 1 + sin(map(frame, 0, FRAME_END, 0, TWO_PI)) * 0.01;
  Arrays.fill(countR, 0);
  Arrays.fill(countG, 0);
  Arrays.fill(countB, 0);
  //frame = 1;
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
      float smoothedFrame = sin(normalizedFrame*PI); 
      float biasMagnitude = 0.5;
      float time = lerp(2, 3, smoothedFrame);
      
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
  //drawNoiseFn(globalScalar, 0);
  //drawNoiseGradient(globalScalar, 0);
  //drawLinearSumCounts(max);
  //drawLogCounts(max);
  drawExpCounts(max);
  println(" frame", frame, "(", maxR, maxG, maxB, ")");  
  saveFrame(name + "/" + nf(frame, 4) + ".png"); //<>//
  frame++;
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

void drawExpCounts(float max) {
  float expCountExponent = 0.33;
  float powScalar = 255 / (pow(max, expCountExponent)) * 1.0;
  print("powScalar:", powScalar);
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    pixels[i] =
      0xff << 24 |
      (int)constrain(powScalar * pow(countR[i], expCountExponent), 0, 255) << 16 |
      (int)constrain(powScalar * pow(countG[i], expCountExponent), 0, 255) << 8 |
      (int)constrain(powScalar * pow(countB[i], expCountExponent), 0, 255);
  }
  updatePixels();
}

void drawLinearSumCounts(float max) {
  colorMode(RGB);
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    // each of these is in the range [0..max]
    float r = log(countR[i]);
    float g = log(countG[i]);
    float b = log(countB[i]);
    float thisMax = lerp(max(r, g, b), log(max), (float)mouseX / width);

    pixels[i] = color(r / thisMax * 255, g / thisMax * 255, b / thisMax * 255);
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
    float value = noiseFn(x, y, time, globalScalar); // should be strictly between 0 and 1
    float saturation = value > 255 ? 255 : 0;
    pixels[i] = color(40, saturation, value * 255);
  }
  updatePixels();
}

void drawNoiseGradient(float s, float t) {
  colorMode(HSB);
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    float x = dataX(i % width);
    float y = dataY(i / width);
    
    float noiseUp = noiseFn(x, y - neighborOffset, t, s);
    float noiseLeft = noiseFn(x - neighborOffset, y, t, s);
    float noiseRight = noiseFn(x + neighborOffset, y, t, s);
    float noiseDown = noiseFn(x, y + neighborOffset, t, s);
    float deltaX = (noiseRight - noiseLeft) / (neighborOffset*2);
    float deltaY = (noiseDown - noiseUp) / (neighborOffset*2);
    float dist2 = (deltaX * deltaX + deltaY * deltaY);
    float dist = sqrt(dist2);
    float hue = map(atan2(deltaY, deltaX), -PI, PI, 0, 255);
    float saturation = 255;
    float brightness = dist * 255;
    pixels[i] = color(hue, saturation, brightness * 255);
  }
  updatePixels();
}