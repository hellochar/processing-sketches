import processing.opengl.*;

/* Landscape generator
  Version 1.0, programmed by Xiaohan Zhang
  
  Re-use code plox
  
  left/right: turn landscape
  up/down: rotate view up/down
  +/-: zoom in/out (it's actually the equal sign instead of the plus sign)
  
  Originally, this was going to be a study of how related objects interact with each other in the face of chance, a semi-simulation of 
  people in real life - some people would overcome hardship and rise to the top, while others will bring their friends down, etc. Instead,
  this became a landscape generator.
  
*/

final static float MAXRATE = 4;
final static float yMax = 128;

final static int xMax = 100,
                 zMax = 100;

final static float zin = 1.05, zout = 1/zin;
float yMult;
float BLOCK_DIST;
int HALF_TOTAL_DIST;

Unit[][] units = new Unit[xMax][zMax];

void setup() {
  size(900, 450, P3D);
  BLOCK_DIST = (float)width / xMax;
  yMult = height/yMax/2;
  HALF_TOTAL_DIST = width/2;
//  background(0);
  noStroke();
  for(int x = 0; x < xMax; x++) {
    for(int z = 0; z < zMax; z++) {
//      println(x+", "+z);
      units[x][z] = new Unit(x, z, yMax, random(-MAXRATE, MAXRATE));
    }
  }
  for(int x = 0; x < xMax; x++) {
    for(int z = 0; z < zMax; z++) {
      units[x][z].findFriends();
    }
  }
//  sphereDetail(6);
  camera(0, -height, (height/2.0) / tan(PI*60.0 / 360.0), 0, -height/2, 0, 0, 1, 0);
}

final float turnSpeed = radians(3);
float ty = 0;
float tx = 0;
float zoom = 1;

void draw() {
  background(255);
  for(int x = 0; x < xMax; x++) {
    for(int z = 0; z < zMax; z++) {
      units[x][z].run();
    }
  }
  if(keyPressed) {    
  if(keyCode == LEFT) {
    ty += turnSpeed;
  }
  else if(keyCode == RIGHT) {
    ty -= turnSpeed;
  }
  if(keyCode == UP) {
    tx = max(tx-turnSpeed, -PI/4);
  }
  else if(keyCode == DOWN) {
    tx = min(tx+turnSpeed, PI/4);
  }
  if(key == '-') {
//    beginCamera();
    zoom *= zout;
//    endCamera();
  }
  else if(key == '=') {
//    beginCamera();
    zoom *= zin;
//    endCamera();
  }
  }
  scale(zoom);
  rotateX(tx);
  rotateY(ty);
 
  translate(-HALF_TOTAL_DIST, 0, -HALF_TOTAL_DIST);
//  beginShape(QUAD_STRIP);
  for(int x = 0; x < xMax; x++) {
    for(int z = 0; z < zMax; z++) {
      units[x][z].update();
    }
  }
  for(int x = 1; x < xMax; x++) {
    for(int z = 1; z < zMax; z++) {
      drawFor(unitAt(x-1, z-1), unitAt(x-1, z), unitAt(x, z), unitAt(x, z-1));
    }
  }
//  endShape();
  println(frameRate);
}

Unit unitAt(int x, int z) {
  if(x < 0 | x > xMax-1 | z < 0 | z > zMax-1) return null;
  return units[x][z];
}

int colorFor(float x) {
  float r = (x-yMax/2)/yMax*255*yMax/(yMax-yMax/2);
  float g = x/yMax*255*.9*yMax/(.9*yMax-.35*yMax);
  float b = abs(yMax/2-x)/yMax/2*255;
  return color(r, g, b);
}

void drawFor(Unit u1, Unit u2, Unit u3, Unit u4) {
//  float rate = (u1.rate+u2.rate+u3.rate+u4.rate)/4;
//  fill(colorFor((u1.rate+u2.rate+u3.rate+u4.rate)/4*16));
  fill(colorFor((u1.y+u2.y+u3.y+u4.y)/4));
  beginShape(QUADS);
  u1.vertexHere();
  u2.vertexHere();
  u3.vertexHere();
  u4.vertexHere();
  endShape();
}

class Unit {
  final int x, z;
  float y, nextY;
  float rate;
  boolean alive = true;
  LinkedList friends;
  
  Unit(int x, int z, float y, float rate) {
    this.x = x;
    this.z = z;
    this.y = y;
    this.rate = rate;
    friends = new LinkedList();
  }
  
  void findFriends() {
    for(int x = -1; x < 2; x++) {
      for(int z = -1; z < 2; z++) {
        Unit f = unitAt(this.x+x, this.z+z);
        if(f != null && f != this)
          if(friends.indexOf(f) == -1)
            friends.add(f);
      }
    }
  }
  
  void run() {
    add(rate);
    Link l = friends.first();
    Unit f;
    float dif = 0;
    int k = 0;
    while(l != null) {
      f = (Unit)l.data;
      dif += f.get()-get();
      k++;
      l = l.next;
    }
    add(dif/k);
//    rate += random(-.1, .1);
//    if(random(1) < .01) {
//      add(random(-5, 5));
//    }
  }
  
  float get() {
    return y;
  }
  
  void set(float p) {
    nextY = constrain(p, 0, yMax);
  }
  
  void add(float p) {
    set(nextY+p);
  }
  
  void update() {
    if(alive) {
      y = nextY;
//      if(rate > 0) fill(color(128+128/MAXRATE*rate, 0, 0));
//      pushMatrix();
//      translate(x*BLOCK_DIST, -y*yMult, z*BLOCK_DIST);
//      sphere(4);
//      popMatrix();
//      vertex(x*BLOCK_DIST, -y*yMult, z*BLOCK_DIST);
    }
    else {
      
    }
  }
  
  void vertexHere() {
    vertex(x*BLOCK_DIST, -y*yMult, z*BLOCK_DIST);
  }
}
