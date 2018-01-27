import zhang.*;

float x = 0, y = 0;
PGraphics g;
void setup() {
  size(500, 500);
  g = createGraphics(width, height, P2D);
  g.beginDraw();
  g.background(0);
  g.stroke(255);
  g.endDraw();
}

float m = .07, p = .9;
float ldx = 0, ldy = 0;

void draw() {
  g.beginDraw();
  g.background(0, 10);
  float dx = Math.signum(mouseX - x) * pow(abs(mouseX - x), p) * m,
        dy = Math.signum(mouseY - y) * pow(abs(mouseY - y), p) * m;
  float len = sqrt(dx*dx+dy*dy),
        angWant = atan2(dy, dx),
        lastAng = atan2(ldy, ldx),
        ang = Methods.turnTowardsAngle(lastAng, angWant, 0.02);
  g.line(x, y, x += len * cos(ang), y += len * sin(ang));
  ldx = dx;
  ldy = dy;
  g.loadPixels();
  loadPixels();
  arraycopy(g.pixels, pixels);
  updatePixels();
  g.endDraw();
  println(frameRate);
}
