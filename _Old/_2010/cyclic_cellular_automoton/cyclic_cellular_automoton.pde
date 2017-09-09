int thresh = 1;
int[] colors;
PImage next;
void setup() {
  size(400, 400);
  colors = new int[4];
  colorMode(HSB);
  for(int x = 0; x < colors.length; x++) {
    colors[x] = color(256 / colors.length * x, 240, 256);
//    if(x < 8)
//    colors[x] = color(((x%8) < 2*2 ? 0 : 255), ((x%4) < 2 ? 0 : 255), ((x%2) < 1 ? 0 : 255));
//    else
//    colors[x] = color(((x%8) < 2*2 ? 0 : 128), ((x%4) < 2 ? 0 : 128), ((x%2) < 1 ? 0 : 128));
  }
  next = createImage(width, height, RGB);
  reset();
}

void reset() {
  next.loadPixels();
  for(int x = 0; x < next.pixels.length; x++) {
    next.pixels[x] = colors[(int)random(0, colors.length)];
  }
  loadPixels();
  arraycopy(next.pixels, pixels);
  updatePixels();
  next.updatePixels();
}

void mousePressed() {
  reset();
}

void draw() {
  next.loadPixels();
  loadPixels();
  for(int k = 0; k < 1; k++) {
    for(int x = 0; x < width; x++) {
      for(int y = 0; y < height; y++) {
        act(x, y);
      }
    }
    arraycopy(next.pixels, pixels);
  }
  updatePixels();
  next.updatePixels();
}

int nfor(int col) {
  for(int x =0 ; x < colors.length; x++)
    if(colors[x] == col) return x;
  return -1;
}

void act(int x, int y) {
  int t = 0, nc = colors[(nfor(pixels[y*width+x])+1)%colors.length];
//  for(int dx = (x==0 ? 0 : -1); dx < (x==width-1 ? 1 : 2); dx++) {
//    for(int dy = (y==0 ? 0 : -1); dy < (y==height-1 ? 1 : 2); dy++) {
    for(int dx=-1;dx<2;dx++) {
      for(int dy=-1;dy<2;dy++) {
      if(getFor(x+dx, y+dy) == nc)
        t++;
    }
  }
  if(t > thresh) next.pixels[y*width+x] = nc;
}

int getFor(int x, int y) {
//  if(x < 0 || x > width-1 || y < 0 || y > height-1) return -2;
  if(x < 0) x += width;
  else if(x >= width) x -= width;
  if(y < 0) y += height;
  else if(y >= height) y -= height;
  return pixels[y*width+x];
}
