
//walkers
// how much distance to go away from when looking at your neighbor
float neighborOffset = 1;
float moveMult = 2;

//noise
float tierDist = 300;
float sharpness = 6; // lower values < 1 are sharper
float distanceStable = 2;

float radialNoiseFreq = 2;
float noiseFactorWeight = 0.8;
float additionalCartesianNoiseWeight = 1;
float cartesianWavelength = 800;

float NOISE_DX = 1000;
float NOISE_DY = -990;
float NOISE_SCALAR = 1;

String name;

void randomizeParameters() {
  tierDist = 200 * pow(2, random(-0.5, 2.1));
  // with sharpness we want 50% 0 - 1, and 50% 1 to like 10
  sharpness = 8 / (1 + random(10));
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
  
  name = colorPaletteName + "_" + round(tierDist) + "_" + round(sharpness * 100);
}