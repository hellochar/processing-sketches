import zhang.*;
Camera cam;

Mover[][] all;
int cols, rows;
final float coldist = 20,
rowdist = 20;
float stagnant, drag, rate, power;
int showType = 2;

//values for the background rgb. i took it out because it was eye hurting...
//float lr, lg, lb;
//float nr, ng, nb;

//boolean running = true;
//PImage paused;

void setup() {
  size(800, 600);
  //  paused = new PImage(width, height, RGB);
  rows = (int)(width / rowdist);
  cols = (int)(height / coldist);
  all = new Mover[rows][cols];
//  lr = random(128);
//  lg = random(128);
//  lb = random(128);
  for(int x = 0; x < rows; x++) {
    for(int y = 0; y < cols; y++) {
      all[x][y] = new Mover(x*rowdist+rowdist/2, y*coldist+coldist/2, x, y);
    }
  }
  cam = new Camera(this);
  cam.registerScroll(true, 1.05);
  textFont(loadFont("KodchiangUPC-28.vlw"));
  textAlign(LEFT, TOP);
  frameRate(32);
  resetControls();
}


void resetControls() {
  stagnant = 0;
  drag = 0;
  rate = .01;
  power = 50;
}

void draw() {
  //  if(running) {
  //    nr = bounds(lr+random(-5, 5), 0, 128);
  //    ng = bounds(lg+random(-5, 5), 0, 128);
  //    nb = bounds(lb+random(-5, 5), 0, 128);
  //background(color(nr, ng, nb, 20));
  //    lr = nr;
  //    lg = ng;
  //    lb = nb;
  int m = 0;
  if(mousePressed && !(cam.keyPressed((int)'1') || cam.keyPressed((int)'2') || cam.keyPressed((int)'3') || cam.keyPressed((int)'4'))) {
    m = 1;
    if(mouseButton == LEFT) m = -1;
  }//end of if(mousePressed)
  for(int x = 0; x < rows; x++) {
    for(int y = 0; y < cols; y++) {
      Mover temp = all[x][y];
      if(temp != null) {
        if(m != 0) {
          Vec2 mouseVec = cam.world(new Vec2(mouseX, mouseY)), tempVec = cam.world(new Vec2(temp.x, temp.y));
          float pow = m*power/(1+mouseVec.sub(tempVec).length());
          float val = pow(abs(pow), .3) * (float)Math.signum(pow);
          float ang = atan2(tempVec.y-mouseVec.y, tempVec.x-mouseVec.x);
          temp.addTo(cos(ang)*val, sin(ang)*val);
        }//end of if(m != 0)
        temp.addTo(-(temp.x-temp.ax)*rate, -(temp.y-temp.ay)*rate);
        temp.ax += (temp.x-temp.ax)*stagnant;
        temp.ay += (temp.y-temp.ay)*stagnant;
        temp.move();
      }//end of if(temp != null)
    }//end of for(y)
  }//end of for(x)

  background(0xff886633);
  cam.scroll(10);
  pushMatrix();
  pushStyle();
  cam.apply();
  for(int x = 0; x < rows; x++) {
    for(int y = 0; y < cols; y++) {
      all[x][y].show();
    }
  }
  popMatrix();
  popStyle();
  pushStyle();
  float lineHeight = (textAscent()+textDescent())*1.5;
  pushMatrix();
  translate(0, -lineHeight/4);
  if(cam.keyPressed((int)'1')) {
    fill(color(100, 100, 255, 100));
    stroke(color(100, 100, 255));
    rect(10, 10, stagnant*(width/3-10), lineHeight);
  }
  if(cam.keyPressed((int)'2')) {
    fill(color(200, 110, 200, 100));
    stroke(color(200, 110, 200));
    rect(10, 10+lineHeight, drag*(width/3-10), lineHeight);
  }
  if(cam.keyPressed((int)'3')) {
    fill(color(64, 190, 190, 100));
    stroke(color(64, 190, 190));
    rect(10, 10+lineHeight*2, rate*(width/3-10), lineHeight);
  }
  if(cam.keyPressed((int)'4')) {
    fill(color(255, 120, 100, 100));
    stroke(color(255, 120, 100));
    rect(10, 10+lineHeight*3, power, lineHeight);
  }
  popMatrix();
  popStyle();
  text("1: stagnant: "+stagnant, 10, 10);
  text("2: drag: "+drag, 10, 10+lineHeight);
  text("3: rate: "+rate, 10, 10+lineHeight*2);
  text("4: power: "+power, 10, 10+lineHeight*3);
}

void mouseDragged() {
  if(cam.keyPressed((int)'1')) {
    stagnant += map(mouseX-pmouseX, 0, width, 0, 1);
  }
  if(cam.keyPressed((int)'2')) {
    drag += map(mouseX-pmouseX, 0, width, 0, 1);
  }
  if(cam.keyPressed((int)'3')) {
    rate += map(mouseX-pmouseX, 0, width, 0, 1);
  }
  if(cam.keyPressed((int)'4')) {
    power += mouseX-pmouseX;
  }
}

class Mover {

  //position x and y, velocity x and y, center/origin point x and y
  float x, y, dx, dy, ax, ay;
  final int r;
  final int c;

  Mover(float x, float y, int r, int c) {
    locTo(x, y);
    centerTo(x, y);
    this.r = r;
    this.c = c;
  }

  void move() {
    //      x = constrain(x+(dx *= drag), 0, width);
    //    y = constrain(y+(dy *= drag), 0, height);
    x += dx *= 1-drag;
    y += dy *= 1-drag;
    /*    if(x == 0 | x == width)
     dx *= -1;
     if(y == 0 | y == height)
     dy *= -1;*/
  }

  void addTo(float dx, float dy) {
    setTo(this.dx+dx, this.dy+dy);
  }

  void setTo(float dx, float dy) {
    this.dx = dx;
    this.dy = dy;
  }

  void locTo(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void centerTo(float x, float y) {
    ax = x;
    ay = y;
  }

  void show() {
    stroke(255);
    if(showType == 0) {
      point(x, y);
    }
    else if(showType == 1) {
      rect(x, y, 1, 1);
    }
    else if(showType == 2) {
      if(r < rows-1)
        line(x, y, all[r+1][c].x, all[r+1][c].y);
      if(c < cols-1)
        line(x, y, all[r][c+1].x, all[r][c+1].y);
    }
  }

}

long time;
boolean r = false;

void keyPressed() {
  //  if(key == ' ') {
  //    if(!(running = !running)) {
  //      paused.copy(get(), 0, 0, width, height, 0, 0, width, height);
  //    }
  //  }
  if(key == 't') {
    showType = (showType+1) % 3;
  }
  if(key == 'r') {
    boolean changed = false;
    for(int x = 0; x < rows; x++) {
      for(int y = 0; y < cols; y++) {
        Mover temp = all[x][y];
        if(!changed && temp.dx != 0) changed = true;
        temp.locTo(x*rowdist+rowdist/2, y*coldist+coldist/2);
        temp.centerTo(temp.x, temp.y);
        temp.setTo(0, 0);
      }
    }
    if(!changed) resetControls();
  }
}

void setPixAt(int x, int y, int c) {
  if(x < 0 | x > width-1 | y < 0 | y > height-1) return;
  pixels[y*width+x] = c;
}

void setPixAt(float x, float y, int c) {
  setPixAt(int(x), int(y), c);
}



