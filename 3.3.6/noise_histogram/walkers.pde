
void walkAndUpdateCounts(float x, float y, float t, float s, float directionalBiasX, float directionalBiasY, color col) {
  float directionalMag = 1; // random(1);
  for (int j = 0; j < 20; j++) {
    //float noise = noiseFn(x, y, t, s);
    float noiseUp = noiseFn(x, y - neighborOffset, t, s);
    float noiseLeft = noiseFn(x - neighborOffset, y, t, s);
    float noiseRight = noiseFn(x + neighborOffset, y, t, s);
    float noiseDown = noiseFn(x, y + neighborOffset, t, s);
    float deltaX = (noiseRight - noiseLeft) / (neighborOffset*2);
    float deltaY = (noiseDown - noiseUp) / (neighborOffset*2);
    float dist2 = (deltaX * deltaX + deltaY * deltaY);
    float dist = sqrt(dist2);
    if (dist == 0) {
      break; // absolutely no movement
    }

    float adjustedDx = deltaX / dist + directionalBiasX * directionalMag;
    float adjustedDy = deltaY / dist + directionalBiasY * directionalMag;
    //float adjustedDx = directionalBiasX;
    //float adjustedDy = directionalBiasY;
    float adjustedMag = dist(0, 0, adjustedDx, adjustedDy);

    float x2 = x + (adjustedDx / adjustedMag) * moveMult;
    float y2 = y + (adjustedDy / adjustedMag) * moveMult;
    //float x2 = x + deltaX * moveMult;
    //float y2 = y + deltaY * moveMult;
    //float brightnessScalar = dist / 10f;
    float noiseAvg = (noiseUp + noiseDown + noiseLeft + noiseRight) / 4;
    float brightnessScalar = noiseAvg * noiseAvg;
    float r = red(col) * brightnessScalar;
    float g = green(col) * brightnessScalar;
    float b = blue(col) * brightnessScalar;
    //int pixelX = round(pixelX(x));
    //int pixelY = round(pixelY(y));
    //int pixelX2 = round(pixelX(x2));
    //int pixelY2 = round(pixelY(y2));
    //lineCountBresenham(pixelX, pixelY, pixelX2, pixelY2, r, g, b);
    lineCountXiaolinWu(pixelX(x), pixelY(y), pixelX(x2), pixelY(y2), r, g, b);
    x = x2;
    y = y2;
  }
}