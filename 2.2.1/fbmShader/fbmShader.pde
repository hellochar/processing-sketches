PShader shader;

PImage img;

void setup() {
  size(800, 600, P2D);
  noStroke();
  
  img = loadImage("tex1-500x500.png");
  shader = loadShader("fbm.glsl");
  shader.set("resolution", float(width), float(height));
  shader.set("image", img);
  
}

int millis = 0;
float scale = 1;

void draw() {
  textureWrap(REPEAT);
  shader(shader);
  
  if(scale > 1) {
    scale = .9 * scale + .1 * 1.5;
    if(scale < 1.6) {
      scale = 1;
    }
  }
  millis += (int)(1000 * scale / frameRate);
  shader.set("mouse", float(mouseX), float(mouseY));
  shader.set("millis", millis);
  rect(0, 0, width, height);
  
  println(frameRate);
}

void keyPressed() {
  scale = 90;
}
