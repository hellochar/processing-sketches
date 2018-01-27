import zhang.*;

final float goldRatio = 1.61803399;

Branch main;
Branch dragged;

ArrayList all;
ArrayList current;

int currentLevel;

Branch orly;
Camera c;

void setup() {
  size(600, 450);
  strokeCap(PROJECT);
  c = new Camera(this);
  c.registerScroll(true, 1.05);
  reset();
  textFont(createFont("Arial", 12));
  textAlign(LEFT, TOP);
}

void reset() {
  currentLevel = 0;
  all = new ArrayList();
  stroke(0, 128);
  createMain();
  all.add(main);
  current = new ArrayList();
  current.add(main);
  smooth();
}

void draw() {
  c.scroll(10);
  c.apply();
  background(255);
  if(dragged != null) {
    strokeWeight(dragged.thickness);
    stroke(0, 128);
    Vec2 v = c.world(new Vec2(mouseX, mouseY));
    line(dragged.x, dragged.y, v.x, v.y);
  }
  main.runPropagated();
  //  noLoop();
}

void addBranch(Branch which, float offset, float redux) {
  Branch branch = new Branch(which, offset, redux);
  current.add(branch);
  if(branch.level < 6) all.add(branch);
}

void mousePressed() {
  if(dragged == null) {
    Vec2 mouseLoc = c.world(new Vec2(mouseX, mouseY));
    for(int a = 0; a < all.size(); a++) {
      Branch temp = (Branch)all.get(a);
      Vec2 branchLoc = new Vec2(temp.dx, temp.dy);
      println(mouseLoc+" to "+branchLoc+": "+mouseLoc.sub(branchLoc).length());
      if(mouseLoc.sub(branchLoc).length() < 10) {
        if(mouseButton == LEFT) {
          dragged = temp;
          return;
        }
        else if(mouseButton == RIGHT) {
          addBranch(temp, random(-50, 50), goldRatio*random(.5, 1.4));
          return;
        }
      }
    }
  }
  if(dragged == null && mouseButton == RIGHT) {
    int s = current.size();
    for(int a = 0; a < s; a++) {
      Branch temp = (Branch)current.get(a);
      addBranch(temp, random(-50, 50), goldRatio);
      //    if(random(1) < .15) addBranch(temp, random(-10, 10), 4.7);
    }
    for(int a = 0; a < s-++currentLevel; a++) {
      current.remove(a);
    }
  }
  else if(mouseButton == CENTER) {
    reset();
  }
  //  loop();
}

void keyPressed() {
  if(key == 'r') {
    reset();
  }
}

void createMain() {
  main = new Branch(width/2, height, width/2, height-50, 25, 200, 0);
}

void mouseDragged() {
  if(dragged != null) {
    //    loop();
  }
}

void mouseReleased() {
  if(dragged != null) {
    Vec2 v = c.world(new Vec2(mouseX, mouseY));
    if(dragged != main) {
      dragged.offset = atan2(v.y-dragged.parent.dy, v.x-dragged.parent.dx)-dragged.parent.angle();
    }
    else {
      dragged.dx = v.x;
      dragged.dy = v.y;
    }
    //    loop();
    dragged = null;
  }
}

float expFunc(float x) {
  return pow(x/14.0, 3);
}

float wrap(float a, float low, float high) {
  if(low < high) {
    while(a < low) a += (high-low);
    while(a > high) a -= (high-low);
  }
  return a;
}

int wrap(int a, int low, int high) {
  if(low < high) {
    while(a < low) a += (high-low);
    while(a > high) a -= (high-low);
  }
  return a;
}

int sign(float a) {
  if(a < 0) return -1;
  return 1;
}

float radInv(float a) {
  return wrap(a+PI, 0, TWO_PI);
}

class Branch {
  //x and y specify the end of the parent branch, dx and dy specify the end of this branch. 
  float x, y, dx, dy;
  float thickness;
  float size;
  float offset;
  final Branch parent;
  ArrayList children;
  float ang;
  final int level;
  float redux;

  Branch(float x, float y, float dx, float dy, float thickness, float size, int level) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.thickness = thickness;
    this.size = size;
    this.level = level;
    offset = 0;
    parent = null;
    children = new ArrayList();
  }

  Branch(Branch parent, float angleOffset, float redux) {
    this.parent = parent;
    this.redux = redux;
    offset = radians(angleOffset);
    ang = angleOffset();
    level = parent.level+1;
    realignWithParent();
    children = new ArrayList();
    parent.children.add(this);
  }

  float angle() {
    return atan2(dy-y, dx-x);
  }

  float angleOffset() {
    return parent.angle()+offset;
  }

  void realignWithParent() {
    if(parent == null) return;
    ang = angleOffset();
    x = parent.dx;
    y = parent.dy;
    size = parent.size/redux;
    thickness = parent.thickness/redux;
    dx = x+cos(ang)*size;
    dy = y+sin(ang)*size;
  }

  void show() {
    if(c.isOnScreen(x, y) || c.isOnScreen(dx, dy)) {
      strokeWeight(thickness);
      stroke(color(0, expFunc(level)*255, 0), 128);  
      line(x, y, dx, dy);
    }
  }

  void runIsolated() {
    realignWithParent();
    show();
    //    offset += radians(random(-level*level, level*level));
  }

  void runPropagated() {
    runIsolated();
    for(int a = 0; a < children.size(); a++)
      ((Branch)children.get(a)).runPropagated();
  }
}

