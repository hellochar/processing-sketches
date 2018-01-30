import java.util.*;

// goal - randomly generate a cellular automata rule. The description of a CA:
// CA = { states, xy grid of cells, state transitions }
// states = enum of arbitrary objects e.g. "state A, state B, state C"
// xy grid of cells = 2D discrete array; each cell is one state
// state transitions = a set of functions, one for each state, that takes as input an array of cell neighbors, and outputs a state

// examples of state transitions
// t_A(neighbors) =
//   A if neighbors have 3+ A's
//   B if neighbors have more B's than A's
//   C otherwise

// t_B(neighbors) =
//   B if neighbors have less B's than others
//   C if neighbors have 2+ C's
//   A otherwise

// for this sketch we'll represent a state transition as a vector of numbers of length |states|:
// t_A = [0, 2, 1]
// where t_A[j] = "transition to state j if neighbors have t_A[j] of state j
// first one wins, so earlier states have higher priority

// random generation of state transition vector
// neighbors is always of length 8
// each value should be inside [0, 8]
// honestly 2-3 is probably a good value

class CA {
  int numStates; // states 0, 1, ..., numStates - 1
  int width; // = (int)random(25, 101);
  int height; // = (int)random(25, 101);
  int[][][] cells;
  int bufferIndex = 0;
  int[][] transitions; // transitions[i] = transition vector for state i
  PImage img;
  int colorOffset = (int)random(colors.length);
  int seed;
  
  CA(int seed) {
    this.seed = seed;
    // width = height = 100;
    // width = height = 50 + 10 * (int)random(10);
    width = height = 50;
    img = createImage(width, height, RGB);
    numStates = (int)random(2, 10); // [2, 9] inclusive
    cells = new int[2][width][height];
    // fill in random cells
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        cells[bufferIndex][i][j] = (int)random(0, numStates);
      }
    }
    transitions = new int[numStates][numStates];
    // fill in transitions
    for (int transitionState = 0; transitionState < numStates; transitionState++) {
      for (int tempState = 0; tempState < numStates; tempState++) {
        transitions[transitionState][tempState] = (int)random(1, 8);
      }
    }
    draw();
  }
  
  void draw() {
    img.loadPixels();
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        img.pixels[j*width + i] = getColorOfState(cells[bufferIndex][i][j]);
      }
    }
    img.updatePixels();
  }
  
  void step() {
    int nextBuffer = (bufferIndex + 1) % 2;
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        cells[nextBuffer][i][j] = computeNextState(i, j);
      }
    }
    bufferIndex = nextBuffer;
  }
  
  int computeNextState(int i, int j) {
    int myState = getState(i, j);
    int[] countStatesOfNeighbors = new int[numStates];
    for (int di = -1; di <= 1; di++) {
      for (int dj = -1; dj <= 1; dj++) {
        if (di == 0 && dj == 0) continue;
        int neighborState = getState(i + di, j + dj);
        countStatesOfNeighbors[neighborState]++;
      }
    }
    
    // now, iterate through neighbor state counts and flip to the first one that matches
    for (int s = 0; s < numStates; s++) {
      if (countStatesOfNeighbors[s] == transitions[myState][s]) {
        // we hit!
        return s;
      }
    }
    return myState;
  }
  
  int getState(int i, int j) {
    i = ((i % width) + width) % width;
    j = ((j % height) + height) % height;
    return cells[bufferIndex][i][j];
  }
  
  color getColorOfState(int state) {
    if (state == 0) {
      return #000000;
    }
    return colors[(state + colorOffset) % colors.length];
  }
}

List<int[][]> history = new LinkedList();

color[] colors = { #1F4B99, #3E769E, #6B9FA1, #ABC4A2, #FFE39F, #EEB46C, #D78742, #BC5B22, #9E2B0E };

CA[] cas = new CA[1];

void settings() {
//  size(1000 + 5 * 20, 200 + 1 * 20);
  size(800, 600, P3D);
  noSmooth();
}

void setup() {
  newCAs(416123904);
//  newCAs((int)random(Integer.MAX_VALUE - 1));
  //drawCAs();
  for (int i = 0; i < 50; i++) {
    for (int j = 0; j < 25; j++) {
      cas[0].step();
    }
    recordGridHistory(cas[0]);
  }
}

void newCAs(int seed) {
  randomSeed(seed);
  for (int i = 0; i < cas.length; i++) {
    cas[i] = new CA(seed);
  }
}

void drawCAs() {
  for (int i = 0; i < cas.length; i++) {
    //image(cas[i].img, i * 220 + 10, 10, 200, 200);
    image(cas[i].img, 25, 25, 600, 600);
    textSize(20);
    text(cas[i].seed, 25, 20);
  }
}

void keyPressed() {
  int seed = (int)random(Integer.MAX_VALUE - 1);
  if (key == ' ') {
    newCAs(seed);
  }
}

void draw() {
  background(225);
  //for (int i = 0; i < cas.length; i++) {
    //for (int j = 0; j < 1; j++) {
    //  cas[i].step();
    //}
    //cas[i].draw();
  //}
  //drawCAs();
  lights();
  noStroke();
  float angle = millis() / 6000f;
  float dist = 1 * (300 + map(sin(millis() / 10000f), -1, 1, 0, height) / 10);
  camera(
    dist * cos(angle + mouseX / 100f),
    dist * sin(angle + mouseX / 100f),
    mouseY / 2,
    0, 0, 0,
    0, 0, -1
  );

  scale(5);
  translate(-cas[0].width/2, -cas[0].height/2);
  for (int i = 0; i < history.size(); i++) {
    int[][] cells = history.get(i);
    for (int x = 0; x < cas[0].width; x++) {
      for (int y = 0; y < cas[0].height; y++) {
        int state = cells[x][y];
        if (state == stateToLookAt) {
          fill(cas[0].getColorOfState(state));
          pushMatrix();
          translate(x, y, i);
          box(1);
          popMatrix();
        }
      }
    }
  }
  println(frameRate);
}

int stateToLookAt = 0;

void mousePressed() {
  stateToLookAt = (stateToLookAt + 1) % cas[0].numStates;
}

void recordGridHistory(CA ca) {
  int[][] originalCells = ca.cells[ca.bufferIndex];
  int[][] clone = originalCells.clone();
  for (int i = 0; i < clone.length; i++) {
    clone[i] = clone[i].clone();
  }
  history.add(clone);
}