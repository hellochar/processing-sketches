
enum Status { RUNNING, UNFINISHED, DEAD, WON };

class Runner implements Comparable<Runner> {
  int x, y, index = 0;
  Direction[] path;
  Status status;
  Runner(Direction[] path) {
    x = gridWidth/2;
    y = gridHeight - goalY;
    this.path = path;
    status = Status.RUNNING;
  }
  
  int compareTo(Runner other) {
    return Float.compare(score(), other.score());
  }
  
  void step() {
    switch (status) {
      case RUNNING:
        Direction dir = path[index];
        takeAction(dir);
        index++;
        status = getStatus();
        break;
      
      // these are all "end of generation" statuses
      case UNFINISHED:
      case DEAD:
      case WON:
      break;
    }
  }
  
  // go from running to dead or won
  Status getStatus() {
    if (x == goalX && y == goalY) {
      return Status.WON;
    }
    if (y < 0 || y >= gridHeight) {
      return Status.DEAD;
    }
    if (obstructed[x][y]) {
      return Status.DEAD;
    }
    if (index >= path.length) {
      return Status.UNFINISHED;
    }
    return Status.RUNNING;
  }
  
  void takeAction(Direction dir) {
    numRunners[y * gridWidth + x]--;
    int ox = x, oy = y;
    if (dir == Direction.LEFT) {
      x = wrap(x - 1, gridWidth);
    } else if (dir == Direction.RIGHT) {
      x = wrap(x + 1, gridWidth);
    } else if (dir == Direction.UP) {
      y -= 1;
    } else if (dir == Direction.DOWN) {
      y += 1;
    } else {
      throw new Error("invalid direction" + dir);
    }
    if (y >= 0 && y < gridHeight) {
      boolean isInObstacle = obstructed[x][y];
      //boolean isInObstacle = false;
      boolean isOnAnotherRunner = false; // numRunners[y * gridWidth + x] > 0;
      if (isInObstacle || isOnAnotherRunner) {
        x = ox;
        y = oy;
      }
      numRunners[y * gridWidth + x]++;
    }
  }

  // higher score = better
  float score() {
    float d = dist(goalX, goalY, x, y);
    
    float scoreAtGoal = d == 0 ? 1000 : 0;
    float scoreCloseToGoal = -d * 0;
    float scoreTime =
      status == Status.DEAD ? index * 0.1 :
      status == Status.WON ? (index * -0.1) :
      0;
    float scoreDead = status == status.DEAD ? -1000 : 0;
    
    return scoreAtGoal + scoreCloseToGoal + scoreTime + scoreDead;
  }
  
  // change 10% of the directions
  Runner mutate() {
    // very small chance - completely rerandom
    if (random(1) < 0.01) {
      return new Runner(randomPath());
    }
    Direction[] newPath = new Direction[path.length];
    arrayCopy(path, newPath);
    do {
      //int idx = (int)random(0, newPath.length);
      int idx = (int)random(0, index);
      newPath[idx] = randomDirection();
    } while (random(1) < continuationChance);
    return new Runner(newPath);
  }
  
  // make no mutation, just reset the other state
  Runner reset() {
    return new Runner(path);
  }
}

int wrap(int k, int w) {
  return ((k % w) + w) % w;
}