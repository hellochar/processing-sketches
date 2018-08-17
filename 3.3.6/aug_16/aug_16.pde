import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

color white = color(255);
color farFade = color(0);

PostFX fx;

PShader grain;
PShader post;

void setup() {
  size(1280, 800, P2D);
  frameRate(30);
  smooth(8);
  fx = new PostFX(this);
  grain = loadShader("grain.glsl");
  post = loadShader("post.glsl");
}

float x, y, s;
float tx = 0, ty = 0, ts = 1;

void mousePressed() {
  tx = -mouseX;
  ty = -mouseY;
  ts = (ts == 1 ? 2 : 1);
}

void draw() {
  background(white);
  tx = mouseX - width/2;
  ty = mouseY - height/2;
  x = lerp(x, tx, 0.1);
  y = lerp(y, ty, 0.1);
  s = lerp(s, ts, 0.1);
  translate(x, y);
  scale(s);
  
  float yC = height/2;
  for(float y = 0; y < yC; y += yC / 10) {
    noStroke();
    fill(lerpColor(white, farFade, floor(y / yC * 10) / 10f));
    rect(0, y, width, yC / 10);
  }
  grain.set("time", millis() / 1000f);
  filter(grain);
  strokeWeight(10);
  stroke(0);
  line(0, height/2+5, width, height/2+5);
  
  noStroke();
  fill(0);
  for (int x = 0; x < 5; x++) {
    ellipse(15 + 25 + x * 60, height/2+5 + 15 + 25, 30, 30);
  }
  
  stroke(0);
  strokeWeight(25);
  line(350, height/2+5+15+25, width-350, height/2+5+15+25);
  
  fx.render()
    .bloom(0.5, 20, 30)
    .compose();
  filter(post);
}