import kinect4WinSDK.*;

Kinect kinect;

void setup() {
  fullScreen();
  kinect = new Kinect(this);
  //size(1920, 1080);
  
  colorMode(HSB);
}

void draw() {
  //float x = frameCount;
  noStroke();
  PImage depth = kinect.GetDepth();
  depth.loadPixels();
  float blockSize = 10;
  for (float x = 0; x < width; x += blockSize) {
    for (float y = 0; y < height; y += blockSize) {
      int depthX = (int)map(x, 0, width, 0, depth.width);
      int depthY = (int)map(y, 0, height, 0, depth.height);
      float depthPixelValue = brightness(depth.pixels[depthY * depth.width + depthX]);
      if (depthPixelValue < 128) {
        depthPixelValue = 0;
      }
      float t = (x + y) / (blockSize * 10) * PI + 0.001 * frameCount + floor(y / (blockSize * 10)) * PI;
      t += depthPixelValue / 255 * PI;
      float h = 0;
      float s = 0;
      float b = cos(t) * 128 + 128;//cos(t) < 0 ? 0 : 255;
      //println(h, s, b);
      fill(h, s, b);
      rect(x, y, blockSize, blockSize);
    }
  }
  //fill(0); noStroke();
  //rect(x % width, 0, x + width/2, height);
  //// rect((x + width) % width, 0, x + width/2 + width, height);
  //fill(255);
  //rect(x + width/2, 0, x + width, height);
  //rect(x + width/2 - width, 0, x + width - width, height);
}