Point a, b, c, loc;

void setup() {
  size(800, 600);
  a = new Point(random(width), random(height));  
  b = new Point(random(width), random(height));  
  c = new Point(random(width), random(height));
  loc = new Point(mouseX, mouseY);
  smooth();
}

void draw() {
  background(lerpColor(#052D98, color(0), .5));
  stroke(220);
  strokeWeight(1);
  fill(#0A1D62);
  ellipse(a.x, a.y, 25, 25);
  ellipse(b.x, b.y, 25, 25);
  ellipse(c.x, c.y, 25, 25);
  loc = new Point(mouseX, mouseY);
  float r1 = a.dist(loc);
  float r2 = b.dist(loc);
  float r3 = c.dist(loc);
  Circle cA = new Circle(a, r1);
  Circle cB = new Circle(b, r2);
  Circle cC = new Circle(c, r3);
  Point[] points1 = cA.intersects(cB);
  Point[] points2 = cA.intersects(cC);
  noFill();
  cA.draw();
  cB.draw();
  cC.draw();
  Point right = null;
  for(int i = 0; i < 2; i++) {
    for(int j = 0; j < 2; j++) {
      if(points1[i].equals(points2[j])) { right = points1[i]; break; }
    }
    if(right != null) break;
  }
  if(right != null) {
  fill(80, 120, 80);
  right.draw();
  }
}

class Circle {

  Point p;
  float r, r2;

  Circle( Point p, float pr ) {
    this. p = p;
   r = pr;
   r2 = r*r;
  }
  
  public Point[] intersects(Circle cB) {
    float dx = p.x - cB.p.x;
    float dy = p.y - cB.p.y;
    float d2 = dx*dx + dy*dy;
    float d = sqrt( d2 );
  
    if ( d>r+cB.r || d<abs(r-cB.r) ) return null; // no solution
    
  
    float a = (r2 - cB.r2 + d2) / (2*d);
    float h = sqrt( r2 - a*a );
    float x2 = p.x + a*(cB.p.x - p.x)/d;
    float y2 = p.y + a*(cB.p.y - p.y)/d;
  
    float paX = x2 + h*(cB.p.y - p.y)/d;
    float paY = y2 - h*(cB.p.x - p.x)/d;
    float pbX = x2 - h*(cB.p.y - p.y)/d;
    float pbY = y2 + h*(cB.p.x - p.x)/d;
    Point[] pts = new Point[2];
    pts[0] = new Point(paX, paY);
    pts[1] = new Point(pbX, pbY);
    return pts;
  }
  
  void draw() {
    ellipse(p.x, p.y, r*2, r*2);
  }
}

class Point {
  float x, y;
  
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  float dist(Point p) {
    return PApplet.dist(x, y, p.x, p.y);
  }
  
  void draw() {
    ellipse(x, y, 5, 5);
  }
    
  
  public boolean equals(Point p) {
    return (abs(p.x-x) < 1E-4) && (abs(p.y-y) < 1E-4);
  }
}
