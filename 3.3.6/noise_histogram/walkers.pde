
// how much distance to go away from when looking at your neighbor
float neighborOffset = 1;
float moveMult = 14;

void walkAndUpdateCounts(float x, float y, float t, float s, color col) {
  for (int j = 0; j < 10; j++) {
    //float noise = noiseFn(x, y, t, s);
    float noiseUp = noiseFn(x, y - neighborOffset, t, s); //<>//
    float noiseLeft = noiseFn(x - neighborOffset, y, t, s);
    float noiseRight = noiseFn(x + neighborOffset, y, t, s);
    float noiseDown = noiseFn(x, y + neighborOffset, t, s);
    float deltaX = (noiseRight - noiseLeft) / (neighborOffset*2);
    float deltaY = (noiseDown - noiseUp) / (neighborOffset*2);
    float dist2 = (deltaX * deltaX + deltaY * deltaY);
    float dist = sqrt(dist2);
    //if ((noiseUp+noiseLeft+noiseRight+noiseDown)/4 < 0.5 && dist2 < 0.00001) {
    //  // we goin nowhere!
    //  break;
    //}
    //println("< [", noiseUp, noiseLeft, noiseRight, noiseDown, "] (", deltaX, deltaY, ") -> (", deltaX / dist, deltaY / dist, ") >");

    float x2 = x + (deltaX / dist) * moveMult;
    float y2 = y + (deltaY / dist) * moveMult;
    if (dist == 0) {
      break; // absolutely no movement
    }
    //float x2 = x + deltaX * moveMult;
    //float y2 = y + deltaY * moveMult;
    //float brightnessScalar = dist / 10f;
    float noiseAvg = (noiseUp + noiseDown + noiseLeft + noiseRight) / 4;
    float brightnessScalar = (noiseAvg * noiseAvg);
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