class Cell {
  private float nextAmount;
  private float thisAmount;
  int x, y;
  World owner;
  private Map<Integer, List<Cell>> neighborCache;

  Cell(World owner, int x, int y, float amount) {
    this.owner = owner;
    this.x = x;
    this.y = y;
    nextAmount = amount;
    thisAmount = amount;
    neighborCache = new HashMap();
  }

  float amount() {
    return thisAmount;
  }

  List<Cell> neighborsInRadius(int radius) {
    if (!neighborCache.containsKey(radius)) {
      List<Cell> neighbors = new ArrayList((int)(PI * radius * radius));
      for (int i = -radius; i <= radius; i++) {
        for (int j = -radius; j <= radius; j++) {
          if (dist(i, j, 0, 0) <= radius) {
            neighbors.add(owner.getCell(x + i, y + j));
          }
        }
      }
      neighborCache.put(radius, neighbors);
    }
    return neighborCache.get(radius);
  }

  void step() {
    int radiusIncrease = 3;
    int radiusDecrease = 6;

    float avgIncrease = owner.averageAmount(x, y, radiusIncrease), 
    avgDecrease = owner.averageAmount(x, y, radiusDecrease);

    if (avgIncrease > avgDecrease) {
      setAmount(amount() + owner.EPSILON);
    } 
    else {
      setAmount(amount() - owner.EPSILON);
    }
  }

  void setAmount(float amount) {
    nextAmount = amount;

    if (amount > owner.maxAmount) {
      owner.maxAmount = amount;
    }
    if (amount < owner.minAmount) {
      owner.minAmount = amount;
    }
  }

  void updateAndNormalize() {
    thisAmount = map(nextAmount, owner.minAmount, owner.maxAmount, -1, 1);
  }
}

class World {

  int width, height;
  Cell[][] cells;
  float minAmount, maxAmount;
  float EPSILON = .01; 

  World(int width, int height) {
    this.width = width;
    this.height = height;
    cells = new Cell[width][height];
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        cells[x][y] = new Cell(this, x, y, random(-1, 1));
      }
    }
  }

  void step() {
    minAmount = 99999;
    maxAmount = -99999;

    // run diffusion and activation
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        cells[x][y].step();
      }
    }

    // normalize
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        cells[x][y].updateAndNormalize();
      }
    }
  }

  float averageAmount(int x, int y, int radius) {
    float amount = 0;
    List<Cell> neighbors = getCell(x, y).neighborsInRadius(radius);
    for(Cell c : neighbors) {
      amount += c.amount();
    }
    return amount / neighbors.size();
  }
  
  Cell getCell(int x, int y) {
    x = (x % width + width) % width;
    y = (y % height + height) % height;
    return cells[x][y];
  }

  //does wrapping
  float getAmount(int x, int y) {
    return getCell(x, y).amount();
  }
}

