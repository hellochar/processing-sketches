void setup() {
  size(800, 200, P2D);
}

float E = 0.63; //.63
float D = 0.6; // -.6
float F = 0.2;

float deltaR(float r, float g) {
  return r*F - g*g*D;
}

float deltaG(float r, float g) {
  return r - g*E;
}

void draw() {
  background(0);
  E = map(mouseX, 0, width, -1, 1f);
  D = map(mouseY, 0, height, -1, 1f);
  println(E, D);
  float r = 0.5;
  float g = 0.5;
  for (int x = 0; x < width; x++) {
    float dr = deltaR(r, g);
    float dg = deltaG(r, g);
    stroke(255, 0, 0);
    line(x, r * height, x + 1, (r+dr) * height);
    stroke(0, 255, 0);
    line(x, g * height, x + 1, (g+dg) * height);
    r += dr;
    g += dg;
  }
  // ok lets rethink this:
  // unclear about energy conservation
  // ok lets think about this:
  // is there energy being put into the environment - lets say yes, but only because of a reaction
  // low resources, high grass -> grass should die, resources go up
  // low resources, low grass -> either stable, or grass grows a bit and resources go down a bit, or resources go up a bit and grass dies a bit
  // high resources, low grass -> grass grows, resources dwindle
  // high resources, high grass -> grass saturates, resources dwindle ** this is a key
  
  // so resources - they:
  // decrease in proportion to amount of grass
  // decrease in proportion to amount of resources
  // dr = -g^2
  
  // grass - they
  // decrease in proportion to amount of grass
  // increase in proportion to amount of resources
  // dg = r - g
  
  // it should require resources to simply *sustain* grass
}