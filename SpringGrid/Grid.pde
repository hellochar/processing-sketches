class Grid implements Iterable<Cell> {
  private Cell[][] grid;

  float kSelfValue = 0, //each cell gets this acceleration for being 1 pixel up/down
  kNeighborValue = 1000, //each cell gets this much velocity for being 1 pixel away from its neighbors, after 1 second.
  //the velocity is a function of k and i'm not sure what else. at k = 1000, v = 11.037
  dragFactor = .02; //the velocity will drop to (1-dragFactor)% of it's original velocity after 1 second.

  float timeStep = .02; //you need a very good timeStep or else the errors in simulation will propagate and cell positions will diverge.
  float timeElapsed = 0;

  float avgPos;

  RunMethod runMethod;
  UpdateMethod updateMethod;
  
  Collection<Emitter> emitters;
  
  final int w, h;
  final int multX,
            multY;

  Grid(int w, int h, RunMethod rm, UpdateMethod um) {
    this.w = w; this.h = h;
    multX = width / w;
    multY = height / h;
    assert (float)width/w %1 < 1e-5;
    assert (float)height/h %1 < 1e-5;
    grid = new Cell[w][h];
    runMethod = rm;
    updateMethod = um;
    emitters = new HashSet();
    initGridList();
    for(int x = 0; x < grid.length; x++) {
      for(int y = 0; y < grid[0].length; y++) {
        grid[x][y] = new Cell(x, y, this);
      }
    }
    for(Cell c : this) {
      c.initNeighbors();
    }
  }
  
  void clear() {
    for(Cell c : this) {
      c.clear();
    }
  }

  void step() {
    for(Cell c : this) {
      runMethod.run(c);
    }
    for(Emitter e : emitters) {
      e.run();
    }
    avgPos = 0;
    for(Cell c : this) {
      c.lastPos = c.pos;
      if(!c.fixed)
        updateMethod.update(c);
      avgPos += c.pos;
    }
    avgPos /= w*h;
    timeElapsed += timeStep;
  }
  
  public int g2sX(int gridX) {
    return gridX*multX;
  }
  
  public int g2sY(int gridY) {
    return gridY*multY;
  }
  
  public int s2gX(int screenX) {
    return screenX/multX;
  }
  
  public int s2gY(int screenY) {
    return screenY/multY;
  }
  
  void droplet(int x, int y) {
    cellAt(x, y).pos += 1000;
  }

  Cell cellAt(int x, int y) {
    if(!inBounds(x, y)) return null;
    return grid[x][y];
  }
  
  protected void vert(int x, int y, float z) {
    vertex(g2sX(x), g2sY(y), z);
  }
  
  boolean inBounds(int x, int y) {
    return x >= 0 && x < w && y >= 0 && y < h;
  }
  
  public void addEmitter(Emitter e) {
    emitters.add(e);
    e.setOwner(this);
  }
  
  private List<List<Cell>> gridList;
  
  private void initGridList() {
    gridList = new ArrayList(w);
    for(int i = 0; i < w; i++) {
      gridList.add(Arrays.asList(grid[i]));
    }
  }
  
  public Iterator<Cell> iterator() {
    return new Iterator() {
      Iterator<List<Cell>> rowIterator = gridList.iterator();
      Iterator<Cell> curColIterator = rowIterator.next().iterator();
      public boolean hasNext() {
        if(curColIterator.hasNext()) {
          return true;
        }
        else if(rowIterator.hasNext()) {
          curColIterator = rowIterator.next().iterator();
          return true;
        }
        else {
          return false;
        }
      }
      
      public Cell next() {
        if(curColIterator.hasNext()) {
          return curColIterator.next();
        }
        else if(rowIterator.hasNext()) {
          curColIterator = rowIterator.next().iterator();
          return curColIterator.next();
        }
        else {
          throw new NoSuchElementException();
        }
      }
      
      public void remove() {
        throw new RuntimeException("Unsupported!");
      }
      
    };
  }
}

