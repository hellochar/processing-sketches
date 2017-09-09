PShader shader; 

void setup() {
  size(500, 500, P2D);
  shader = loadShader("frag.glsl");

  background(0);
}

void draw() {
  shader(shader);
  rect(0, 0, width, height);
}
