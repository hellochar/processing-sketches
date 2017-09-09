float[] x;
float[] y;
float[] dx;
float[] dy;
int num = 20000;
int a;
float ang;
float pow = 1;
//static final int sWidth = 500,
//sHeight = 500;, inset = 100;
//PGraphics colorArray;

static final color white = 0xFFFFFFFF, black = 0xFF000000;
//color c0 = color(255, 255, 255), c1 = color(0, 0, 0), cCurrent = c0;
//float lerp = 0;

//void initColorArray() {
//  
//}

void setup() {
//  size(sWidth, sHeight+inset);
  size(500, 500);
//  initColorArray();
  x = new float[num];
  y = new float[num];
  dx = new float[num];
  dy = new float[num];
  reset();
}

void reset() {
  for( a = 0 ; a < num; a++) {
    x[a] = a*float(width)/num;
    y[a] = height/2;
  }
  for(a = 0 ;a < num; a++) {
    dx[a] = dy[a] = 0;
  }
  background(0);
}


void mousePressed() {
  if(mouseButton == CENTER)
    reset();
}

void draw() {
//  if(mouseX > 0 & mouseX < width & mouseY > 0 & mouseY < height) {
  if(mousePressed & mouseButton != CENTER) {
    float k = pow;
    if(mouseButton == LEFT) k *= pow;
    else if(mouseButton == RIGHT) k *= -pow;
    for(a = 0; a < num; a++) {
      ang = atan2(mouseY-y[a], mouseX-x[a]);
      dx[a] += k*cos(ang);
      dy[a] += k*sin(ang);
    }
  }
//  }
  loadPixels();
  //uncolor your previous places
  for(a = 0; a < num; a++) {
    setAt(x[a], y[a], black);
  }
  //color new places
  for(a = 0; a < num; a++) {
    x[a] += dx[a] *= .98;
    y[a] += dy[a] *= .98;
    setAt(x[a], y[a], white);
  }
  updatePixels();
//  stroke(white);
//  line(0, sHeight, sWidth, sHeight);
//  line(sWidth / 2, sHeight, sWidth/2, height);
//  showColorArray(0, sHeight, width/2, inset);
}

void keyPressed() {
  if(key == ' ') {
    for(a = 0 ;a < num; a++) {
      dx[a] = dy[a] = 0;
    }
  }
  else if(key == 'r') {
    reset();
  }
}

//void showColorArray(int x, int y, int w, int h) {
//}

void setAt(int x, int y, int c) {
  if(x < 0 | x > width-1 | y < 0 | y > height-1) return;
  pixels[y*width+x] = c;
}

void setAt(float x, float y, int c) {
  setAt(int(x), int(y), c);
}
