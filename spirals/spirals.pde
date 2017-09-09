void setup() {
  size(500, 500);
  smooth();
}

int sizeX = 25,
    sizeY = 25;

void draw() {
  background(0);
  for(int i = 0; i < width / sizeX; i++) {
    for(int j = 0; j < height / sizeY; j++) {
      float x = i * sizeX,
            y = j * sizeY;
      float val = sin(radians((i+j*(width/sizeX))*millis()/1000f));
      fill(map(val, -1, 1, 0, 255), 0, 0);
//      fill(255, 0, 0);
      ellipseMode(CORNER);
      ellipse(x, y, sizeX, sizeY);
    }
  }
}
