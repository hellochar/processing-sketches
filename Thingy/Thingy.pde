Segment midpoint;
List<Point> points;

void setup() {
  size(800, 600);
  midpoint = new Segment(25, PI/90);
  points = new LinkedList();
}

boolean started = false;

void draw() {
//  if(started) {
    midpoint.run();
//    if(midpoint.atZero()) end();
//  }
  
  background(0);
  stroke(255);
  smooth();
  translate(width/2, height/2);
  rotate(-PI/2);
  midpoint.show();
  resetMatrix();
  
  strokeWeight(1);
  stroke(255, 0, 0); noFill();
  beginShape();
  for(Point p : points) {
    vertex(p.x, p.y);
  }
  endShape();
}

void keyPressed() {
  midpoint.add(new Segment(25, 1.2 * PI/180));
}

void mousePressed() {
//  if(started) end();
//  else begin();
  begin();
}

void begin() {
  started = true;
  points.clear();
  midpoint.reset();
}

void end() {
  started = false;
  midpoint.reset();
}

int idGlob = 0;

class Segment {
  float len; //pixels
  float speed; //delta radians per iteration
  Segment next;
  float angle;
  int id = idGlob++;
  
  Segment(float l, float s) {
    len = l;
    speed = s;
    angle = 0;
  }
  
  void reset() {
    angle = -speed/2;
    if(next != null) next.reset();
  }
  
  void add(Segment p) {
    if(next != null) next.add(p);
    else {
      next = p;
    }
  }
  
  boolean atZero() {
    boolean me = angle%TWO_PI < 3*speed/2; //a very small value
    if(next != null) {
      return me && next.atZero();
    }
    else return me;
  }
  
  void run() {
    angle += speed;
    if(next != null) next.run();
  }
  
  void show() {
    float nx = len*cos(angle),
          ny = len*sin(angle);
    strokeWeight(3);
    line(0, 0, nx, ny);
    translate(nx, ny);
    rotate(angle);
    if(next != null) next.show();
    else {
      points.add(new Point(screenX(0, 0), screenY(0, 0)));
    }
    println(id+": angle: "+degrees(angle));
  }
  
}
