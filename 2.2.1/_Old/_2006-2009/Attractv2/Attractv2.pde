Ball[] balls;
float attractPower = 4, drag = .02;

boolean FAST = false;
float precision = 2;
final color bg = color(255);
final int RANDOM = 3, SPREAD = 2, RATIO = 1, ATS = 8, atsColors[] = {
  color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)};


int speed = 4;
int mode = RATIO;
float factor = 2.5, mult = 2.2,
low = 6.5, high = 20;

int colorMode = RANDOM;

void setup() {
  size(800, 600);
  smooth();
  drag = 1.0-drag;
  balls = new Ball[75];
  float size = (high+low)/2, ats;
  int c = color(0);
  for(int a = 0; a < balls.length; a++) {
    ats = random(3);
    switch(mode) {
    case RATIO:
      if(a < balls.length/factor) size = low+random(low*mult);
      else size = high+random(high*mult);
      break;
    case SPREAD:
      size = lerp(low, high, (float)a/(balls.length-1.0));
      break;
    case RANDOM:
      size = random(low, high);
      break;
    }
    switch(colorMode) {
    case RANDOM:
      c = color(128+random(128), 64+random(128), random(128));
      break;
    case ATS:
      c = lerpColor(atsColors[(int)ats], atsColors[(int)ats+1], ats%1);
      break;
    }
    balls[a] = new Ball(random(width), random(height), 0, 0, size, ats, c);
  }
}

void draw() {
  background(bg);
  if(FAST)
    loadPixels();
  for(int z = 0; z < speed; z++) {
    for(int a = 0; a < balls.length; a++) {
      balls[a].run();
    }
    for(int a = 0; a < balls.length; a++) {
      balls[a].update();
    }
  }
  for(int a = 0; a < balls.length; a++) {
    balls[a].show();
  }
  if(FAST)
    updatePixels();
}

void pown() {
  if(!FAST)
    loadPixels();
  for(int x = 0; x  <width; x++) {
    for(int y = 0; y < height; y++) {

    }
  }
  if(!FAST)
    updatePixels();
}



/*Small balls tend to group and then start moving toward larger balls, which are then repelled. The small balls go somewhere else - usually in
 a circular manner.
 --Stats--
 power = 1
 count = 75
 drag = .015
 --Rating--
 --RATIO--
 low = 5, high = 25, factor = 3.3, mult = .2
 3 - complex
 --RANDOM--
 2 - stable
 --Notes--
 Direction of circle swaps every several rotations. Instability increases as ball size decreases
 
 float power(float me, int meAts, float other, int otherAts, float dist) {
 return ( 3 * (other / me ) / (me + other) / dist - 3 / (dist * dist) - 5 / (dist * dist * dist));
 }*/

/*Ameoba-like movement, seemingly random but with purpose. All balls will group together; bigger ones on the inside. Location of 
 the small balls dictate the direction of the group. Will split, stretch, and reform, and occasionally there will be a small ball
 that leads a slightly bigger ball out of the group and manages to maintain isolation for some time. These splits may turn into corner
 huggers.
 --Stats--
 power = 1
 count = 75
 drag = .015
 --Rating--
 --RANDOM--
 low = 5, high = 45, factor = 3.3, mult = .2
 3 - complex
 --RATIO--
 low = 8.5, high = 28, factor = 2.2, mult = .5
 2 - stable (mostly), isolated instables
 --Notes--
 Very complex for such a simple power
 */
float power(float me, float meAts, float other, float otherAts, float dist) { 
  return pow(me / other, 1.1) / (me + other) * 6 / dist - 4 / (dist * dist);
}

/*With any abs difference, creates very complex. The balls order themselves, but the big ones always tend to run toward the corners, leaving 
 a trail of steadily thinning balls behind it. The trail makes a sharp turn and has the smallest of the balls somewhat near the beginning,
 like a U. The large balls, running around the corners, will be "checked" by the small balls each time they make a turn. Occasionally the 
 tail may completely stop the head, at which point it turns stable.
 count = 150
 drag = .035
 
 int speed = 3;
 boolean RATIO = false;
 float factor = 1.8, mult = .1,
 low = 10, high = 100;
 
 float power(float me, int meAts, float other, int otherAts, float dist) { 
 return dist / 500000*other - .5*abs(me-other) / (dist);
 }
 */


/*
float power(float me, int meAts, float other, int otherAts, float dist) { 
 //  return dist / 80000 - (me+other) / (dist * dist) * (meAts ^ otherAts) - 200 / (dist * dist * dist);
 return dist / 15000 - .04*(me+other) / dist - 8*(meAts^otherAts) / (dist * dist);
 }*/




class Ball {
  float x, y, dx, dy, size, ats;
  int c;

  Ball(float x, float y, float dx, float dy, float size, float ats, int c) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.size = size;
    this.ats = ats;
    this.c = c;
  }

  void run() {
    for(int a = 0; a < balls.length; a++) {
      Ball b = balls[a];
      if(b == this) continue;
      float ang = atan2(b.y-y, b.x-x), 
      p = attractPower*power(size, ats, b.size, b.ats, dist(x, y, b.x, b.y));
      dx += p * cos(ang);
      dy += p * sin(ang);
    }
  }

  void update() {
    dx *= drag;
    dy *= drag;
    x = constrain(x+dx, size/2, width-size/2);
    y = constrain(y+dy, size/2, height - size/2);
    if(x == size/2 | x == width - size/2) {
      dx *= -1;
    }
    else if(y == size/2 | y == height - size/2) {
      dy *= -1;
    }
  }

  float mass() {
    return size * size * size / 6;
  }

  void show() {
    if(FAST) {
      float jumps = TWO_PI * precision / (2 * PI * size / 2);
      for(float r = 0; r < TWO_PI; r += jumps) {
        setPixAt(x + cos(r) * size / 2, y + sin(r) * size / 2, c);
      }
    }
    else {
      fill(c & 0x60FFFFFF);
      stroke(c);
      ellipse(x, y, size, size);
    }
  }
}

void setPixAt(float x, float y, int c) {
  if(x < 0 | x > width-1 | y < 0 | y > height-1) return;
  if(pixels[(int)y*width+(int)x] != bg) return;
  pixels[(int)y*width+(int)x] = c;
}
