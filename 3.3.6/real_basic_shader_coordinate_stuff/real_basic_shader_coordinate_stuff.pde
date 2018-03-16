PShader s;

void setup() {
  size(800, 600, P3D);
  s = loadShader("testFrag.glsl", "testVert.glsl");
}

void draw() {
  background(frameCount % 255);
  shader(s, TRIANGLES);
  //rect(0, 0, width, height);
  beginShape();
  vertex(0, 0, 0);
  vertex(0.5, 0, 0);
  vertex(0.5, 0.5, 0);
  endShape(CLOSE);
}