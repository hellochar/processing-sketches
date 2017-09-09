float r = 2.3;

float func(float value) {
//  return r * value * (1 - r * value);
//  return r * value * value - 1;
//  return sqrt(value+r)-sqrt(value*r);
//  return r * value * (1 - value);
  return r + value - value * value;
}

float[] longtermArr = new float[100];
void longterm(float init) {
  for(int x = 0; x < longtermArr.length; x++) {
    longtermArr[x] = init = func(init);
  }
}

void setup() {
  size(800, 400);
  background(0);
  frameRate(100);
}

float rmin = 0,
      rmax = 2,
      xmin = -1,
      xmax = 5;


void draw() {
  if(frameCount > width) {
    
  }
  else {
    r = map(frameCount, 0, width, rmin, rmax);
    longterm(random(1));
    stroke(255, 40);
//    stroke(0x80FFffFF);
    for(float i : longtermArr) {
//      point(frameCount, map(i, 0, 1, height*3f/4, height/4));
      line(frameCount, map(i, xmin, xmax, height, 0),frameCount+1, map(i, xmin, xmax, height, 0));
    }
  }
  if(mousePressed) println("r: "+map(mouseX, 0, width, rmin, rmax)+", x: "+map(mouseY, height, 0, xmin, xmax));
}
