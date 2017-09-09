PShader shader;

float[] mousePositions = new float[100*2]; // 20 entries of x and y
float[] mouseVelocities = new float[100*2]; // entries dx and dy
float count = 0;

PImage img;

void setup() {
  size(500, 500, P2D);
  noStroke();
  
  img = loadImage("tex1-500x500.png");
  shader = loadShader("fbm.glsl");
  shader.set("resolution", float(width), float(height));
  shader.set("image", img);
}

void mousePressed() {
  if(count < mousePositions.length) {
    mousePositions[(int)(count++)] = (float)mouseX;
    mouseVelocities[(int)count] = (float)(mouseX - pmouseX);
    mousePositions[(int)(count++)] = height - (float)mouseY;
    mouseVelocities[(int)count] = (float)(mouseY - pmouseY);
    shader.set("count", (float)int(count/2));
  }
}

void draw() {
  shader(shader);
  
  for(int i = 0; i < count; i++) {
    mousePositions[i] += mouseVelocities[i];
  }
  shader.set("mousePositions", mousePositions, 2);
  shader.set("mouse", float(mouseX), float(mouseY));
  rect(0, 0, width, height);
}
