int x, y, dir;
boolean dead = false;
LinkedList locList;
int length = 5;
int fx, fy, ft;
final int widthMax = 50,
          heightMax = 50;
int widthSize, heightSize;
int delay = 0;
int curDelay = 0;
int score = 0;
float scale;

void setup() {
  size(600, 600);
  widthSize = width/widthMax;
  heightSize = height/heightMax;
  smooth();
  background(color(255));
  textFont(loadFont("AbadiMT-CondensedExtraBold-24.vlw"));
  score = 0;
  length = 15;
  dead = false;
  x = widthMax/2;
  y = heightMax/2;
  locList = new LinkedList(new Link(x, y));
  dir = 0;
  curDelay = 0;
  ellipseMode(CORNER);
  createFood();
  textAlign(LEFT, BOTTOM);
  text('0', 0, height);
}

void createFood() {
  boolean hit = false;
  ft = (int)random(2);
  Link l;
  do {
    hit = false;
    fx = (int)random(widthMax);
    fy = (int)random(heightMax);
    l = locList.first();
    while(l != null & !hit) {
      if(fx == l.x & fy == l.y) hit = true;
      l = l.next;
    }
  }while(hit);
  drawFood();
}

void drawTextGrid(int x, int y, TextGrid tg) {
  for(int s = 0; s < tg.height(); s++)
    for(int t = 0; t < tg.width(); t++)
      if(tg.get(s, t))
        ellipseAt(x+s, t+y);
}

void ellipseAt(int x, int y) {
  ellipse(x*widthSize, y*heightSize, widthSize, heightSize);
}

void die() {
  dead = true;
  fill(color(255, 0, 0));
  textAlign(CENTER, TOP);
  text("You lose!", width/2, 0);
}

void mousePressed() {
  if(dead) setup();
}

void drawFood() {
  pushMatrix();
  translate(fx*widthSize, fy*heightSize);
  scale(widthSize, heightSize);
  switch(ft) {
    case 0: //'sa cherry!
      stroke(color(0, 150, 0));
      strokeWeight(2.0/widthSize);
      line(.75, .75, .37, .25);
      line(.37, .25, .10, .17);
      noStroke();
      fill(color(255, 0, 0));
      ellipse(.33, .33, .67, .67);
      fill(color(255));
    break;
    case 1: //'sa LOLIPOP
      stroke(color(200));
      strokeWeight(3.0/widthSize);
      line(.5, .5, 1, 1);
      noStroke();
      ellipseMode(CENTER);
      scale(2);
      fill(0xFFFF00FF);
      ellipse(.33, .33, .34, .34);
      fill(0xFF9900CC);
      ellipse(.33, .33, .26, .26);
      fill(0xFF3333CC);
      ellipse(.33, .33, .21, .21);
      fill(0xFF66CCCC);
      ellipse(.33, .33, .17, .17);
      fill(0xFF339933);
      ellipse(.33, .33, .13, .13);
      fill(0xFF99FF33);
      ellipse(.33, .33, .10, .10);
      fill(0xFFFFFF66);
      ellipse(.33, .33, .07, .07);
      fill(0xFFCC6666);
      ellipse(.33, .33, .04, .04);
      ellipseMode(CORNER);
    break;
  }
  popMatrix();
}

void rectAt(int x, int y) {
  rect(x*widthSize, y*heightSize, widthSize, heightSize);
}

void draw() {
  if(dead) {
    return;
  }
  if(curDelay++ > delay) {
    curDelay = 0;
    noStroke();
    fill(color(0));
    switch(dir) {
      case 0: y--; break;
      case 1: x++; break;
      case 2: y++; break;
      case 3: x--; break;
    }
    if(x < 0 | x > widthMax | y < 0 | y > heightMax)
      die();
    int k = 0;
    Link l = locList.first();
    while(l != null) {
      if(x == l.x & y == l.y) {
        die();
      }
      l = l.next;
      k++;
    }
    l = new Link(x, y);
    locList.append(l);
    ellipseAt(x, y);
    if(k >= length) {
      l = locList.removeFirst();
      fill(color(255));
      rectAt(l.x, l.y);
    }
    if(!dead & x == fx & y == fy) {
      score++;
      length++;
      createFood();
      textAlign(LEFT, BOTTOM);
      fill(color(235));
      rect(0, height-textAscent(), textWidth(String.valueOf(score)), textAscent());
      fill(color(0));
      text(score, 0, height);
    }
  }
}

void keyPressed() {
  if(keyCode == ENTER & dead) setup();
  if(keyCode == UP & dir != 2) {
    dir = 0;
  }
  else if(keyCode == RIGHT & dir != 3) {
    dir = 1;
  }
  else if(keyCode == DOWN & dir != 0) {
    dir = 2;
  }
  else if(keyCode == LEFT & dir != 1) {
    dir = 3;
  }
}
