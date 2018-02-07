
void walkAndUpdateCounts(float x, float y, float t, float s, float directionalBiasX, float directionalBiasY, color col) {
  for (int j = 0; j < numMoves; j++) {
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

    float adjustedDx = deltaX * 100 + directionalBiasX;
    float adjustedDy = deltaY * 100 + directionalBiasY;
    float adjustedMag = dist(0, 0, adjustedDx, adjustedDy);

    float x2 = x + (adjustedDx / adjustedMag) * moveMult + random(-1, 1);
    float y2 = y + (adjustedDy / adjustedMag) * moveMult + random(-1, 1);
    //float x2 = x + adjustedDx * moveMult;
    //float y2 = y + adjustedDy * moveMult;
    float noiseAvg = (noiseUp + noiseDown + noiseLeft + noiseRight) / 4;
    //float brightnessScalar = dist + noiseAvg;
    float brightnessScalar = pow(noiseAvg, brightnessFalloff);
    //float brightnessScalar = log(1 + noiseAvg);
    col = colors[(int)map(atan2(adjustedDy, adjustedDx), -PI, PI, 0, colors.length) % colors.length];
    float r = red(col) * brightnessScalar;
    float g = green(col) * brightnessScalar;
    float b = blue(col) * brightnessScalar;
    lineCountXiaolinWu(pixelX(x), pixelY(y), pixelX(x2), pixelY(y2), r, g, b);
    x = x2;
    y = y2;
  }
}