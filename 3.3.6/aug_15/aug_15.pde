import java.util.*;

List<PImage> images = new ArrayList();

PShader post;
PGraphics tinter;


float iw;
float ih;

void setup() {
  size(1920, 1080, P2D);
  iw = width / 6f;
  ih = 600f / 800f * iw;
  
  tinter = createGraphics(800, 600);
  tinter.beginDraw();
  tinter.background(0, 0);
  tinter.loadPixels();
  for (int i = 0; i < tinter.pixels.length; i++) {
    int x = i % tinter.width;
    int y = i / tinter.width;
    float r = dist(tinter.width/2, tinter.height/2, x, y) / dist(tinter.width/2, tinter.height/2, 0, 0);
    float a = sigmoid(r, 0.52, 0.25) * 255;
    tinter.pixels[i] = color(a);
  }
  tinter.updatePixels();
  tinter.endDraw();
  
  // images = 
  File dir = new File(dataPath(""));
  File[] files = dir.listFiles();
  for (int i = 0; i < files.length; i++) {
    // println(f.getName());
    if (files[i].getName().contains("png")) {
      PImage img = loadImage(files[i].getName());
      img.mask(tinter);
      images.add(img);
    }
  }
  println(images.size());
  post = loadShader("post.glsl");
}

// sigmoid is ~1 at x < c-k, ~0 at x > c+k, and decreases in a sigmoid pattern in the middle 
float sigmoid(float x, float c, float k) {
  return (float)Math.tanh((-x + c) * PI / k) * 0.5 + 0.5;
}

void draw() {
  background(color(1, 26, 39));
  filter(post);
  for (int i = 0; i < images.size(); i++) {
    int col = i % 6;
    int row = i / 6;
    
    imageMode(CENTER);
    // mask(tinter);
    //float h = height / 5f;
    float x = map(col, 0 - 1, 5 + 1, 0, width);
    float y = map(row, 0 - 1, 2 + 1, 0, height);
    image(images.get(i), x, y, iw, ih);
  }
  saveFrame("all_together.png");
  exit();
//  image(tinter, 0, 0);
}