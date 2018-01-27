void setup() {
  size(500, 500);
}

void draw() {
  loadPixels();
  colorMode(HSB);
  float max = 0;
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) {
      float[] valArr = pattern1(3.0 * x / width, 3.0 * y / height);
      float val = valArr[0];
      pixels[y*width+x] =
        color(255*val); 
//        color(255*val, 255 * sqrt(valArr[1]*valArr[1] + valArr[2]*valArr[2]), 255);
//        lerpColor(c1, c2, val);
//        color(map(val, 0, 1, 102, 184), 255, 255);
      float len = sqrt(valArr[1]*valArr[1] + valArr[2]*valArr[2]);
      max = max(len, max);
    }
  }
  updatePixels();
}

float[] pattern1(float x, float y) {
  float xq = fbm(x + 0.0, y + 0.0),
        yq = fbm(x + map(mouseX, 0, width, -5, 5), y + map(mouseY, 0, height, -5, 5));
  
  float rx = fbm(x + 4*xq + 1.7, y + 4*yq + 9.2),
        ry = fbm(x + 4*xq + 8.3, y + 4*yq + 2.8);
        
  return new float[] {
    fbm(x + 4*rx, y + 4*ry),
    xq,
    yq,
    rx,
    ry
  };
}

float fbm(float x, float y) {
  int octaves = 4;
  float scalar = 0.25;
  float sum = 0;
  for(int i = 0; i < octaves; i++) {
    sum += pow(scalar, i) * noise(x*pow(2, i), y*pow(2, i));
  }
  return sum;
}
