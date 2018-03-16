PShader shader;
PGraphics pg;

float GOOD_X = .214;
float GOOD_Y = .128;
//float bottom = GOOD_X - 0.1, left = GOOD_X - 0.1, top = GOOD_Y + 0.1, right = GOOD_Y + 0.1;
float bottom = -1, left = -1, top = 1, right = 1;

void setup() {
  size(500, 500, P2D);
  shader = loadShader("wave.glsl");
  pg = createGraphics(width, height, P2D);
  shader.set("u_tex", pg);
  shader.set("u_resolution", (float)width, (float)height);
}

void draw() {
  shader.set("lowerLeft", left, bottom);
  shader.set("upperRight", right, top);
  shader.set("u_time", millis() / 1000f);
  shader.set("u_mouse", (float)mouseX, height - (float)mouseY);
  pg.beginDraw();
  pg.shader(shader);
  pg.rect(0, 0, width, height);
  pg.endDraw();
  image(pg, 0, 0);
  color pixelAt = get(mouseX, mouseY);
  //println(red(pixelAt) / 255.0, green(pixelAt) / 255.0);
  println(map(mouseX, 0, width, left, right), map(mouseY, 0, height, top, bottom));
  if (keyPressed) {
    if (key == 'w') {
      top += 0.1;
      bottom += 0.1;
    }
    if (key == 'a') {
      left -= 0.1;
      right -= 0.1;
    }
    if (key == 's') {
      top -= 0.1;
      bottom -= 0.1;
    }
    if (key == 'd') {
      left += 0.1;
      right += 0.1;
    }
    if (key == '=') {
      float midX = (left+right)/2;
      float midY = (top+bottom)/2;
      left = lerp(left, midX, 0.1);
      right = lerp(right, midX, 0.1);
      top = lerp(top, midY, 0.1);
      bottom = lerp(bottom, midY, 0.1);
    }
    if (key == '-') {
      float midX = (left+right)/2;
      float midY = (top+bottom)/2;
      left = lerp(left, midX, -0.1);
      right = lerp(right, midX, -0.1);
      top = lerp(top, midY, -0.1);
      bottom = lerp(bottom, midY, -0.1);
    }
  }
}