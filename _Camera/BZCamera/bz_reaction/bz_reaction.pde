import JMyron.*;

//Alternates between which grid contains the "current" time step and which one should hold transitional data.
cell[][] grid;
int p = 0, q = 1;

float A = 1.5,
B = 1,
C = 1;

boolean pause = false;
JMyron my;

void setup() {
  size(160, 120);
  my = new JMyron();
  my.start(width, height);
  my.adaptivity(50);
  my.findGlobs(0);
  grid = new cell[width][height];
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) {
//      grid[x][y] = new cell(x, y, random(1), random(1), random(1));
      grid[x][y] = new cell(x, y, 0, 0, 0);
    }
  }
  colorMode(HSB, 1);
  //  noLoop();
  frameRate(1);
}

void keyPressed() {
  if(key == ' ') pause = !pause;
}

int x = 0, y = 0;

void draw() {
  if(frameCount < 30) my.adapt();
  my.update();
  int[] pic = my.image();
  int[] dif = my.differenceImage();
  float amt = .9;
  for(int i = 0; i < dif.length; i++) {
    if(brightness(dif[i]) > .2) {
      cell c = cellAt(i%width, i/width);
      //              c.a[p] *= .1;
      //              c.b[p] = constrain(c.b[p]*.1, .000000001, 1);
      //              c.c[p] += (1-c.c[p])*.95;
      switch((int)random(3)) {
      case 0:
        c.a[p] += (1 - c.a[p])*amt;
        break;
      case 1:
        c.b[p] += (1 - c.b[p])*amt;
        break;
      case 2:
        c.c[p] += (1 - c.c[p])*amt;
        break;
      }
    }
  }

  println(frameRate);
  cell ce = cellAt(mouseX, mouseY);
  println(ce.a[p]+", "+ce.b[p]+", "+  ce.c[p]);
  if(!pause) {
    frameRate(1);
    loadPixels();
    for(x = 0; x < width; x++) {
      for(y = 0; y < height; y++) {
        cell c = cellAt(x, y);
        c.calculateNext();
        //        pixels[y*width+x] = dif[y*width+x];
        //        if(c.c[p] > .5)
        float h = hue(pic[y*width+x]);
        //          float s = saturation(pic[y*width+x]);
        float s = 5*c.a[p]*saturation(pic[y*width+x]);
        //      float s = saturation(pic[y*width+x]);
        float b = constrain(3*c.b[p], 0, 1)*brightness(pic[y*width+x]);
        //          float b = brightness(c.getColor());
        pixels[y*width+x] = color(h, s, b);
        //        else
        //          pixels[y*width+x] = color(0, 0, c.c[p]);
        //c.getColor();
      }
    }
    updatePixels();
    if(p == 1) {
      p = 0;
      q = 1;
    }
    else {
      p = 1; 
      q = 0;
    }
  }
  else frameRate(20);
}


public cell cellAt(int x, int y) {
  return grid[(x+width)%width][(y+height)%height];
}









