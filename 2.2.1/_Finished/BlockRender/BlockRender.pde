public static final int CELL_SIZE = 50;

PV curPV;

void setup() {
  size(500, 500);
  curPV = newPV;
}

void draw() {
  render(curPV);
}

void render(PV pv) {
  loadPixels();
  for(int x = 0; x < width; x += CELL_SIZE) {
    for(int y = 0; y < height; y += CELL_SIZE) {
//      float mx = x + CELL_SIZE/2,
//            my = y + CELL_SIZE/2;
      calculateBlock(x, y, pv);
    }
  }
  updatePixels();
}

void calculateBlock(int x, int y, PV pv) { //top left corner.
  float mx = x + CELL_SIZE/2f,
        my = y + CELL_SIZE/2f;
        
  for(int i = x; i < x + CELL_SIZE && i < width; i++) {
    for(int j = y; j < y + CELL_SIZE && y < height; j++) {
      setPixel(i, j, pv.pixelValue(i, j, mx, my));
    }
  }
}


void setPixel(int x, int y, int c) {
  pixels[y*width+x] = c;
//  set(x, y, c);
}

void mousePressed() {
  curPV.mousePressed();
}

void keyPressed() {
  curPV.keyPressed();
}
