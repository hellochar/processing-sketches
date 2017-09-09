import java.util.Vector;
import java.awt.geom.*;
import java.io.*;

int cols = 25,
    rows = 25,
    cellSize = 15;

PGraphics pg;
Vector points;
int transX, transY;
PFont f;
FileInputStream in;
FileOutputStream out;
int xShift, yShift;

void setup() {
  transX = transY = 999999; //set it to some arbitrarily large number
  size(cols*cellSize, rows*cellSize);
  f = loadFont("AbadiMT-Condensed-48.vlw");
  pg = createGraphics(width, height, JAVA2D);
  pg.beginDraw();
  pg.fill(255);
  pg.smooth();
  pg.rect(-1, -1, width, height);
  pg.stroke(25);
  for(int a = 0; a < width; a += cellSize) {
    pg.line(a, 0, a, height);
  }
  for(int a = 0; a < height; a += cellSize) {
    pg.line(0, a, width, a);
  }
  pg.endDraw();
  points = new Vector();  
//  loadPoints(new File(
}

Point2D.Float current;
Point2D.Float last;



void loadPoints(File which) {
  try{
    in = new FileInputStream(which);
    String temp;
    
    
  }catch(Exception e) {}
  
  
}

void mousePressed() {
  if(mouseButton == LEFT) {
    int x = round((float)mouseX/cellSize)*cellSize;
    int y = round((float)mouseY/cellSize)*cellSize;
    if(x < transX) transX = x;
    if(y < transY) transY = y;
    last = new Point2D.Float(x, y);
    points.add(last);
  }
  else if(mouseButton == RIGHT) {
    for(int a = points.size()-1; a >= 0; a--) {
      current = (Point2D.Float)points.get(a);
      if(dist(mouseX, mouseY, current.x, current.y) < cellSize/2.0) {
        points.remove(a);
        if(points.size() > 0)
          last = (Point2D.Float)points.lastElement();
        else last = null;
        break;
      }
    }
  }
}

void keyPressed() {
  if(key == 'm') {
    printText("magImg.");
  }
  else if(key == 'r') {
    printText("roundImg.");
  }
  else if(keyCode == LEFT)
    xShift--;
  else if(keyCode == RIGHT)
    xShift++;
  else if(keyCode == UP)
    yShift--;
  else if(keyCode == DOWN)
    yShift++;
  println("xs: "+xShift+", ys: "+yShift);
}

void printText(String prefix) {
  
    println("    "+prefix+"beginShape();");
    for(int a = 0; a < points.size(); a++) {
      current = (Point2D.Float)points.get(a);
      println("    "+prefix+"vertex("+(int)((current.x-transX)/cellSize+xShift)+", "+(int)((current.y-transY)/cellSize+yShift)+");");
    }
    println("    "+prefix+"endShape();");
  
}


void draw() {
  image(pg, 0, 0);
  fill(color(50, 200, 255, 100));
  stroke(#FF9900);
  beginShape();
  smooth();
  strokeWeight(3);
  strokeJoin(ROUND);
  for(int a = 0; a < points.size(); a++) {
    current = (Point2D.Float)points.get(a);
    vertex(current.x, current.y);
  }
  endShape();
  fill(0);
  if(last != null) {
    textFont(f, 20);
    text(round((mouseX-last.x)/cellSize)+", "+round((mouseY-last.y)/cellSize), mouseX, mouseY);  
    stroke(color(0, 0, 255));
    ellipse(last.x, last.y, 3, 3);
  }
}
