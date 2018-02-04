float tierDist = 300;
float sharpness = 4; // lower values < 1 are sharper
float distanceStable = 2;

float radialNoiseFreq = 2;
float noiseFactorWeight = 0.8;
float additionalCartesianNoiseWeight = 1.5;
float cartesianWavelength = 800;

float NOISE_DX = 1000;
float NOISE_DY = -990;
float NOISE_SCALAR = 1;

// creates rolling rings radiating outwards from (0, 0) that are noise modulated both by angle and distance
// x and y are in "noise" space
float noiseFn(float x, float y, float time, float globalScalar) {
  x = x * NOISE_SCALAR + NOISE_DX;
  y = y * NOISE_SCALAR + NOISE_DY;
  float distFromCenter = dist(x, y, 0, 0);
  if (distFromCenter == 0) {
    return 0;
  }
  float normX = x / distFromCenter;
  float normY = y / distFromCenter;
  float noiseZ = time + distFromCenter / tierDist / distanceStable;
  float noiseScalar =
    (1 - noiseFactorWeight) +
    noiseFactorWeight * noise(
      131.2 + normX * radialNoiseFreq,
      -23910.1111 + normY * radialNoiseFreq,
      noiseZ + 23.13
    ) +
    additionalCartesianNoiseWeight * noise(
      5942.4677 + x / cartesianWavelength,
      -411.9 + y / cartesianWavelength,
      noiseZ + 23.13
    );
  float modifiedDist = globalScalar * distFromCenter * noiseScalar;
  
  float closestTier = (round(modifiedDist / tierDist)) * tierDist;
  
  //float wantedDist = scalar * closestTier * (0.5 + 1 * noise(131.2 + normX * ns, -23910.1111 + normY * ns, z));
  float wantedDist = closestTier;
  
  float offset = abs(modifiedDist - wantedDist);
  return (tierDist * sharpness) / (tierDist * sharpness + offset * offset);
  //return noise(131.2 + x * ns, 22 + y * ns, z);
}