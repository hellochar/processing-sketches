import JMyron.*;

JMyron m;

Particle[] list;

void setup() {
  size(640, 480);
  m = new JMyron();
  m.start(320, 240);
  m.trackNotColor(190, 142, 83, 200);
  m.minDensity(75);
  buf = createGraphics(320, 240, P2D);
  list = new Particle[100];
  for(int i = 0; i < list.length; i++) {
    list[i] = new Particle(random(width), random(height));
  }
  buf = createImage(320, 240, RGB);
}

PImage buf;
int[][] globBuf;
float[][] globs = new float[50][3];
public final static float TIME = .05;
float ATTRACT_POWER = 1;
float INERT = .85;

void draw() {
  if(frameCount < 25) return;
  m.update();
//  int[] img = m.image(); //get the normal image of the camera
//  buf.beginDraw();
  buf.loadPixels();
//  for(int i=0;i<buf.width*buf.height;i++){ //loop through all the pixels
//    buf.pixels[i] = img[i]; //draw each pixel to the screen
//  }
  arraycopy(m.image(), buf.pixels);
  buf.updatePixels();
  
  
  globBuf = m.globBoxes();
  //draw the boxes
//  buf.stroke(255,0,0);
//  buf.noFill();
  for(int i = 0; i < globBuf.length; i++) {
//    buf.rect( globBuf[i][0] , globBuf[i][1] , globBuf[i][2] , globBuf[i][3] );
    globs[i][0] = (float)(globBuf[i][0]+globBuf[i][2]/2) * width / 320;
    globs[i][1] = (float)(globBuf[i][1]+globBuf[i][3]/2) * height / 240;
    globs[i][2] = (float)globBuf[i][2] * width / 320 * (float)globBuf[i][3] * height / 240;
  }
//  buf.endDraw();
  image(buf, 0, 0, width, height);
  for(int i =0 ; i < list.length; i++) {
    list[i].run(i);
    list[i].draw();
  }
  println(globBuf.length);
//  println(frameRate);
}

class Particle {
  float x, y, vx, vy, ax, ay;
  public Particle(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void run(int k) {
    for(int i = 0; i < globBuf.length; i++) {
      float dx = globs[i][0] - x,
            dy = globs[i][1] - y;
      float distSq = dx * dx + dy * dy;
      float d4 = distSq * distSq;
      vx += dx * globs[i][2] * (ATTRACT_POWER / distSq - 5000 / d4);
      vy += dy * globs[i][2] * (ATTRACT_POWER / distSq - 5000 / d4);
    }
    float REPEL = 45;
    for(int j = k+1; j < list.length; j++) {
      float dx = list[j].x - x,
            dy = list[j].y - y;
      float distSq = max(1, dx * dx + dy * dy),
            d3 = pow(distSq, 3/2f);
      vx -= REPEL * dx * ( 1 / distSq + 250 / d3);
      vy -= REPEL * dy * ( 1 / distSq + 250 / d3);
      list[j].vx -= REPEL * ( 1 / distSq + 250 / d3);
      list[j].vy -= REPEL * ( 1 / distSq + 250 / d3);
    }
    vx = vx * INERT + ax * TIME;
    vy = vy * INERT + ay * TIME;
    x = constrain(x + vx * TIME, 0, width);
    if(x == 0 || x == width) vx *= -1;
    y = constrain(y + vy * TIME, 0, height);
    if(y == 0 || y == height) vy *= -1;
  }
  
  void draw() {
    stroke(0);
    fill(255);
    ellipse(x, y, 15, 15);
  }
}
