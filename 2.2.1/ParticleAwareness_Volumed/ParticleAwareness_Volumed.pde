import processing.opengl.*;

import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

//  R.A. Robertson 2011.10 ~ www.rariora.org ~
//  Study derived from "collision test" www.kaubonschen.com
//  credit to Kim Asendorf http://openprocessing.org/visuals/?visualID=3520
 
Ball[] myBall;
int ballAmount = 50;
int distance = 100;
float distBalls, lineWeight, fr;
int d = 2;  // Diameter.
boolean toggleLoop = true;
PeasyCam cam;
LinkedList<State> states = new LinkedList();
int MAXSTATES = 100;

float zStride = 2;

class State {
//  float[] xs = new float[myBall.length], ys = new float[myBall.length];
  HashMap<Integer, Line> lines = new HashMap();
  
  void draw() {
//    for(int i = 0; i < myBall.length; i++) {
//      noStroke();
//      ellipse(xs[i], ys[i], d, d);
//    }
//    for(Line l : lines) {
//      l.draw();
//    }
  }
}
class Line {
  int key;
  float x1, y1, x2, y2, weight;
  public Line(Ball b1, Ball b2, float weight) {
    x1 = b1.x;
    y1 = b1.y;
    x2 = b2.x;
    y2 = b2.y;
    this.weight = weight;
    key = b1.hashCode() ^ b2.hashCode();
  }
  
//  void draw() {
//    strokeWeight(weight);
//    stroke(weight*5, weight, weight);
//    line(x1, y1, x2, y2);
//  }
}
 
void setup() {
  size(800, 400, OPENGL);
  cam = new PeasyCam(this, width/2, height/2, zStride * MAXSTATES/2, 500);
  //  size(screen.width, screen.height);
  background(255);
  fill(0);
  smooth();
 
  //class setup
  myBall = new Ball[ballAmount];
  for (int i = 0; i < ballAmount; i++) {
    myBall[i] = new Ball();
    myBall[i].setup();
  }
}
 
void draw() {
  println(frameRate);
  background(0);
//  lights();
  directionalLight(255, 255, 255, 1, 0, 0);
  ambientLight(80, 80, 80);
//  noStroke();
//  fill(255, 2.0);
//  rect(0, 0, width, height);
  State cur = new State();
  for (int i = 0; i < ballAmount; i++) {
//    cur.xs[i] = myBall[i].x;
//    cur.ys[i] = myBall[i].y;
    myBall[i].collide();  // Physics collision.
    myBall[i].step();
    fill(255, 0, 0);
    //    myBall[i].drawBall();  // Optional node display.
    for (int j = 0; j < i; j++) {
      if (i != j) {
        distBalls = dist(myBall[i].x, myBall[i].y, myBall[j].x, myBall[j].y);
 
        if (distBalls <= distance) {  // Use this block for proximal lines.
          lineWeight = 10/distBalls;
          
//          stroke(lineWeight*5, lineWeight, lineWeight);
//          strokeWeight(lineWeight);
//          line(myBall[i].x, myBall[i].y, myBall[j].x, myBall[j].y);

          Line l = new Line(myBall[i], myBall[j], lineWeight);
          cur.lines.put(l.key, l);
        }
        //        stroke(0, 10);  // Use this instead for global lines.
        //        line(myBall[i].x, myBall[i].y, myBall[j].x, myBall[j].y);
 
        //        if (distBalls <= d) {  // Simple collision reset.
        //          myBall[i].setInc();  // If using, comment out collide().
        //          myBall[j].setInc();
 
        //        }
      }
    }
  }
  if(frameCount % 1 == 0) {
    states.addFirst(cur);
    if(states.size() > MAXSTATES) states.removeLast();
  }
  for(int i = 0; i < states.size(); i++) {
    State s = states.get(i);
    translate(0, 0, zStride);
    s.draw();
    fill(255, 255, 0);
    noStroke();
//    stroke(255, 255, 0);
    if(i != 0) {
      State prev = states.get(i-1);
      for(Line l : s.lines.values()) {
        if(prev.lines.containsKey(l.key)) {
          Line lprev = prev.lines.get(l.key);
          beginShape(TRIANGLE_STRIP);
          vertex(l.x1, l.y1, 0);
          vertex(l.x2, l.y2, 0);
//          if(random(1) < .5)
//          else
            vertex(lprev.x1, lprev.y1, -zStride);
            vertex(lprev.x2, lprev.y2, -zStride);
          endShape();
        }
      }
//      for(int j = 0; j < myBall.length; j++) {
//        line(s.xs[j], s.ys[j], 0, states.get(i-1).xs[j], states.get(i-1).ys[j], -zStride);
//      }
    }
  }
}

void keyPressed() {
  if (key == 't') {
    if (toggleLoop) {
      noLoop();
      toggleLoop = false;
    }
    else {
      loop();
      toggleLoop = true;
    }
  }
  if (key == 'r') {
    setup();
  }

}
 
//THE CLASS
class Ball {
  float x, y, incX, incY;
 
  void setup() {
    x = random(width);
    y = random(height);
    setInc();
  }
 
  //speed
  void setInc() {
    incX = random(-8, 8);
    incY = random(-8, 8);
  }
 
  //the ball
  void drawBall() {
    noStroke();
    ellipse(x, y, d, d);
  }
 
  //direction
  void step() {
    if (x >= width - d/2 || x <= 0 + d/2) {
      incX = -incX;
    }
    if (y >= height - d/2 || y <= 0 + d/2) {
      incY = -incY;
    }
    x = x + incX;
    y = y + incY;
  }
 
  // Optional Collision Physics a la "Bouncy Bubbles."
  float dx, dy, distance, minDist, angle, targetX, targetY, ax, ay;
  float friction = 1.0004, frictionX = friction, frictionY = friction;
  int diameter = d;
  void collide() {
    for (int i = 0; i < ballAmount; i++) {
      dx = myBall[i].x - x;
      dy = myBall[i].y - y;
      distance = sqrt(dx*dx + dy*dy);
      minDist = myBall[i].diameter/2 + diameter/2;
      if (distance < minDist) {
        angle = atan2(dy, dx);
        targetX = x + cos(angle) * minDist;
        targetY = y + sin(angle) * minDist;
        ax = (targetX - myBall[i].x);
        ay = (targetY - myBall[i].y);
        incX -= ax;
        incY -= ay;
        myBall[i].incX += ax;
        myBall[i].incY += ay;
        incX /= frictionX;
        incY /= frictionY;
        //     int f = frameCount;
        //     println(f + "    " + incX);
      }
    }
  }
}

