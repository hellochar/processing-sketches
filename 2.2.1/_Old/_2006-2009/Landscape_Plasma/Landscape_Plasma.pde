Point[][] map;
int size = 6;
int w;
int dist;
float roughness = .1;
int[] colorBands;
float m = 1000;
PGraphics dimension3;
PImage overhead;

void setup() {
  size(600, 600, P3D);
  w = (int)pow(2, size);
  map = new Point[w+1][w+1];  
  colorBands = new int[(int)m];  
  float r, g, b;
  for(int x = 0; x < m; x++) {
    r = (x-500)/m*255*m/(m-500);
    g = x/m*255*900/(900-350);
    b = abs(500-x)/500*255;
    colorBands[x] = color(r, g, b);
  }
  dist = w;
//  noLoop();
  dimension3 = createGraphics(600, 1000, P3D);
  recalc();
}

void recalc() {
  dist = w;
  new Point(0, 0, random(1));
  new Point(0, w, random(1));
  new Point(w, w, random(1));
  new Point(w, 0, random(1));
    for(int a = 0; a < size; a++) {
      calculateNext();
    }
  overhead = createOverhead();
}

PImage createOverhead() {
  PImage img = createImage(w, w, RGB);
  img.loadPixels();
  for(int x = 0; x < w; x++) {
    for(int y = 0; y < w; y++) {
      if(map[x][y] != null) {
        p = map[x][y];
        img.pixels[p.y*img.width+p.x] = getColorAt(p.val);
      }
    }
  }
  img.updatePixels();
  return img;
}

Point p, g;
float mult = 6;

void draw() {
//  background(255, 145, 12);
//  mult = 1+(mouseX/(float)width)*3;
  background(0);
  pushMatrix();
  dimension3.beginDraw();
  dimension3.camera(dimension3.width/2.0, 157, 414, dimension3.width/2.0, dimension3.height, 0, 0, 1, 0);
  dimension3.translate(width/2-80+width/2-mouseX, -200, -200);
  dimension3.background(0);
  for(int x = 0; x < w; x++) {
    for(int y = 0; y < w; y++) {
        p = map[x][y];
        if(x > 0) {
          g = map[x-1][y];
          dimension3.stroke((getColorAt(p.val)+getColorAt(g.val))/2);
          dimension3.line(p.x*mult, dimension3.height-100*p.val, p.y*mult, g.x*mult, dimension3.height-100*g.val, g.y*mult);
        }
        if(y > 0) {
          g = map[x][y-1];
          dimension3.stroke((getColorAt(p.val)+getColorAt(g.val))/2);
          dimension3.line(p.x*mult, dimension3.height-100*p.val, p.y*mult, g.x*mult, dimension3.height-100*g.val, g.y*mult);
        }
      }
    }
//    dimension3.stroke(color(255));
  //  dimension3.line(0, 0, 0, mouseX, mouseY, 0);
    dimension3.endDraw();
    popMatrix();
    image(dimension3, 0, 0);
    if(w > 100) {
      image(overhead, width-w, 0);
    }
    else image(overhead, width-100, 0, 100, 100);
}

int getColorAt(float val) {
  return colorBands[int(val*(m-1))];
}

void mousePressed() {
  if(mouseButton == LEFT)
    recalc();
  else println(mouseX+", "+mouseY);
  redraw();
}

void calculateNext() {
  if(dist < 1) return;
  for(int x = 0; x < w; x += dist) {
    for(int y = 0; y < w; y += dist) {
//      println("x: "+x+", y: "+y+" -- dist: "+dist);
      createPointsFrom(map[x][y], map[x+dist][y], map[x+dist][y+dist], map[x][y+dist]);
    }
  }
//  print("dist changed from "+dist+" to ");
  dist /= 2;
//  println(dist);
}

void createPointsFrom(Point p1, Point p2, Point p3, Point p4) {
//      println("calculating for: "+p1+", "+p2+", "+p3+", "+p4);
      new Point(p1, p2);
      new Point(p2, p3);
      new Point(p3, p4);
      new Point(p4, p1);
      new Point(p1, p2, p3, p4);  
}

class Point {
  float val;
  int x, y;
  Point(int x, int y, float val) {
    this.x = x;
    this.y = y;
    map[x][y] = this;
//    println("added: "+x+", "+y);
    this.val = val;
  }

  Point(Point p1, Point p2) {
    this((p1.x+p2.x)/2, (p1.y+p2.y)/2, (p1.val+p2.val)/2);
    randomize();
  }

  Point(Point p1, Point p2, Point p3, Point p4) {
    this((p1.x+p3.x)/2, (p1.y+p3.y)/2, (p1.val+p2.val+p3.val+p4.val)/4);
    randomize();
  }
  
  String toString() {
    return "Point: ["+x+","+y+"]";
  }
  
  void randomize() {
    val += random(-roughness, roughness);
    if(val < 0) val = 0;
    else if(val > 1) val = 1;
  }
}

