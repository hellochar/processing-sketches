int[][] grid;
int cell = 10;
PFont big, small;
void setup() {
  size(800, 600);
  grid = new int[width/cell][height/cell];
  big = createFont("", cell);
  small = createFont("", cell/3);
  textAlign(LEFT, TOP);
}

float r = 100;
void draw() {
  background(255);
  fill(color(255, 255, 0));
  ellipse(mouseX, mouseY, r*2, r*2);
  circleGet(mouseX, mouseY, r, 1, 10);
  //  circleGet(mouseX, mouseY, r-cell, 1, 20);
  for(int x = 0; x <grid.length; x++) {
    for(int y = 0; y < grid[x].length; y++) {
      if(grid[x][y] > 0) {
        stroke(60, 60);
        fill(color(0, grid[x][y]*10, 0, 100));
        rect(x*cell, y*cell, cell, cell);
        if(cell > 10) {
          textFont(big);
          fill(color(20));
          text(grid[x][y], x*cell, y*cell);
          textFont(small);
          fill(color(20, 200, 20));
          text(x+", "+y, x*cell, y*cell);
        }
      }
      else {
        noFill();
        stroke(60, 60);
        rect(x*cell, y*cell, cell, cell);
      }
    }
    Arrays.fill(grid[x], 0);
  }
}


void circleGet(float x, float y, float r, int res, int k) {
  //test for if the circle is completely contained in one cell
  if(r <= min(x%cell, min(cell-(x%cell), min(y%cell, cell-(y%cell))))) {
    activate(int(x/cell), int(y/cell), k);
    return;
  }
  int lgx = 0, lgy = 0;
  for(float ang = 0, dang = cell*res / (2*r*TWO_PI); ang < TWO_PI; ang+=dang) {
    int gx = (int)(x+r*cos(ang))/cell,
    gy = (int)(y+r*sin(ang))/cell;
    if(lgx != gx || lgy != gy) {
      activate(gx, gy, k);
      lgx = gx;
      lgy = gy;
    }
  }
  println("------");
  //  circleGet(x, y, r-cell, res);
}

//
//void circleGet(float x, float y, float r, int res, int k) {
//  int iterX = grid(x+r)*cell;
//  //(y+y0) = sqrt(r^2-(x+x0)^2)
//  int ly = grid(-sqrt(sq(r)-sq(iterX-x))+y);
//  for( ; iterX > grid(x-r)*cell; iterX -= cell) {
//    int ny = grid(-sqrt(sq(r)-sq(iterX-x))+y);
//    do{
//      ly -= Math.signum(ly-ny);
//      activate(iterX/cell, ly, k);
//    }while(ly != ny);
//  }
//  activate(grid(x-r), grid(y), k);
//}

int grid(float world) {
  return (int)world/cell;
}

void activate(int gx, int gy, int k) {
  if(gx >= 0 && gx < grid.length && gy >= 0 && gy < grid[gx].length) {
    if(grid[gx][gy] < k) 
      grid[gx][gy] = k;
    else grid[gx][gy]++;
  }
}






