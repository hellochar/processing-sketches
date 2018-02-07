// counting and drawing
float countAddGamma = 1e2;

//walkers
// how much distance to go away from when looking at your neighbor
float neighborOffset = 10;
float moveMult = 2;
int numMoves = 5;
float brightnessFalloff = 0.75; // 4 is very spotlighty, don't do 0, 2 is semi-spotlight, -1 is really cool

//noise
float tierDist = 500;
float smoothness = 2; // lower values < 1 are sharper
float distanceStable = 0;

float radialNoiseFreq = 0;
float noiseFactorWeight = 0;
float additionalCartesianNoiseWeight = 0;
float cartesianWavelength = 500;

float NOISE_DX = 0;
float NOISE_DY = 0;
float NOISE_SCALAR = 0.25;

String name;

void randomizeParameters() {
  tierDist = 300 * pow(2, random(0, 2.1));
  // with sharpness we want 50% 0 - 1, and 50% 1 to like 10
  smoothness = 8 / (1 + random(10));
  distanceStable = 0.5 + random(0, 2);
  
  radialNoiseFreq = 1 + (int)random(-1, 2) / 2; // -1, 0, 1
  noiseFactorWeight = random(1);
  additionalCartesianNoiseWeight = random(1);
  cartesianWavelength = random(400, 1000);
  float extentX = 1000 * (1 + (random(1) * random(1) * random(1)) * 8);
  float extentY = 1000 * (1 + (random(1) * random(1) * random(1)) * 8);
  
  NOISE_DX = random(-extentX, extentX);
  NOISE_DY = random(-extentY, extentY);
  NOISE_SCALAR = 1;
  
  name = colorPaletteName + "_" + round(tierDist) + "_" + round(smoothness * 100);
}