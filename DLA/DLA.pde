int black = color(0);

int x, y;
int boundsX = 200, boundsY = 200;
boolean[] data = new boolean[boundsX*boundsY];

void setup() {
  size(600, 600);
  background(black);
  x = boundsX/2;
  y = boundsY/2;
  putDot(boundsX/2, boundsY/2);
  colorMode(HSB);
  noStroke(); smooth();
}

void putDot(int x, int y) {
  data[y*boundsX+x] = true;
}

boolean hasDot(int x, int y) {
  return data[y*boundsX+x];
}

boolean inBounds(int x, int y) {
  return x >= 0 && x < boundsX && y >= 0 && y < boundsY;
}

int getColor() {
  return color((frameCount/2)%255, 255, 255);
}

int offset = 5;

void draw() {
  for(int i = 0; i < 100; i++)
    step();
  println(frameRate);
}

boolean attempt() {
  int s, t, lastS, lastT;
  lastS = s = x + randInt(-offset, offset);
  lastT = t = y + randInt(-offset, offset);
  do {
    lastS = s;
    lastT = t;
    s += randInt(-1, 1);
    t += randInt(-1, 1);
    if(!inBounds(s, t)) return false;
//    println(t+", "+s);
  }while(hasDot(s, t));
  putDot(s, t);
  fill(getColor());
  ellipse(map(s, 0, boundsX, 0, width), map(t, 0, boundsY, 0, height), width/boundsX, height/boundsY);
  x = lastS; y = lastT;
  return true;
}

// returns random int in [neg, pos]
int randInt(int neg, int pos) {
  return floor(random(neg, pos+1));
}

void step() {
  while(!attempt()) {}
}

