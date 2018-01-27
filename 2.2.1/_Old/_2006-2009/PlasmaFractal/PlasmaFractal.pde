import java.util.Vector;

Vector plasmas;
int[] colorBands;
float m = 1000;
float roughness = .2;

void setup() {
  size(512, 512);
  recreate();
  noLoop();
  colorBands = new int[(int)m];
  for(int a = 0; a < m; a++) {
    //    colorBands[a] = color(abs(m*2/3-a)*128, (m/2-abs(a-m/2))/(m/2)*255, abs(m/2-a)/(m/2)*255);
    colorBands[a] = color(a/m*255, (abs(a-m/2)/(m/2.0)*255), ((m/2-abs(a-m/2))/(m/2)*255));
    //    colorBands[a] = color((a%500/500.0*255), a/m*255, (m-a)/m*255);
    //    colorBands[a] = color(a/m*255);
  }
}

void newPlasma() {
  plasmas = new Vector();
  plasmas.add(new Plasma(new Point(0, 0, random(1)), new Point(width, 0, random(1)), new Point(width, height, random(1)), new Point(0, height, random(1))));
  level = 0;
}

int getColorAt(float val) {
  return colorBands[int(val*(m-1))];
}

int level;
void draw() {
  int a;
  noStroke();
  rectMode(CORNERS);
  if(level >= 9)  loadPixels();
  for(a = 0; a < plasmas.size(); a++) {
    Plasma p = (Plasma)plasmas.get(a);
    p.draw();
  }
  if(level >= 9)  updatePixels();
//  println("drew "+a+"!");
}

boolean finished;
void recreate() {
  newPlasma();
  finished = false;
  for(int a = 0; a < 9; a++) {
  }
  finished = true;
}

void mousePressed() {
  if(!finished) return;
  finished = false;
  if(mouseButton == LEFT) {
    Vector newV;
    Plasma[] temp;
    newV = new Vector();
    int k = plasmas.size();
    for(int c = 0; c < k; c++) {
      Plasma p = (Plasma)plasmas.get(c);
      temp = p.generate();
      for(int b = 0; b < 4; b++) {
        newV.add(temp[b]);
      }
    }
    plasmas = newV;
  }
  else
    recreate();
  redraw();
  finished = true;
}

class Point {
  float val;
  float x, y;
  Point(float x, float y, float val) {
    this.x = x;
    this.y = y;
    this.val = val;
  }

  Point(Point p1, Point p2) {
    this((p1.x+p2.x)/2, (p1.y+p2.y)/2, (p1.val+p2.val)/2);
  }

  Point(Point p1, Point p2, Point p3, Point p4) {
    this((p1.x+p3.x)/2, (p1.y+p3.y)/2, (p1.val+p2.val+p3.val+p4.val)/4);
  }

  void randomize(float chng) {
    val += random(-chng, chng);
    if(val < 0) val = 0;
    else if(val > 1) val = 1;
  }
}

void putAt(int x, int y, int c) {
  if(x < 0 | x > width-1 | y < 0 | y > height-1) return;
  pixels[y*width+x] = c;
}

class Plasma {

  Point p1, p2, p3, p4;
  float x, y;

  Plasma(Point p1, Point p2, Point p3, Point p4) {
    this.p1 = p1;
    this.p2 = p2;
    this.p3 = p3;
    this.p4 = p4;
    x = (p1.x+p3.x)/2;
    y = (p1.y+p3.y)/2;
    /*    float[] xVals = {p1.x, p2.x, p3.x, p4.x};
     w = max(xVals);
     float[] yVals = {p1.y, p2.y, p3.y, p4.y};
     l = max(yVals);*/
  }
  
  public float value() {
    return (p1.val+p2.val+p3.val+p4.val)/4;
  }

  void draw() {
    int c = getColorAt(value());
    //    int c = color((p1.val+p2.val+p3.val+p4.val)*255/4);
    if(level < 9) {
      fill(c);
      rect(p1.x, p1.y, p3.x, p3.y);
    }
    else 
      pixels[(int)y*width+(int)x] = c;
  }

  Plasma[] generate() {
    Point mid = new Point(p1, p2, p3, p4);
    mid.randomize(roughness);
    Point up = new Point(p1, p2), right = new Point(p2, p3), down = new Point(p3, p4), left = new Point(p4, p1);
    /*    up.randomize(roughness);
     right.randomize(roughness);
     down.randomize(roughness);
     left.randomize(roughness);*/
    return new Plasma[] {
      new Plasma(p1, up, mid, left), new Plasma(up, p2, right, mid), new Plasma(mid, right, p3, down), new Plasma(left, mid, down, p4)    };
  }

}

