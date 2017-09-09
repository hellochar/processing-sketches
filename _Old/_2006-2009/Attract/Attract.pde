Ball[] balls;
float attractPower = 1, inertia = .98;

boolean FAST = false;
float precision = 1;
final color bg = color(255);

int speed = 3;
boolean RATIO = false;
float factor = 1.8, mult = .1,
low = 10, high = 100;

void setup() {
  size(800, 600);
  smooth();
  balls = new Ball[100];
  if(RATIO) {
    for(int a = (int)(balls.length/factor); a < balls.length; a++) {
      balls[a] = new Ball(random(width), random(height), 0, 0, high+random(high*mult), (int)random(3), color(128+random(128), 64+random(128), random(128)));
    }
    for(int a = 0; a < (int)(balls.length/factor); a++) {
      balls[a] = new Ball(random(width), random(height), 0, 0, low+random(low*mult), (int)random(3), color(128+random(128), 64+random(128), random(128)));
    }
  }
  else {
    for(int a = 0; a < balls.length; a++) {
      balls[a] = new Ball(random(width), random(height), 0, 0, a * 2 * (low/high), (int)random(3), color(128+random(128), 64+random(128), random(128)));
    }
  }
//  balls[0] = new Ball(random(width), random(height), 0, 0, high*2, (int)random(8), color(128+random(128), 64+random(128), random(128)));
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
 inertia = .015
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
  inertia = .015
  --Rating--
    --RANDOM--
      low = 5, high = 45, factor = 3.3, mult = .2
      3 - complex
    --RATIO--
      low = 8.5, high = 28, factor = 2.2, mult = .5
      2 - stable (mostly), isolated instables
  --Notes--
    Very complex for such a simple power
    
float power(float me, int meAts, float other, int otherAts, float dist) { 
  return (me / other) / (me + other) * 6 / dist - 4 / (dist * dist);
}*/

/*With any abs difference, creates very complex. The balls order themselves, but the big ones always tend to run toward the corners, leaving 
  a trail of steadily thinning balls behind it. The trail makes a sharp turn and has the smallest of the balls somewhat near the beginning,
  like a U. The large balls, running around the corners, will be "checked" by the small balls each time they make a turn. Occasionally the 
  tail may completely stop the head, at which point it turns stable.
  count = 150
  inertia = .035
  
int speed = 3;
boolean RATIO = false;
float factor = 1.8, mult = .1,
low = 10, high = 100;

float power(float me, int meAts, float other, int otherAts, float dist) { 
  return dist / 500000*other - .5*abs(me-other) / (dist);
}*/


float power(float me, int meAts, float other, int otherAts, float dist) { 
  return dist / 80000 - (me+2*other) / (dist * dist) * (meAts & otherAts);
}

class Ball {
  float x, y, dx, dy, size;
  int ats, c;

  Ball(float x, float y, float dx, float dy, float size, int ats, int c) {
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
    dx *= inertia;
    dy *= inertia;
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
      fill(c & 0x30FFFFFF);
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
