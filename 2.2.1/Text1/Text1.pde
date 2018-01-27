import zhang.map.*;
import zhang.*;

static int gHue = 90;

class Cell {
  float x, y, w, h;
  int millisAlive = (int)random(10000);
  int lastMillis = millis();
  List<Cell> connections;
  String text = "";
  int hue = (gHue += 1);
  
  float tAngle() {
    return map(millisAlive, 0, 6000, 0, TWO_PI);
  }
  
  float sAngle() {
    return map(millisAlive, 0, 15000, 0, TWO_PI);
  }
  
  float sx() {
    return map(sin(sAngle()), -1, 1, .94, 1/.94);
  }
  
  float sy() {
    return map(cos(sAngle()*1.2+.1), -1, 1, .94, 1/.94);
  }
  
  float tx() {
    return 1*sin(tAngle());
  }
  
  float ty() {
    return 1.2*cos(1.7*tAngle());
  }
  
  Cell(float x, float y) {
    this.x = x;
    this.y = y;
    connections = new LinkedList();
    w = 75;
    h = 75;
  }
  
  void draw() {
    int curMillis = millis();
    millisAlive += curMillis - lastMillis;
    lastMillis = curMillis;
    textAlign(CENTER, CENTER);
    strokeWeight(2);
    stroke(0, 0, 255, 255); //white with 100 alpha
    fill(hue, 210, 200);
    pushMatrix();
    translate(x, y);
    translate(tx(), ty());
    scale(sx(), sy());
    ellipse(0, 0, w, h);
    popMatrix();
    fill(0, 0, 255);
    text(text, x, y, w, h);
  }
}

List<Cell> cells;
Camera cam;

void setup() {
  size(500, 500);
  cam = new Camera(this);
  colorMode(HSB);
  cells = new LinkedList();
  smooth();
}

void draw() {
  background(0);
  for(Cell c : cells) {
    c.draw();
  }
  if(editing != null) {
    noFill();
    strokeWeight(1);
    stroke(0, 255, 255); //red
    ellipse(editing.x, editing.y, editing.w*1.2, editing.h*1.2);
  }
}

Cell cellAt(float wX, float wY) {
  for(Cell c : cells) {
//    if(dist(m.x, m.y, c.x, c.y) < 
    if(abs(wX - c.x) < c.w &&
       abs(wY - c.y) < c.h) {
         return c;
       }
  }
  return null;
}

int millisLastClicked = 0;
void mouseClicked() {
  int millis = millis();
  if(millis - millisLastClicked < 200) { //double-click threshhold
    PVector m = cam.model(cam.mouseVec());
    Cell c = cellAt(m.x, m.y);
    if(c == null) {
      addCell(m.x, m.y);
    }
  }
  else {
    PVector m = cam.model(cam.mouseVec());
    Cell c = cellAt(m.x, m.y);
    setEdit(c);
  }
  millisLastClicked = millis;
}

void mouseDragged() {
  PVector last = cam.model(new PVector(pmouseX, pmouseY));
  Cell c = cellAt(last.x, last.y);
  if(c != null) {
    PVector cur = cam.model(cam.mouseVec());
    c.x = cur.x;
    c.y = cur.y;
  }
}

Cell editing = null;

void setEdit(Cell c) {
  editing = c;
  if(c != null)
    cam.noWasd();
  else cam.wasd();
}

void keyTyped() {
  if(editing != null) {
    editing.text += key;
  }
}

void addCell(float wX, float wY) {
  Cell c = new Cell(wX, wY);
  cells.add(c);
}
