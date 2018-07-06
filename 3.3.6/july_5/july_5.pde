void setup() {
  size(1920, 1080);
  reset();
  noSmooth();
}

int bg = #003432;

float moonX;
float moonY;

float tx = 0;

void reset() {
  moonX = random(5, width - 5);
  moonY = random(5, height/12 - 5);
  noiseSeed((long)random(1000000));
  tx = 0;
}

int color0 = #226764;
int color1 = #AA6B39;
color moon = #D4996A;

float totalLevels = 4;
void draw() {
  background(bg);
  tx += mouseX - width/2;
  drawMoon();
  for(int level = 1; level <= totalLevels; level++) {
    drawLevel(level);
  }
}

void drawMoon() {
  float x = moonX - tx / 10;
  noStroke();
  fill(lerpColor(moon, bg, 0.5));
  ellipse(x, moonY, 45, 45); 
  fill(moon);
  ellipse(x, moonY, 30, 30);
}

void mousePressed() {
  reset();
}

float smoothstep(float x) {
  return x * x * (3 - 2 * x);
}

void drawLevel(float level) {
  float hillBase = map(level, 1, totalLevels, height/4, height * 4 / 5);
  float hillSize = height / totalLevels * 2;
  float xFrequency = map(level, 1, totalLevels, 1, 2) / width;
  color c = lerpColor(color0, color1, smoothstep(pow(level / totalLevels, 2)));
  fill(c, 128);
  beginShape();
  vertex(0, height);
  for(int x = 0; x < width; x++) {
    float y = (noise((x+tx*level) * xFrequency, level * 0.1) - 0.5) * hillSize + hillBase;
    vertex(x, y);
  }
  vertex(width-1, height);
  endShape(CLOSE);
}