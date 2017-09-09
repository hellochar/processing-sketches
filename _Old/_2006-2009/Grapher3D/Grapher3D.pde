float camZ = 0, ty = 0, tx = 0, tz = 0;
boolean dragged = false, showGrid = true;
PFont f;

float xmin, xmax, zmin, zmax, xdif, zdif;
float xTick, zTick, yTick;

void setup() {
  size(600, 600, P3D);
  setGrid(-250, 250, -250, 250);
  camera();
  f = loadFont("AbadiMT-Condensed-48.vlw");
  textFont(f, 16);
}

void setGrid(float xmin, float xmax, float zmin, float zmax) {
  this.xmin = xmin;
  this.xmax = xmax;
  this.zmin = zmin;
  this.zmax = zmax;
  xdif = xmax-xmin;
  zdif = zmax-zmin;
}

float precision = 5;

void draw() {
  background(204);
  rotateY(radians(ty));
  rotateX(radians(tx));
  rotateZ(radians(tz));
  stroke(color(255, 0, 0, 100));
  noFill();
  for(float z = zmin; z <= zmax; z += precision) {
    beginShape();
    for(float x = xmax; x >= -xmin; x -= precision) {
      vertex(x, -y(x, z), z);
    }
    endShape();
  }

  if(showGrid) {
    stroke(color(255));
    fill(color(0));
    textAlign(CENTER, TOP);
    for(float x = -xmin; x <= xmax; x += xTick) {
      line(x, 0, 250, x, 0, -250);
      pushMatrix();
      translate(x, 0, 250);
      rotateX(HALF_PI);
      text((int)x, 0, 0, 0);
      popMatrix();
    }

    textAlign(RIGHT, CENTER);
    fill(color(0, 0, 255));
    for(float z = zmax; z >= -zmin; z -= zTick) {
      line(-250, 0, z, 250, 0, z);
      pushMatrix();
      translate(-250, 0, z);
      rotateX(HALF_PI);
      text((int)z, 0, 0, 0);
      popMatrix();
    }
    stroke(color(255, 196, 32));
    fill(color(0, 255, 0));
    line(0, -250, 0, 0, 250, 0);
    for(float y = -250; y <= 250; y += yTick) {
      line(-25, y, 0, 25, y, 0);
      //    line(0, y, -25, 0, y, 25);
      textAlign(CENTER, CENTER);
      text(-(int)y, 0, y, 0);
    }
  }
  println(frameRate);
}

void orientCamera() {
  beginCamera();
  camera();
  translate(0, 0, camZ);
  endCamera();
}

void mouseDragged() {
  if(!altDown) {
    camZ -= mouseY-pmouseY;
    ty += (mouseX-pmouseX)/TWO_PI;
  }
  else {
    tx -= (mouseY-pmouseY)*cos(radians(ty))+(mouseX-pmouseX)*sin(radians(ty));
    tz += (mouseY-pmouseY)*sin(radians(ty))+(mouseX-pmouseX)*cos(radians(ty));
  }
  orientCamera();
}

void mousePressed() {
  if(mouseButton == CENTER) {
    camZ = ty = tx = tz = 0;
    orientCamera();
  }
}

boolean altDown = false;

void keyPressed() {
  if(key == CODED) {
    if(keyCode == ALT) {
      altDown = true;
    }
  }
  else if(key == 'g') {
    showGrid = !showGrid;
  }
}

void keyReleased() {
  if(key == CODED) {
    if(keyCode == ALT) {
      altDown = false;
    }
  }
}

void camera() {
  camera(0, -height, (height/2.0) / tan(PI*60.0 / 360.0), 0, 0, 0, 0, 1, 0);
}
