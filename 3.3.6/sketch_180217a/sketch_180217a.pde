PShader shader;
PShader edgeFilter;

void setup() {
  size(2048, 2048, P2D);
  shader = loadShader("test.glsl");
  shader.set("u_resolution", (float)width, (float)height);
  edgeFilter = loadShader("differencer.glsl");
}

void draw() {
  shader(shader);
  rect(0, 0, width, height);
  filter(edgeFilter);
  println(red(get(mouseX, mouseY)), green(get(mouseX, mouseY)));
}