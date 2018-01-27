float x, y, nx, ny;
float r = 4.0/8;
int n = 5;
float[] xVertexPoints;
float[] yVertexPoints;

void setup() {
  size(400, 400);
  x = random(width);
  y = random(height);
  stroke(255);
  noLoop();
  r = 1-r;
  calculatePoints();
}

void calculatePoints() {
  xVertexPoints = new float[n];
  yVertexPoints = new float[n];
  float i = PI*2/n;
  float x = width/2;
  float y = height/2;
  float s = width/4;
  float t = height/4;
  for(int a = 0; a < n; a++) {
    xVertexPoints[a] = x+cos(a*i-PI/2)*s;
    yVertexPoints[a] = y+sin(a*i-PI/2)*t;
  }
}

void keyPressed() {
  if(keyCode == LEFT) {
    n--;
  }
  else if(keyCode == RIGHT) {
    n++;
  }
  calculatePoints();
  redraw();
}

void mousePressed() {
  if(mouseButton == LEFT)
  r += .1;
  else r-= .1;
  redraw();
}

void draw() {
  background(0);
  int rIndex;
  for(int a = 0; a < 50000; a++) {
  point(x, y);
  rIndex = int(random(n));
  nx = xVertexPoints[rIndex];
  ny = yVertexPoints[rIndex];
  x += (nx-x)*r;
  y += (ny-y)*r;
  }
/*  beginShape();
  for(int a = 0; a < n; a++) {
    vertex(xVertexPoints[a], yVertexPoints[a]);
  }
  endShape(CLOSE);*/
}
