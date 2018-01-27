float[][] map;
float mult = .02;

void setup() {
  size(500, 500);
  map = new float[width][height];
  for(int x = 0; x < width; x++) {
    for(int y =0 ; y < height; y++) {
      map[x][y] = noise(x * mult, y * mult);
    }
  }
}

void draw() {
  
}
