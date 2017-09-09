import java.util.ArrayList;

ArrayList list;
float r, g, b, variance = 40;
float size = 3;
float sizeNorm = 10;

PGraphics graphics;

void setup() {
  size(900, 450);
  background(0);
  r = random(255); 
  g = random(255);
  b = random(255);
  list = new ArrayList();
//  noStroke();
//  for(int a = 0; a < 50; a++) {
//    list.add(new Ball(a, a*5, 0, 0, r, g, b, variance / 2));
//    r += random(-variance, variance);
//    g += random(-variance, variance);
//    b += random(-variance, variance);
//  }
  graphics = createGraphics(width, height, JAVA2D);
  graphics.beginDraw();
  graphics.background(0);
  graphics.smooth();
  graphics.endDraw();
//  mouseX = width/2;
//  mouseY = height/2;
}
int k;
int m = 1;

void draw() {
  list.add(new Ball(width/2, height/2, 0, 0, r, g, b, variance / 2));
  r += random(-variance, variance);
  g += random(-variance, variance);
  b += random(-variance, variance);
    
  if(mousePressed) {
   if(mouseButton == LEFT) sizeNorm += 1;
   else sizeNorm = max(sizeNorm-1, 0);
  }
  
  m = 1;
  if(keyPressed) {
    if(key == 'r') {
      m = -1;
    }
  }
  k = (int)random(list.size());
  
  graphics.beginDraw();
  graphics.background(0, 2);
  for(int a = 0; a < list.size(); a++) {
    Ball b = (Ball) list.get(a);
    b.run();
  }
  Ball b = (Ball) list.get(k);
  size = min(sizeNorm/dist(b.x, b.y, mouseX, mouseY), 300);
  if(keyPressed & key == 'f') {
    size = 800;
  }
  for(int a = 0; a < list.size(); a++) {
    b = (Ball) list.get(a);
    b.show();
  }
  graphics.loadPixels();
  loadPixels();
  arraycopy(graphics.pixels, pixels);
  updatePixels();
  graphics.updatePixels();
  graphics.endDraw();
//  image(graphics, 0, 0);
}

class Ball {
  float x, y, dx, dy; 
  float ox, oy;
  float r, g, b, variance;
  
  Ball(float x, float y, float dx, float dy, float r, float g, float b, float v) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.r = r;
    this.g = g;
    this.b = b;
    variance = v;
  }  
  
  void run() {
    ox = x;
    oy = y;
//    x += dx;
//    y += dy;
//    dx += (mouseX-x)/100;
//    dy += (mouseY-y)/100;
    float ang = atan2(mouseY-y, mouseX-x);
    float dist = dist(x, y, mouseX, mouseY);
    if(dist == 0) return;
    x += 25*cos(ang)/sqrt(dist)*m;
    y += 25*sin(ang)/sqrt(dist)*m;
//    size = 10/dist;
  }
  
  void show() {
    r += random(-variance, variance);
    g += random(-variance, variance);
    b += random(-variance, variance);
    graphics.strokeWeight(size);
    graphics.stroke(color(r, g, b, 50));
    graphics.line(x, y, ox, oy);
  }
}
