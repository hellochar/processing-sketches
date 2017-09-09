int dotNum = 00;

Dot[] dotArray;
Dot temp;
Dot enumTemp;

float tx;
float ty;

int b;
int a;
World w = new World();

void setup() {
  size(500, 500);
  dotArray = new Dot[dotNum];
  for(a = 0; a < dotArray.length; a++) {
    dotArray[a] = new Dot(width/2, height/2-a, dotArray, a);
  }
}

void draw() {
  background(96);
  Dot temp;
  if(mousePressed) {
   
  if(mouseButton == LEFT) for(int a = 0; a < dotArray.length; a++) {
    temp = dotAt(a);
    temp.nx += random(-2, 2);
    temp.ny += random(-2, 2);
  }
  
  else if(mouseButton == RIGHT) {
    for(int a = 0; a < dotArray.length; a++) {
    temp = dotAt(a);
    temp.ny -= .8;
  }
  }
    
  }
  for(int a = 0; a < dotArray.length; a++) {
    temp = dotAt(a);
    temp.run();
  }
  for(int a = 0; a < dotArray.length; a++) {
    temp = dotAt(a);
    temp.update();
  }
  temp = new Dot(width/2, 1, dotArray, dotArray.length);
  temp.dx = random(-2, 2);
  temp.dy = random(-2, 2);
  dotArray = (Dot[])append(dotArray, temp);
//  println("update!");
}

Dot dotAt(int ind) {
  Dot enumTemp;
  if(ind < 0) ind = 0;
  if(ind > dotArray.length-1) ind = dotArray.length-1;
  enumTemp = dotArray[ind];
  enumTemp.index = ind;
  return enumTemp;
}

class Dot {
  
  float x;
  float y;
  float dx = 0;
  float dy = 0;
  float nx = 0;
  float ny = 0;
  Dot[] array;
  int index;
  
  
  Dot(float x, float y, Dot[] array, int index) {
    this.x = x;
    this.y = y;
    this.index = index;
  }
  
  void run() {
    for(int b = -1; b < 2; b++) {
      nx += dotAt(index+b).dx;
      ny += dotAt(index+b).dy;
    }
    nx /= 3;
    ny /= 3;
  }
  
  void move(float newx, float newy) {
    x += newx;
    y += newy;
    if(x < 0){ x = 1; nx *= -1; }
    else if(x > width){ x = width; nx *= -1; }
    if(y < 0){ y = 1; ny *= -1; }
    else if(y > height){ y = height; ny *= -1; }
    w.setpix(round(x), round(y), #FFFFFF);
  }
  
  void update() {
    move(nx, ny);
    dx = nx;
    dy = ny;
    nx = 0;
    ny = .1;
  }
}

//  The World class simply provides two functions, get and set, which access the
//  display in the same way as getPixel and setPixel.  The only difference is that
//  the World class's get and set do screen wraparound ("toroidal coordinates").
class World
{
  void setpix(int x, int y, int c) {
    if(x < 0) x = 0;
    else if(x > width-1) x = width-1;
    if(y < 0) y = 0;
    else if(y > height-1) y = height-1;
    set(x, y, c);
  }

  color getpix(int x, int y) {
    if(x < 0) x = 0;
    else if(x > width-1) x = width-1;
    if(y < 0) y = 0;
    else if(y > height-1) y = height-1;
    return get(x, y);
  }
}
