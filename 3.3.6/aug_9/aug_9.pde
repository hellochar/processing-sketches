import java.util.*;

//class QuadTree<T> {
//  Region root;
//  class Region {
//    float x0, y0, x1, y1;
//    Region(float x0, float y0, float x1, float y1) {
//      this.x0 = x0;
//      this.y0 = y0;
//      this.x1 = x1;
//      this.y1 = y1;
//    }
//  }
//}

class Cell {
  float x, y;
  Cell(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void update() {
    // slime mold creates "highways" of nutrients.
    // so first there's a bed of nutrients that the slime mold feeds off of
  }
  
  void draw() {
  }
}

PGraphics nutrients;

void setup() {
  size(1280, 800, P2D);
  nutrients = createGraphics(500, 500);
  nutrients.beginDraw();
  nutrients.loadPixels();
  for (int x = 0; x < nutrients.width; x++) {
    for (int y = 0; y < nutrients.height; y++) {
      float v = noise(x / 100f, y / 100f);
      // value = lerp(value, round(value), abs(value - 0.5) * 2);
      float value = v * v * v * (v * (v * 6 - 15) + 10);
      nutrients.pixels[y*nutrients.width+x] = color(value * 255);
    }
  }
  nutrients.updatePixels();
  nutrients.endDraw();
}

void draw() {
  image(nutrients, 0, 0);
  nutrients.beginDraw();
  nutrients.loadPixels();
  nutrients.pixels
  nutrients.updatePixels();
  nutrients.endDraw();
}