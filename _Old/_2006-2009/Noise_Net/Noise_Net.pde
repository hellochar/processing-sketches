//PGraphics g;
void setup() {
  size(300, 300);
//  g = createGraphics(150, 150, JAVA2D);
}

float d = 1.5, nmult = .015, tmult = .01, scale = 100;
void draw() {
//  g.beginDraw();
  background(255);
  loadPixels();
  float k = map(mouseX, 0, width, 0, 10);
  for(float x = 0 ; x < width; x += d) {
    for(float y = 0; y < height; y += d) {
      act(x + scale * (noise(nmult * x+1, nmult * y, tmult * frameCount) - .5), 
          y + scale * (noise(nmult * x,   nmult * y, tmult * frameCount) - .5));
    }
  }
  updatePixels();
//  image(g, 0, 0, width, height);
//  g.endDraw();
  println(frameRate);
}


void act(float x, float y) {
  if(x < 0 || x >= width - .5f || y < 0 || y >= height - .5f) return;
  pixels[round(y) * width + round(x)] = color(30, 20, 120, 128);
}
