import zhang.Methods;
import peasy.*;

PeasyCam cam;

void setup() {
  size(500, 500, P3D);
//  cam = new PeasyCam(this, 60);
//  setAngles(cam, 0, -PI/2);
  img = loadImage("example.png");
  img2 = loadImage("ex2.png");
}

PImage img, img2;

void setAngles(PeasyCam cam, float xy, float xz) {
  float[] pos = cam.getPosition();
  PVector offset = new PVector();
  offset.x = cos(xy)*cos(xz) * 60;
  offset.y = sin(xy)*cos(xz) * 60;
  offset.z = sin(xz) * 60;
  cam.lookAt(pos[0]+offset.x, pos[1]+offset.y, pos[2]+offset.z);
}

float upX = 0;
float upY = 1;
float upZ = 0;

void setCamera(PVector eye, float xy, float xz) {
  PVector offset = new PVector();
  offset.x = cos(xy)*cos(xz) * 60;
  offset.y = sin(xy)*cos(xz) * 60;
  offset.z = sin(xz) * 60;
  camera(eye.x, eye.y, eye.z, eye.x+offset.x, eye.y+offset.y, eye.z+offset.z, upX, upY, upZ);
}

int size = 100;

void draw() {
//  float xy = map(millis(), 0, 1000, 0, PI/3) % TWO_PI;
  float xy = 0;
  float xz = map(millis(), 0, 1000, 0, PI/4) % TWO_PI;
//  setAngles(cam, xy, xz);
//  cam.setRotations(xy, xz, 0);
//  println("Set angles at "+xy+", "+xz+"! Angles got back are ");
//  println(getAngles(cam));
  background(204);
//  cam.feed();
//  lights();
//  rect(-size, -size, size*2, size*2);
//  cam.lookAt(0, 100 * sin(xz), 100 - 100*cos(xz), 0);
  setCamera(new PVector(0, 0, 100), xy, -PI/2+xz);
//  setCamera(new PVector(0, 0, 100), PI/2, -PI/2);

  image(img, -size, -size, size*2, size*2);
  pushMatrix();
  rotateX(PI/2);
  image(img2, -size, -size, size*2, size*2);
  popMatrix();

//  beginShape();
//  texture(img);
//  vertex(-size, -size, 0, 0);
//  vertex(size, -size, img.width, 0);
//  vertex(size, size, img.width, img.height);
//  vertex(-size, size, 0, img.height);
//  endShape();
  pushMatrix();
  translate(-size, -size);
  for(int i = -size; i < size; i += size/5) {
    translate(size/5, size/5, 0);
    fill(255);
    box(map(i, -size, size, 1, size/5));
  }
  fill(0); stroke(0);
  popMatrix();
  textCoord(-size, -size);
  textCoord(size, size);
  textCoord(-size, size);
  textCoord(size, -size);
  Methods.drawAxes(g, 100);
}

void textCoord(int x, int y) {
  text(x+", "+y, x, y, 1);
}

void keyPressed() {
//  println("attitude");
//  println(cam.getRotations());
//  println("lookAt");
//  println(cam.getLookAt());
}

void mouseMoved() {
//  cam.look(radians(pmouseX-mouseX)*.2f, radians(pmouseY-mouseY)*.2f);
//  cam.look(radians(pmouseX-mouseX)*.2f, 0);
//  float[] lookAt = cam.getLookAt();
//  cam.lookAt(lookAt[0]+(pmouseX-mouseX), lookAt[1]+(pmouseY-mouseY), lookAt[2], 0);
}

//void mousePressed() {
//  cam.lookAt(size,size,0, 0);
//}
//
//void mouseReleased() {
//  cam.lookAt(0, 0, 0, 0);
//}
