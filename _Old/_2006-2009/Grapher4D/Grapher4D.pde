import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;


PeasyCam cam;

boolean dragged = false, showGrid = true, running = false;
PFont fModel, fTime, ftInterval;
float fTimeHeight;

float time, tInterval;

float xmin, xmax, zmin, zmax, xdif, zdif;

void setup() {
  size(600, 600, P3D);
  cam = new PeasyCam(this, 500);
  fModel = loadFont("AbadiMT-Condensed-48.vlw");
  fTime = loadFont("AbadiMT-Condensed-16.vlw");
  ftInterval = loadFont("AbadiMT-CondensedLight-12.vlw");
  textFont(fTime);
  fTimeHeight = textDescent()+textAscent();
  tInterval = .001;
}

void setGrid(float xmin, float xmax, float zmin, float zmax) {
  this.xmin = xmin;
  this.xmax = xmax;
  this.zmin = zmin;
  this.zmax = zmax;
  xdif = xmax-xmin;
  zdif = zmax-zmin;
}

float precision = 7;

void draw() {
  background(204);
  stroke(color(255, 0, 0, 100));
  noFill();
  for(int z = -250; z <= 250; z += precision) {
    beginShape();
    float prevY = 0;
    for(int x = 250; x >= -250; x -= precision) {
      float y = y(x/10.0, z/10.0, time)*10;
      if(abs(prevY - y ) > 1250) {
        endShape();
        beginShape();
      }
      vertex(x, -y, z);
      prevY = y;
    }
    endShape();
  }
  if(running == true) {
    time += tInterval;
  }

  if(showGrid) {
    textFont(fTime);
    fill(color(0));
    textMode(SCREEN);
    textAlign(LEFT, TOP);
    text(String.valueOf(time), 1, 3);
    
    textFont(ftInterval);
    fill(color(200, 0, 0));
    text(String.valueOf(tInterval), 2, 3 + fTimeHeight);
    
    textMode(MODEL);
    textFont(fModel, 16);
    stroke(color(255));
    fill(color(0));
    textMode(MODEL);
    textAlign(CENTER, TOP);
    for(int x = -250; x <= 250; x += 20) {
      line(x, 0, 250, x, 0, -250);
      pushMatrix();
      translate(x, 0, 250);
      rotateX(PI/2);
      text((int)(x/10), 0, 0, 0);
      popMatrix();
    }

    textAlign(RIGHT, CENTER);
    fill(color(0, 0, 255));
    for(int z = 250; z >= -250; z -= 20) {
      line(-250, 0, z, 250, 0, z);
      pushMatrix();
      translate(-250, 0, z);
      rotateX(PI/2);
      text((int)(z/10), 0, 0, 0);
      popMatrix();
    }
    stroke(color(255, 196, 32));
    fill(color(0, 255, 0));
    line(0, -250, 0, 0, 250, 0);
    for(int y = -250; y <= 250; y += 20) {
      line(-25, y, 0, 25, y, 0);
      //    line(0, y, -25, 0, y, 25);
      textAlign(CENTER, CENTER);
      text((int)(-y/10), 0, y, 0);
    }
  }
}

boolean altDown = false, ctrlDown = false;

void keyPressed() {
  if(key == CODED) {
    if(keyCode == ALT) {
      altDown = true;
    }
    else if(keyCode == CONTROL) {
      ctrlDown = true;
    }
    else if(keyCode == LEFT & !running) {
      time -= tInterval*10;
    }
    else if(keyCode == RIGHT & !running) {
      time += tInterval*10;
    }
  }
  else switch(key) {
    case 'g':
      showGrid = !showGrid;
      break;
    case ' ':
      if(!running) {
        if(ctrlDown) {
          time = 0;
        }
        else running = true;
      }
      else running = false;
      break;
    case '-':
      tInterval -= tInterval * .1;
      break;
    case '=':
      tInterval += tInterval * .1;
  }
}

void keyReleased() {
  if(key == CODED) {
    if(keyCode == ALT) {
      altDown = false;
    }
    else if(keyCode == CONTROL) {
      ctrlDown = false;
    }
  }
}
