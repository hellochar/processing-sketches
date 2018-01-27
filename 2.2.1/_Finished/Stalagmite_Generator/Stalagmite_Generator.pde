import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

int[][] cave;
int[][] cdata;
int numdrop, i, j, tall, savei, savej;
int botx, boty, topx, topy;
double scale, lift, xsq, ysq, sumx, centerx, sumy, centery, radius_sq;
float radius;

PeasyCam cam;

void setup() {
  size(512, 512, P3D);
  cam = new PeasyCam(this, 500);
  cave = new int[width][height];
  cdata = new int[width][height];
  //number of droplets
  numdrop = 20000;
  //radius of droplets
  radius = 10;
  
  lift = 1; centerx = width/2; centery = height/2;
  radius_sq = radius*radius;
  
  newStalag();
}

void newStalag() {
  smoothCave();
  newcData();
  generate();
}

void keyPressed() {
  if(key == ' ')
    newStalag();
}

int incr = 5;

void draw() {
  background(0);
  lights();
  noStroke();
  for(i = 0; i < width; i += incr) {
    for(j = 0; j < height; j += incr) {
      plot(i, j);
    }
  }
}

void newcData() {
  for(i = 0; i < width; i += incr) {
    for(j = 0; j < height; j += incr) {
      cdata[i][j] = color(6*16+8 + random(-4, 4), 4*16+12 + random(-4, 4), 3*16 + 3 + random(-3, 3));
    }
  }
}

void smoothCave() {
  for(i = 0; i < width; i++) {
    for(j = 0; j < height; j++) {
      cave[i][j] = (int)random(5);
    }
  }
}

void generate() {
  for(int k = 0; k < numdrop; k++) {
    tall = -1;
  //scan 20 cave ceiling positions and save the longest one
    for(int l = 0; l < 20; l++) {
      i = (int)random(width);
      j = (int)random(height);
      if(cave[i][j] > tall) {tall = cave[i][j]; savei = i; savej = j; }
    }
  
    //Ensure that stalactite doesn't go beyond array boundaries
    centerx = savei;
    centery = savej;
    botx = (int)Math.max(0, centerx-radius); topx = (int)Math.min(width, centerx+radius);
    boty = (int)Math.max(0, centery-radius); topy = (int)Math.min(height, centery+radius);
    
    //Add disc droplet
    for(i = botx; i < topx; i++) {
      for(j = boty; j < topy; j++) {
        xsq = sq(i-centerx); ysq = sq(j-centery);
        if(xsq+ysq <= radius_sq) cave[i][j] += lift;
      }
    }
  }
}

double sq(double d) { return d*d; }
