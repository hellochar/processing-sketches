World w = new World();
int[][] nextpix;

color bg = color(0);
void setup() {
  size(200, 200, P3D);
  background(bg);
  nextpix = new int[width][height];
  for(int a = 0; a < 3; a++) {
  w.setseed(random(width), random(height), randomColor());
  }
  loadPix();
}

color temp;
color t;
int allies;
int enemies;

int num = 1;

color randomColor() {
  return color(round((num*random(255/num)%256)), round((num*random(255/num)%256)), round((num*random(255/num)%256)));
}


void loadPix() {
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) {
      nextpix[x][y] = get(x,y);
    }
  }
}

void updatePix() {
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) {
      set(x, y, nextpix[x][y]);
    }
  }
}

void draw() {
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) {
      temp = w.getpix(x, y);
      allies = 0;
      enemies = 0;
      if(temp != bg) {
        for(int dx = -1; dx < 2; dx++) {
          for(int dy = -1; dy < 2; dy++) {
            t = w.getpix(x+dx, y+dy);
            if(t == temp)
              allies++;
            else if(t == bg && random(1) < .151) {
              w.setpix(x, y, bg);
              w.setpix(x+dx, y+dy, temp);
            } else
              enemies++;
/*              if(t == temp) {
                w.setpix(x, y, bg);
                w.setpix(x-dx, y-dy, temp);
              }*/
          }
        }
//        if(enemies >= allies && random(1) < 0)
  //        w.setpix(x, y, bg);
      }
    }
  }
  updatePix();
//  w.setseed(random(width), random(height), randomColor());
}

void mousePressed() {
  setup();
}


class World
{
  void setseed(int x, int y, int c) {
    while(x < 0) x += width;
    while(x > width - 1) x -= width;
    while(y < 0) y += height;
    while(y > height - 1) y -= height-1;
    set(x, y, c);
    setpix(x, y, c);
  }
  
  void setseed(float x, float y, int c) {
    setseed(round(x), round(y), c);
  }
  
  void setpix(int x, int y, int c) {
    while(x < 0) x += width;
    while(x > width - 1) x -= width;
    while(y < 0) y += height;
    while(y > height - 1) y -= height-1;
    nextpix[x][y] = c;
  }

  void setpix(float x, float y, int c) {
    setpix(round(x), round(y), c);
  }

  color getpix(int x, int y) {
    while(x < 0) x += width;
    while(x > width - 1) x -= width;
    while(y < 0) y += height;
    while(y > height - 1) y -= height-1;
    return get(x, y);
  }

  color getpix(float x, float y) {
    return getpix(round(x), round(y));
  }
}
