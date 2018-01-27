Ball[] allB;
Ball tempB;
Attractor[] allA;
Attractor tempA;
Attractor grabbed = null;
int a;
boolean r = true;
int g = 255;
int tailLength = 100;
PFont font;
float lastSigX, lastSigY;
float tempF;


void setup() {
  size(600, 600);
  background(0);
  font = loadFont("AbadiMT-Condensed-48.vlw");
  textFont(font, 20);
  allB = new Ball[00];
  allA = new Attractor[0];
}

void mousePressed() {
  if(mouseButton == LEFT) {
    for(a = 0; a < allA.length; a++) {
      if(abs(dist(juxtMouseX(), juxtMouseY(), allA[a].x, allA[a].y)-allA[a].size) < 10+allA[a].size*.1 ) {
        grabbed = allA[a];
        break;
      }
    }
  }
}

float juxtMouseHalfX() {
  return mouseX-width/2;
}

float juxtMouseHalfY() {
  return mouseY-height/2;
}

float juxtMouseX() {
  return 2*mouseX-width/2;
}

float juxtMouseY() {
  return 2*mouseY-height/2;
}

void mouseDragged() {
  if(grabbed != null) {
    grabbed.size = dist(grabbed.x, grabbed.y, juxtMouseX(), juxtMouseY());
  }
}

void mouseReleased() {
  grabbed = null;
}

void keyPressed() {
  switch(keyCode) {
    case DELETE:
      allB = new Ball[0];
      allA = new Attractor[0];
      break;
    default:
      break;    
  }
  switch(key) {
  case 'r':
    r = !r;
    break;
  }
  if(key >= '0' & key <= '9') {
    g = int((key-'1'+1)/9.0*255);
  }
}

void draw() {
  if(g > 0) background(color(0, g));
  if(mousePressed) {
    if(mouseButton == LEFT & grabbed == null & (lastSigX != mouseX | lastSigY != mouseY)) {
      allA = (Attractor[])append(allA, new Attractor(juxtMouseX(), juxtMouseY(), 15, 2));
      lastSigX = mouseX;
      lastSigY = mouseY;
    }
    else if(mouseButton == RIGHT) {
      for(a = 0; a < allA.length; a++) {
        if(dist(juxtMouseX(), juxtMouseY(), allA[a].x, allA[a].y) < allA[a].size) {
          allA = remove(allA, a);
        }
      }
    }
  }
  if(keyPressed) {
    switch(key) {
    case '=':
      text(tailLength, 0, 20);
      if(tailLength < 10000) tailLength++;
      break;
    case '-':
      text(tailLength, 0, 20);
      if(tailLength > 1) { tailLength--;
//        if(allB.length > tailLength--) allB = (Ball[])subset(allB, 1, tailLength);
      }
      break;
    default:
      break;
    }
  }
//  allB = (Ball[])append(allB, new Ball(width/2+random(-2, 2), height/2+random(-2, 2), 1, 0, 3));  
if(r)  allB = (Ball[])append(allB, new Ball(width/2, height/2, 1, 0, 3));
  loadPixels();
  for(a = 0; a < allB.length; a++) {
    allB[a].run();
  }
  for(a = 0; a < allB.length; a++) {
    allB[a].show();
    // if(allB[a].life < 0) {
    // remove(allB, a);
    //}
  }
  updatePixels();
  if(allB.length > tailLength) allB = (Ball[])subset(allB, 1, tailLength);
    noFill();
    stroke(color(255, 128));
  for(a = 0; a < allA.length; a++) {
    allA[a].show();
  }
  /*
  background(00);
   loadPixels();
   for(int x = 0; x < width; x++) {
   for(int y = 0; y < height; y++) {
   setAt(x, y, color(dist(x, y, width/2, height/2)%255));
   }
   }*/
}

Attractor[] remove(Attractor[] which, int index) {
  index++;
  if(index < 0 | index > which.length) return which;
  else if(index == 0) return (Attractor[])subset(which, 1);
  else if(index == which.length) return (Attractor[])subset(which, 0, which.length-1);
  return (Attractor[])concat(subset(which, 0, index-1), subset(which, index, which.length-index));
}

float bounds(float a, float l, float h) {
  return a > h ? h : a < l ? l : a;
}
int bounds(int a, int l, int h) {
  return a > h ? h : a < l ? l : a;
}

int sign(float a) {
  if(a < 0) return -1;
  return 1;
}

class Attractor {
  float x, y;
  float density;
  float size;
  int a;

  Attractor(float x, float y, float size, float density) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.density = density;
  }

  void show() {
/*    float cx = size/2, cy = 0;
    float nx, ny;
    float d, ang;
    float dist;
    for(a = 0; a <= 360; a+= 90) {
      nx = cos(radians(a))*size/2;
      ny = sin(radians(a))*size/2;
      ang = atan2(ny-cy, nx-cx);
      dist = dist(cx, cy, nx, ny);
      for(d = 0; d < dist; d++) {
        setAt(x+cx+cos(ang)*d, y+cy+sin(a)*d, color(255, 128));
      }
      cx = nx;
      cy = ny;
    }
    for(a = 0; a < 360; a+=90) {
      setAt(x+cos(radians(a))*size/2, y+sin(radians(a))*size/2, color(255, 0, 0));
    }*/
    ellipse(x-(juxtMouseHalfX()), y-(juxtMouseHalfY()), size*2, size*2);
  }
}

class Ball {
  float x, y;
  float dx, dy;
  Attractor temp;
  float dist;
  float ang;
  int a;
  float size;

  Ball(float x, float y, float dx, float dy, float size) {
    this.x = x;
    this.y = y;
    setTo(dx, dy);
    this.size = size;
  }

  void run() {
    for(a = 0; a < allA.length; a++) {
      temp = allA[a];
      dist = pow(temp.size/(temp.size+dist(x, y, temp.x, temp.y)), temp.density);
      ang = atan2(temp.y-y, temp.x-x);
      addTo(cos(ang)*dist, sin(ang)*dist);
    }
  }

  void addTo(float dx, float dy) {
    setTo(this.dx+dx, this.dy+dy);
  }

  void setTo(float dx, float dy) {
    this.dx = dx;
    this.dy = dy;
  }

  void show() {
    x += dx;
    y += dy;/*
    if(x < 0) {
     x = 0;
     dx *= -1;
     } 
     else if( x > width) {
     x = width;
     dx *= -1;
     }
     if(y < 0) {
     y = 0;
     dy *= -1;
     } 
     else if( y > height) {
     y = height;
     dy *= -1;
     }*/
    for(int a = 0; a < 360; a+= 20) {
      setAt(x+cos(radians(a))*size/2, y+sin(radians(a))*size/2, color(255, 128));
    }
    /*
    setAt(x-1, y, color(255, 128));
     setAt(x, y, color(255, 128));
     setAt(x+1, y, color(255, 128));
     setAt(x, y-1, color(255, 128));
     setAt(x, y+1, color(255, 128));*/
  }

}

void setAt(float x, float y, color c) {
  int lxb = int(juxtMouseHalfX());
  int lyb = int(juxtMouseHalfY());
  if(x < lxb | x > lxb+width-1 | y < lyb | y > lyb+height-1) return;
  pixels[(int)(y-lyb)*width+(int)(x-lxb)] = c;
}
