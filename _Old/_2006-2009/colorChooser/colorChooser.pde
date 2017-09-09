PGraphics colors;
color c;

void setup() {
  size(550, 500);
  colors = createGraphics(width - 50 + 3, height, JAVA2D);
  colors.beginDraw();
  colors.colorMode(HSB, colors.width);
  for(int a = 0; a < colors.width; a++) {
    for(int b = 0; b < colors.height; b++) {
      colors.stroke(a, b, colors.width);
      colors.point(a, b);
    }
  }
  colors.fill(color(0));
  colors.smooth();
  colors.noStroke();
  colors.rect(colors.width - 3, 0, 3, colors.height);
  colors.endDraw();
  image(colors, 0, 0);
  rectMode(CORNERS);
}

void draw() {
  fill(c);
  rect(colors.width, 0, width, height);
}

void mousePressed() {
  c = colors.get(mouseX, mouseY);
  println( (c >> 16 & 0xFF) + ", " + (c >> 8 & 0xFF) + ", " + (c & 0xFF));
  println("0x"+hex(c).substring(2));
  println(c);
  redraw();
}

int colorLerp(int c1, int c2, float amount) {
  return color( lerp( (c1 >> 16 & 0xFF), (c2 >> 16 & 0xFF), amount), lerp( (c1 >> 8 & 0xFF), (c2 >> 8 & 0xFF), amount), lerp( (c1 & 0xFF), (c2 & 0xFF), amount) );
}
