float[][] cur;

void setup() {
  size(500, 500);
  cur = new float[width][height];
  for(int i = 0; i < cur.length; i++) {
    for(int j = 0; j < cur[0].length; j++) {
      cur[i][j] = 1;
    }
  }
  colorMode(HSB, 1, 1, 1);
}

void draw() {
  float max = 0, min = 1;
  loadPixels();
  for(int i = 0; i < cur.length; i++) {
    for(int j = 0; j < cur[0].length; j++) {
      float v = cur[i][j] *= noise(i*.02, j*.02, frameCount*.02);
      if(max < v) max = v; else if(min > v) min = v;
      pixels[j*width+i] = color(v, 1, 1);
    }
  }
  updatePixels();
}
