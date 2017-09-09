class Cell {
  float pos, vel, acc; //the pos denotes the height of the molecule at this location. 
  float lastPos;
  final int x, y;
  ArrayList<Cell> neighbors;
  Grid owner;
  private boolean fixed;
  
  Cell(int x, int y, Grid owner) {
    this.x = x;
    this.y = y;
    assert(x >= 0 && y >= 0 && x < owner.w && y < owner.h);
    this.owner = owner;
//    if(x == 0 || y == 0 || x == owner.w-1 || y == owner.h-1) {
//      fixed = true;
//    }
  }
  
  void clear() {
    pos = vel = acc = 0;
  }
  
  void wallify() {
    fixed = true;
    clear();
  }
  
  private void tryAdd(int i, int j) {
    if(i >= 0 && i < owner.w && j >= 0 && j < owner.h) {
      neighbors.add(owner.cellAt(i, j));
    }
  }
  
  void initNeighbors() {
    //Moore neighborhood
    neighbors = new ArrayList(4);
    tryAdd(x-1, y);
    tryAdd(x+1, y);
    tryAdd(x, y-1);
    tryAdd(x, y+1);
//    for(int i = x-1; i < x+2; i++) {
//      for(int j = y-1; j < y+2; j++) {
//        if(i >= 0 && i < owner.grid.length && j >= 0 && j < owner.grid[0].length) {
//          neighbors.add(owner.grid[i][j]);
//        }
//      }
//    }
//    neighbors.remove(this);
  }
}
