
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
      -230.1111 + normY * radialNoiseFreq,
      noiseZ + 23.13
    ) +
    additionalCartesianNoiseWeight * noise(
      5942.4677 + x / cartesianWavelength,
      -411.9 + y / cartesianWavelength,
      noiseZ + 23.13
    );
  float modifiedDist = globalScalar * distFromCenter * noiseScalar;
  
  // computes a triangle wave of wavelength tierDist that's 0 at the ends and tierDist / 2 at the middle
  //float closestTier = (round(modifiedDist / tierDist)) * tierDist;
  //float offset = abs(modifiedDist - closestTier);
  
  // instead we want a smooth wave (lets use sin^2) of wavelength tierDist, 0 at the ends and tierDist/2 at the middle
  float angle = modifiedDist / tierDist * PI;
  float offset = pow(sin(angle), 2);
  //return offset;
  return smoothness / (smoothness + offset * offset * tierDist / 4);
  //return noise(131.2 + x * ns, 22 + y * ns, z);
}