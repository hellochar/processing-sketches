int[][] grid;
int cell = 15;
PFont big, small;
void setup() {
  size(800, 600);
  grid = new int[width/cell][height/cell];
  big = createFont("", cell);
  small = createFont("", cell/3);
  textAlign(LEFT, TOP);
}

float r = 150;
void draw() {
  background(255);
  fill(color(255, 255, 0));
  ellipse(mouseX, mouseY, r*2, r*2);
  circleGet(mouseX, mouseY, r);
  //  circleGet(mouseX, mouseY, r-cell, 1, 20);
        stroke(60, 60);
  for(int x = 0; x <grid.length; x++) {
    for(int y = 0; y < grid[x].length; y++) {
      if(grid[x][y] > 0) {
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
        rect(x*cell, y*cell, cell, cell);
      }
    }
    Arrays.fill(grid[x], 0);
  }
}

int EDGE = 10, FULL = 20;

void circleGet(float x, float y, float r) {
  int minX = grid(x-r), maxX = grid(x+r);
  
  //"flattening" problem: if there's an even number of x to go through, there's a problem where the very top or bottom of the circle isn't accounted for. this problem is caused
  //by iterating through the x, and is minor if the grid size is small.
  
  //test for if the circle is completely contained in one horizontal
  if(minX == maxX) {
    int minY = grid(y);
    activate(minX, minY, EDGE);
    //flattening problem in one circle
        if(r > (y - cell * minY)) {
          activate(minX, minY - 1, EDGE);
        }
        else if(r > ((minY+1)*cell - y)) {
          activate(minX, minY+1, EDGE);
        }
    return;
  }
  boolean check = (maxX-minX)%2 == 0;
  int prevYTop = grid(y), prevYBottom = prevYTop;
  for(int k = minX; k <= maxX; k++) {
    float nextX = (k + 1) * cell;
    int   nextYTop =     grid(y - sqrt(r*r - sq(nextX - x))),
          nextYBottom =  grid(y + sqrt(r*r - sq(nextX - x)));
    if(k == minX) {
      for(int i = nextYTop; i <= nextYBottom; i++) {
        activate(k, i, EDGE);
      }
    }
    else if(k == maxX) {
      for(int i = prevYTop; i <= prevYBottom; i++) {
        activate(k, i, EDGE);
      }
    }
    else {
      //account for flattening problem
      if(check && k == (maxX + minX) / 2) {
        if(r > (y - cell * nextYTop)) {
          //problem has occured at the top. account for it.
          activate(k, nextYTop - 1, 20*EDGE);
        }
        if(r > ((nextYBottom+1)*cell - y)) {
          //problem has occured at the bottom. account for it.
          activate(k, nextYBottom+1, 20*EDGE);
        }
      }
      
      //add the edges of the top of the circle
      int dir = (int)Math.signum(nextYTop - prevYTop),   i = prevYTop;
      do{
        activate(k, i, EDGE);
        i += dir;
      }while(i != nextYTop);
      activate(k, i, EDGE);
      
      //all in middle
      for(i = max(prevYTop, nextYTop) + 1; i < min(prevYBottom, nextYBottom); i++) activate(k, i, FULL);
      
      //add the edges of the bottom of the circle
      dir = (int)Math.signum(nextYBottom - prevYBottom); i = prevYBottom;
      do{
        activate(k, i, EDGE);
        i += dir;
      }while(i != nextYBottom);
      activate(k, i, EDGE);
    }
    prevYTop = nextYTop;
    prevYBottom = nextYBottom;
  }
}

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






