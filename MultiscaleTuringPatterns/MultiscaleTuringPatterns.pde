int n, levels;
float[] grid;
float[] diffusionLeft, diffusionRight, blurBuffer, variation;
float[] bestVariation;
int[] bestLevel;
boolean[] direction;
float[] stepSizes;
int[] radii;
 
PImage buffer;
 
void setup() {
  size(500, 500, P2D);
 
  // relates to the complexity (how many blur levels)
  float base = random(1.5, 2.4); // should be between 1.3 and 3
   
  // these values affect how fast the image changes
  float stepScale = random(.006, .011);
  float stepOffset =  random(.007, .012);
 
  // allocate space
  n = width * height;
  levels = (int) (log(width) / log(base));
  radii = new int[levels];
  stepSizes = new float[levels];
  grid = new float[n];
  diffusionLeft = new float[n];
  diffusionRight = new float[n];
  blurBuffer = new float[n];
  variation = new float[n];
  bestVariation = new float[n];
  bestLevel = new int[n];
  direction = new boolean[n];
  buffer = createImage(width, height, RGB);
 
  // determines the shape of the patterns
  for (int i = 0; i < levels; i++) {
    int radius = (int) pow(base, i);
    radii[i] = radius;
    stepSizes[i] = log(radius) * stepScale + stepOffset;
  }
 
  // initialize the grid with noise
  for (int i = 0; i < n; i++) {
    grid[i] = random(-1, +1);
  }
}
 
void step() {
  float[] activator = grid;
  float[] inhibitor = diffusionRight;
 
  for (int level = 0; level < levels - 1; level++) {
    // blur activator into inhibitor
    int radius = radii[level];   
    blur(activator, inhibitor, blurBuffer, width, height, radius);
 
    // absdiff between activator and inhibitor
    for (int i = 0; i < n; i++) {
      variation[i] = activator[i] - inhibitor[i];
      if (variation[i] < 0) {
        variation[i] = -variation[i];
      }
    }
 
    if (level == 0) {
      // save bestLevel and bestVariation
      for (int i = 0; i < n; i++) {
        bestVariation[i] = variation[i];
        bestLevel[i] = level;
        direction[i] = activator[i] > inhibitor[i];
      }
      activator = diffusionRight;
      inhibitor = diffusionLeft;
    }
    else {
      // check/save bestLevel and bestVariation
      for (int i = 0; i < n; i++) {
        if (variation[i] < bestVariation[i]) {
          bestVariation[i] = variation[i];
          bestLevel[i] = level;
          direction[i] = activator[i] > inhibitor[i];
        }
      }
      float[] swap = activator;
      activator = inhibitor;
      inhibitor = swap;
    }
  }
 
  // update grid from bestLevel
  float smallest = Float.POSITIVE_INFINITY;
  float largest = Float.NEGATIVE_INFINITY;
  for (int i = 0; i < n; i++) {
    float curStep = stepSizes[bestLevel[i]];
    if (direction[i]) {
      grid[i] += curStep;
    }
    else {
      grid[i] -= curStep;
    }
    smallest = min(smallest, grid[i]);
    largest = max(largest, grid[i]);
  }
 
  // normalize to [-1, +1]
  float range = (largest - smallest) / 2;
  for (int i = 0; i < n; i++) {
    grid[i] = ((grid[i] - smallest) / range) - 1;
  }
}
 
void drawBuffer(float[] grid) {
  buffer.loadPixels();
  color[] pixels = buffer.pixels;
  for (int i = 0; i < n; i++) {
    pixels[i] = color(128 + 128 * grid[i]);
  }
  buffer.updatePixels();
  image(buffer, 0, 0);
}
 
void draw() {
  step();
  drawBuffer(grid);
}
 
void mousePressed() {
  setup();
}

void keyPressed() {
  saveFrame("mtp-####.png");
}

void blur(float[] from, float[] to, float[] buffer, int w, int h, int radius) {
  // build integral image
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      int i = y * w + x;
      if (y == 0 && x == 0) {
        buffer[i] = from[i];
      } else if (y == 0) {
        buffer[i] = buffer[i - 1] + from[i];
      } else if (x == 0) {
        buffer[i] = buffer[i - w] + from[i];
      } else {
        buffer[i] = buffer[i - 1] + buffer[i - w] - buffer[i - w - 1] + from[i];
      }
    }
  }
  // do lookups
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      int minx = max(0, x - radius);
      int maxx = min(x + radius, w - 1);
      int miny = max(0, y - radius);
      int maxy = min(y + radius, h - 1);
      int area = (maxx - minx) * (maxy - miny);
       
      int nw = miny * w + minx;
      int ne = miny * w + maxx;
      int sw = maxy * w + minx;
      int se = maxy * w + maxx;
       
      int i = y * w + x;
      to[i] = (buffer[se] - buffer[sw] - buffer[ne] + buffer[nw]) / area;
    }
  }
}

