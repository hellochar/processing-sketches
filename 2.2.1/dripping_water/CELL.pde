float cell_width, cell_height;

class cell {
  private final int x, y;
  cell[] neighbors;
  private float amt;
  private float nextAmt;
  
  cell(int _x, int _y) {
    amt = 0;
    x = _x;
    y = _y;
    initNeighbors();
  }
  
  void initNeighbors() {
    List<cell> neighs = new ArrayList();
    tryAdd(x+1, y, neighs);
    tryAdd(x-1, y, neighs);
    tryAdd(x, y+1, neighs);
    tryAdd(x, y-1, neighs);
    neighbors = neighs.toArray(new cell[0]);
  }
  
  void tryAdd(int x, int y, List neighs) {
    try{
      neighs.add(cellAt(x, y));
    }catch(ArrayIndexOutOfBoundsException e) {
    }
  }
  
  public String toString() {
    return "["+x+", "+y+" = "+amt+"]";
  }
  
  public float getAmt() {
    return amt;
  }
  
  public void setAmt(float val) {
    nextAmt = val;
  }
  
  //natural behavior: diffuse, get pulled by gravity.
  public void run() {
    diffuse.act(this);
    gravity.act(this);
  }
  
  public void update() {
    amt = nextAmt;
  }
  
  public void draw() {
    stroke(128);
    line(x*cell_width, y*cell_width, x*cell_width + cell_width, y*cell_width);
    line(x*cell_width, y*cell_width, x*cell_width, y*cell_width + cell_height);
    
//    noStroke(); fill(color(32, 90, 170, map(amt, 0, 1, 0, 160)));
    noStroke(); fill(map(amt, 0, 1, 0, 255));
    rect(x*cell_width, y*cell_width, cell_width, cell_height);
  }
}
