import java.util.*;

// AI pathfinding/learning, with a "rock paper scissors" component
// we have a bunch of agents who have predetermined 
// list of directions to move
// AI lives in a [90x90] grid
// torodial on the X axis
// AI starts in [15, 45, 75]x[80]
// they all want to get to the goal [45, 10]

// AI starts with a random array of directions.
// their goal is to find a set of directions that
// makes them go from the start to the goal
// as fast as possible

// each walker has a "score" that determines how "good"
// this walker was at achieving the goal.
// a walker that dies gets a score of 0
// a walker that hits the goal gets a massive reward 1000
// a walker that gets closer to the goal gets a bigger reward (e.g. 100 - dist)
// a walker that reaches the goal earlier gets a bigger reward (100 - time)

// we start with a ton of walkers, each with randomized movements. 
// some of these will be better, some of these will be worse
// we then create a new generation by taking the top
// 50% scorers, replicating each of them, and mutating them
// e.g. changing 10% of the directions

// then we do it again and again and hope the walkers get better

int gridWidth = 50, gridHeight = 50;

int goalX = gridWidth/2, goalY = 10;

enum Direction { LEFT, RIGHT, UP, DOWN };
Direction[] DIRECTIONS = Direction.values();

enum Status { WALKING, UNFINISHED, DEAD, WON };

class Walker implements Comparable<Walker> {
  int x, y, index = 0;
  Direction[] path;
  Status status;
  Walker(Direction[] path) {
    x = gridWidth/2;
    y = gridHeight - goalY;
    this.path = path;
    status = Status.WALKING;
  }
  
  int compareTo(Walker other) {
    return Float.compare(score(), other.score());
  }
  
  void step() {
    switch (status) {
      case WALKING:
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
  
  // go from walking to dead or won
  Status getStatus() {
    if (x == goalX && y == goalY) {
      return Status.WON;
    }
    if (y < 0 || y >= gridHeight) {
      return Status.DEAD;
    }
    if (index >= path.length) {
      return Status.UNFINISHED;
    }
    return Status.WALKING;
  }
  
  void takeAction(Direction dir) {
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
  }

  // higher score = better
  float score() {
    float d = dist(goalX, goalY, x, y);
    
    float scoreAtGoal = d == 0 ? 1000 : 0;
    float scoreCloseToGoal = -d * 2;
    float scoreTime = -index * 0.1;
    
    return scoreAtGoal + scoreCloseToGoal + scoreTime;
  }
  
  // change 10% of the directions
  Walker mutate() {
    Direction[] newPath = new Direction[path.length];
    arrayCopy(path, newPath);
    while(random(1) > 0.1) {
      int idx = (int)random(0, newPath.length);
      newPath[idx] = randomDirection();
    }
    return new Walker(newPath);
  }
  
  // make no mutation, just reset the other state
  Walker reset() {
    return new Walker(path);
  }
}

int wrap(int k, int w) {
  return ((k % w) + w) % w;
}

Direction randomDirection() {
  return DIRECTIONS[(int)random(0, DIRECTIONS.length)];
}

Direction[] randomPath(int len) {
  Direction[] path = new Direction[len];
  for (int i = 0; i < len; i++) { 
    path[i] = randomDirection();
  }
  return path;
}

class Generation {
  List<Walker> population;
  int age = 0;
  Generation(List<Walker> population) {
    this.population = population;
  }
  
  public void step() {
    for (Walker w : population) {
      w.step();
    }
    age++;
  }
  
  public Generation nextGeneration() {
    // sort the current population by fitness
    // take the top half
    // copy the top half, mutating each one
    // that's the new population
    //population.sort(null);
    Collections.sort(population, Collections.reverseOrder());
    List<Walker> topHalf = population.subList(0, population.size() / 2);
    //List<Walker> topHalfMutated = new ArrayList(topHalf.size());
    List<Walker> nextGen = new ArrayList(population.size());
    for (Walker w : topHalf) {
      nextGen.add(w.reset());
      nextGen.add(w.mutate());
    }
    return new Generation(nextGen);
  }
}

public Generation randomGeneration() {
  List<Walker> generation = new ArrayList();
  for (int i = 0; i < 50; i++) {
    Walker walker = new Walker(randomPath(GEN_LIFETIME));
    generation.add(walker);
  }
  return new Generation(generation);
}

Generation gen;
final int GEN_LIFETIME = 200;

void setup() {
  size(900, 900, P2D);
  smooth(8);
  gen = randomGeneration();
}

void draw() {
  for (int i = 0; i < 20; i++) {
    gen.step();
  }
  if (gen.age >= GEN_LIFETIME) {
    gen = gen.nextGeneration();
  }
  
  background(1, 26, 39);
  // draw grid
  strokeWeight(1);
  stroke(#88847d);
  float DS = 15;
  for(int x = 0; x <= gridWidth; x++) {
    float px = x * DS;
    line(px, 0, px, gridHeight * DS);
  }
  for(int y = 0; y <= gridHeight; y++) {
    float py = y * DS;
    line(0, py, gridWidth * DS, py);
  }
  for (Walker w : gen.population) {
    float px = w.x * DS;
    float py = w.y * DS;
    text((int)w.score(), px, py);
    fill(#fcfdf1);
    ellipse(px + DS/2, py + DS/2, DS, DS);
  }
  fill(255, 128, 0);
  rect(goalX * DS, goalY * DS, DS, DS);
  //frameRate(10);
}