import java.awt.geom.*;

Line[] lines;
int c;

float x, y, dx, dy;
PFont f;
void setup() {
  size(400, 400);
  c = 0;
  lines = new Line[50];
  f = loadFont("AbadiMT-Condensed-20.vlw");
  x = 25;
  y = 25;
  dx = 10;
}

void draw() {  
  background(204);
  stroke(color(0));
  
  dy += .09;
  for(int a = 0; a < c; a++) {
    Line l1 = lines[a];
    for(int b = 0; b < c; b++) {
      Line l2 = lines[b];
      if(a == b) continue;
      float inter = l1.intercept(l2);
      if(inter != 0) ellipse(inter, l1.y(inter), 8, 8);
    }
    l1.show();
    if(l1.intercept(x, y, 15)) {
      float pow = sqrt(dx*dx+dy*dy);
      float ang = (l1.ang-atan2(dy, dx));
      dx = pow*cos(ang);
      dy = pow*sin(ang);
    }
    //    Line unL = new Line(mouseX, mouseY, -1/l1.slope);
    //  unL.show();
  }

  x = Math.max(0, Math.min(x+dx, width));
  y = Math.max(0, Math.min(y+dy, height));
  if(x == 0 | x == width) dx *= -1;
  if(y == 0 | y == height) dy *= -1;


  ellipse(x, y, 10, 10);
  if(dragged) {
    line(x2, y2, mouseX, mouseY);
  }
}

boolean dragged;
int x2, y2;

void mousePressed() {
  if(mouseButton == LEFT) {
    x2 = mouseX;
    y2 = mouseY;
    dragged = true;
  }
}

void mouseReleased() {
  if(mouseButton == LEFT & dragged) {
    dragged = false;
    lines[c] = new Line(x2, y2, mouseX, mouseY);
    c++;
  }
}

class Line {
  float ang;
  float slope;
  int hash;
  
  Point2D.Float minP, maxP;

  float ycept;

  Line(float x, float y, float x2, float y2) {
    Point2D.Float p1 = new Point2D.Float(x, y);
    Point2D.Float p2 = new Point2D.Float(x2, y2);
    
    if(x < x2) {
      minP = p1;
      maxP = p2;
    }
    else {
      minP = p2;    
      maxP = p1;
    }
    setupData();
  }
  
  void setupData() {    
    ang = atan2(maxP.y-minP.y, maxP.x-minP.x);
    slope = (maxP.y-minP.y)/(maxP.x-minP.x);
    ycept = minP.y - slope * minP.x;    
  }
  
  void setPointTo(Point2D.Float which, float x) {
    which.setLocation(x, y(x));
  }

  Line(float x, float y, float slope) {
    this.slope = slope;
    
    minP = new Point2D.Float(x - 500, y - 500 * slope);
    ycept = minP.y - slope * minP.x;
    maxP = new Point2D.Float(0, 0);
    setPointTo(maxP, x+1000);
    
    setupData();
  }
  
  boolean intercept(float px, float py, float size) {
    if(px < minP.x | px > maxP.x) return false;

    float closeX, closeY;
    float unSlope = -1/slope;
    Line unL = new Line(px, py, unSlope);
    unL.show();
    float ix = intercept(unL);
    if(dist(ix, y(ix), px, py) < size) {
      return true;
    }
    return false;
  }

  //returns the x value of the intercept of this function and the other funciton
  float intercept(Line l2) {
    float ret = (l2.ycept-ycept)/(slope-l2.slope);
    if(ret < minP.x | ret > maxP.x | ret < l2.minP.x | ret > l2.maxP.x) return 0;
    return ret;
  }

  void show() {
//    textFont(f);
//    text(degrees(ang)+", "+slope, minP.x, minP.y);
    line(minP.x, minP.y, maxP.x, maxP.y);
  }

  float y(float x) {
    return slope*x+ycept;
  }

}
