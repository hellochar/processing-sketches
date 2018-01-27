import zhang.*;

World w;
Camera c;
int bg;

void setup() {
  w = new World(this);
  c = new Camera(this);
  c.ms(10);
  c.registerScrollWheel(1.05f);
  bg = color(252, 64);
  colorMode(HSB);
}

void draw() {
  c.uiHandle();
  c.apply();
  background(bg);
  w.step();
}
