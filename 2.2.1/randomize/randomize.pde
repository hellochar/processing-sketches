PShader s, blur;

void setup() {
  size(500, 500, P2D);
  s = loadShader("randomize.glsl");
//  blur = loadShader("blur.glsl");
}

int oldMillis = 0;

void draw() {
  fill(255, 0, 0);
  rect(mouseX, mouseY, 60, 60);
  filter(s);
  filter(blur);
  int m = millis();
  println(m - oldMillis);
  oldMillis = m;
}
