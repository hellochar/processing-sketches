PGraphics img;

void setup() {
  size(500, 500);
}

void draw() {
  background(255);
  
}

class Landscape {
  protected State[][] states;
  public DrawMode mode;
  
  public State getState(int x, int y) {
    try{
      return states[x][y];
    }catch(ArrayIndexOutOfBoundsException e) {
      return null;
    }
  }
  
  public int getWidth() {
    return states.length;
  }
  
  public int getHeight() {
    return states[0].length;
  }
  
  public void draw() {
    mode.draw();
  }
  
}

interface State {
  
}

abstract class CALandscape extends Landscape {
  
  public CALandscape(State[] init, int height) {
    states = new State[init.length][height];
    for(int i = 0; i < init.length; i++) {
      states[i][0] = init[i];
    }
    calculate(1);
  }
  
  private void calculate(int y) {
    if(y >= getHeight()) return;
    for(int x = 0; x < getWidth(); x++) {
      states[x][y] = calculateState(x, y);
    }
    calculate(y+1);
  }
  
  abstract State calculateState(int x, int y);
  
}

abstract class PrevNeighborLandscape extends CALandscape {
  public PrevNeighborLandscape(State[] init, int height) {
    super(init, height);
  }
  
  State calculateState(int x, int y) {
    return fromPrevious(getState(x-1, y-1), getState(x-1, y), getState(x-1, y+1));
  }
  
  abstract State fromPrevious(State left, State above, State right);
}

class MyPNL extends PrevNeighborLandscape {
  
  public PrevNeighborLandscape(State[] init, int height) {
    super(init, height);
  }
  
  State fromPrevious(State left, State above, State right) {
    
  }
}
