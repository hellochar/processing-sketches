import java.util.*;
/**/

Queue<PImage> history;

PShader bleedShader;

void setup() {
  size(displayWidth, displayHeight, P2D);
  history = new LinkedList();
  background(0);
  smooth();
  
  bleedShader = loadShader("bleed.glsl");
  bleedShader.set("resolution", float(width), float(height));
}

void draw() {
  bleedShader.set("time", (float)(millis()/1000.0));
  
  blendMode(BLEND);
  drawHorizontalBar();
  drawDots();
  
  fill(0, 3);
  rect(0, 0, width, height);
  
  if (frameCount % 10 == 0) {
    history.add(get());
    if (history.size() > 50) {
      history.remove();
    }
  }
  
  for( PImage img : history ) {
    if (random(1) < 0.01) {
      image(img, 0, 0);
    }
  }
  
  if (mousePressed) {
    filter(bleedShader);
  }
}

void drawHorizontalBar() {
  noStroke();
  fill(255);
  float rectWidth = 10;
  float x = frameCount * rectWidth % width;
  rect(x, 0, rectWidth, height);
}

void drawDots() {
  noStroke();
  fill(255);
  for(int i = 0; i < 50; i++) {
    ellipse(randomGaussian() * width / 2 + width / 2, randomGaussian() * height / 2 + height / 2, 25, 25); 
  }
}
