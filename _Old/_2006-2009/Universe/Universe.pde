import zhang.*;

/* Universal Gravitation Simulator
   Version 1.0, programmed by Jill Jackson
   
  No copyright or whatever, reuse my code!

  Left click to zoom in (on the center, zooming in on wher you click is being added soon)
  Right click to zoom out
  move the mouse to the edges to scroll
  
  press =/- to zoom in/out (yes that's an equal sign)
  up/down/left/right to move the screen
  
  This is not nearly an accurate representation of the real laws of gravitation, only an estimate. I can get a few "solar systems" to pop up,
  which I consider pretty good. A really accurate representation of gravitation of masses would require massive amounts of calculations.
  Notice that most of the time, after an explosion, the balls just fly away into infinity, never to come back. An accurate representation
  would have that happening at insane speeds. This is good for now :D


*/
//final int deactivateDist = 1500000;

LinkedList list;
Camera cam;

void setup() {
  size(500, 500);
//  textFont(loadFont("Arial-BoldMT-20.vlw"), 14);
  cam = new Camera(this);
  background(0);
  list = new LinkedList();
  smooth();
  for(int a = 0; a < 50; a++) {
    float x = random(width);
    float y = random(height);
//    float ang = atan2(y, x);
//    float pow = dist(x, y, 0, 0) * .0;
    list.add(new Ball(x, y, 0, 0, random(10, 20)));
  }
//  textAlign(LEFT, TOP);
  noStroke();
  smooth();
}

Link l;
Ball b;
void draw() {
  if(keyPressed) {
    if(key == 'e') {
      b = (Ball)list.first().data;
      b.explode();
    }
  }
  float tx =0, ty=0;
  if(mouseX < width/5) {
    tx += (width/5 - mouseX)*.1;
  }
  else if(mouseX > 4*width/5) {
    tx -= (mouseX-4*width/5)*.1;
  }
  if(mouseY < height/5) {
    ty += (height/5 - mouseY)*.1;
  }
  else if(mouseY > 4*height/5) {
    ty -= (mouseY-4*height/5)*.1;
  }
  cam.translate(tx, ty);
  background(255);
  fill(color(0));
  cam.apply();
  l = list.first();
  while(l != null) {
    b = (Ball)l.data;
    b.run(l.next);
    l = l.next;
  }
  l = list.first();
//  int k = 0;
  while(l != null) {
    b = (Ball)l.data;
    b.update();
    l = l.next;
//    k++;
  }
//  println(k);
}

class Ball {
  float x, y, dx, dy;
  private float radius;
  float mass;
  boolean alive = true;
  boolean explode = false;
  float expDx, expDy;
  Ball b;
//  boolean active = true;

  float k;

  Ball(float x, float y, float dx, float dy, float radius) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    setRadius(radius);
  }

  void setRadius(float r) {
    radius = r;
    mass = PI*r*r;
  }

  float radius() {
    return radius;
  }

  float mass() {
    return mass;
  }

  void assimilate(Ball b) {
    b.alive = false;
    setRadius(radius() + sqrt(b.mass()/PI));
    k = b.mass()/mass();
    dx += b.dx*k;
    dy += b.dy*k;
    //    setRadius(dist(radius(), b.radius()));
  }

  void explode() {
    alive = false;
    explode = true;
    expDx = dx;
    expDy = dy;
  }

  float pow, ang;
//  boolean curActivate;
  void run(Link l) {
//    curActivate = false;
    while(l != null) {
      Ball b = (Ball)l.data;
      k = dist(x, y, b.x, b.y);
//      if(k < deactivateDist & !curActivate & b.active) { b.active = true; curActivate = true; }
      if(k > (radius()+b.radius())/2) {
        pow = 25 * b.mass() / (k*k);
        ang = atan2(b.y-y, b.x-x);
        dx += pow*cos(ang);
        dy += pow*sin(ang);
        pow = pow / b.mass() * mass();
        b.dx -= pow*cos(ang);
        b.dy -= pow*sin(ang);
      }
      else {
        k = mass()/b.mass();
        if(k > 6) {
          if(b.mass() > 500) b.explode();
          else assimilate(b);
        }
        else if(k < 1f/6) {
          if(mass() > 500) explode();
          else b.assimilate(this);
        }
        else if(mass() > 250 & b.mass() > 250) {
          explode();
          b.explode();
        }
      }
      l = l.next;
    }
//    if(!curActivate) active = false;
  }

  void update() {
    if(explode) {
      float radex = radius;
      float rx, ry, ang;
      while(radex > 0) {
        float r = min(radex, 1+random(radex/25, radex/10));
        radex -= r;
        rx = random(-radius, radius);
        ry = random(-radius, radius);
        ang = atan2(ry, rx);
        k = r*r*PI;
        list.add(new Ball(x+rx, y+ry, (mass*sin(ang)+radius*expDx)/k/4, (mass*cos(ang)+radius*expDy)/k/4, r));
      }
    }
    if(!alive) {
      list.remove(this);
      return;
    }
    //    println(x+", "+y+": "+dx+", "+dy);
    x += dx;
    y += dy;
    //    x = constrain(x + dx, 0, width*1);
    //    y = constrain(y + dy, 0, height*1);
    //    if(x == 0 | x == width*1) dx *= -1;
    //    if(y == 0 | y == height*1) dy *= -1;
//    if(active)
      fill(color(2*dist(0, 0, dx, dy), 0, 255-mass()/100));
//    else {
//      fill(color(140, 196, 120));
//    }
    k = max(radius, 2/cam.getScale());
    ellipse(x, y, k, k);
  }

}
