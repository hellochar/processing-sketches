PShader f;
// color[] colorTheme = new color[] {#011A27, #063852, #F0810F, #E6DF44}; polyphone
// color[] colorTheme = new color[] {#021C1E, #004445, #2C7873, #6FB98F};
// color[] colorTheme = new color[] {#80BD9E, #89DA59, #F98866, #FF420E}; polyphone2
// color[] colorTheme = new color[] {#50312F, #E4EA8C, #CB0000, #3F6C45};
color[] colorTheme = new color[] {#1E1F26, #283655, #486824, #4897D8}; // polyphone 3

class Thing {
  float x, y, z;
  color fill;
  float rx, ry, rz;
  Thing(color f) {
    x = random(-width, width);
    y = random(-height, height);
    z = random(-10, 10);
    fill = f;
    rx = random(PI);
    ry = random(PI);
    rz = random(PI);
  }
  
  void draw() {
    noStroke();
    fill(fill);
    pushMatrix();
    translate(x, y, z);
    rotateX(rx);
    rotateY(ry);
    rotateZ(rz);
    box(5, 5, 30);
    //triangle(-20, 20, 20, 20, 0, 20 - 40 * sqrt(3) / 2);
    popMatrix();
  }
  
  void update() {
    float dx = (y - z) * 0.0 + noise(0, y / 100, z / 100) - 0.5;
    float dy = (z - x) * 0.0 + noise(x / 100, 0, z / 100) - 0.5;
    float dz = (x - y) * 0.0 + noise(x / 100, y / 100, 0) - 0.5;
    x += dx;
    y += dy;
    z += dz;
    //x *= 0.95;
    //y *= 0.95;
    //z *= 0.95;
    rx = atan2(dy, dz);
    ry = atan2(dz, dx);
    float pullAmount = map(pow(sin(millis() / 400f), 3), -1, 1, 0.95, 1 / 0.95);
    x *= pullAmount;
    y *= pullAmount;
    z *= pullAmount;
  }
}
Thing[] things = new Thing[20000];
PGraphics bg;

void setup() {
  size(1280, 800, P3D);
  smooth(8);
  f = loadShader("post.glsl");
  
  bg = createGraphics(width, height);
  bg.beginDraw();
    float rMax = dist(width/2, height/2, 0, 0);
    for(float r = rMax; r > 0; r--) {
      bg.noStroke();
      bg.fill(lerpColor(colorTheme[0], colorTheme[1], 1 - r / rMax));
      bg.ellipse(width/2, height/2, r*2, r*2);
    }
  bg.endDraw();
  for(int i = 0; i < things.length; i++) {
    if (i < things.length/2) {
      things[i] = new Thing(color(colorTheme[2], 128));
    } else {
      things[i] = new Thing(color(colorTheme[3], 128));
    }
  }
//  saveFrame("polyphone2.png");
}

void draw() {
  println(frameRate);
  background(bg);
  camera(width/2, height/2, mouseX - width/2, 0, 0, 0, 0, 0, -1);
  for (Thing t : things) {
    t.update();
  }
  for (Thing t : things) {
    t.draw();
  }
  f.set("time", millis() / 1000f);
  filter(f);
}