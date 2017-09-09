List<dot> dots;
float radius = 100;
float k = 3e4;

void setup() {
  size(500, 500);
  dots = new LinkedList();
  dots.add(new dot(1, random(2*PI)));
  dots.add(new dot(1, random(2*PI)));
  dots.add(new dot((2+sqrt(2))*cos(PI/8), random(2*PI)));
}


void draw() {
  background(0);
  noFill();
  stroke(255, 128);
  ellipse(width/2, height/2, 2*radius, radius*2);
  for(dot d : dots) {
    d.run();
  }
  for(dot d : dots) {
    d.update();
  }
  fill(255, 0, 0); noStroke();
  for(dot d : dots) {
    d.draw();
  }
}


class dot {
  float charge;
  float x, y;
  float nx, ny;
  int col;
  
  dot(float charge, float ang) {
    this.charge = charge; setLoc(ang);
    col = color(random(255), random(255), random(255));
  }
  
  void setLoc(float newAng) {
    x = width/2 + radius*cos(newAng);
    y = height/2 + radius*sin(newAng);
  }
  
  void draw() {
    noStroke();
    fill(col);
    ellipse(x, y, 10, 10); stroke(255);
    line(width/2, height/2, x, y);
//    fill(255);
//    text(dots.indexOf(this), x, y);
  }
  
  void run() {
    nx = x; ny = y;
    for(dot d : dots) {
      if(d == this) continue;
      PVector force = forceBy(d);
      stroke(d.col);
      line(x, y, x+100*force.x, y+100*force.y);
      nx += force.x;
      ny += force.y;
    }
  }
  
  void update() {
    //calculate new angle
    float newAng = atan2(ny - height/2, nx - width/2);
    //set locations.
    setLoc(newAng);
  }
  
  PVector forceBy(dot d) {
    PVector offset = new PVector(x - d.x, y - d.y);
    PVector offsetCopy = offset.get();
    offsetCopy.normalize();
    offsetCopy.mult(k*charge * d.charge / sq(offset.mag()));
    return offsetCopy;
  }
}
