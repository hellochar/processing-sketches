final float DT = 0.01;
final float K = 2.;

class Cell {
  int x, y;
  
  float position, velocity;
  private float force = 0;
  
  Cell(int x, int y) {
    this.x = x;
    this.y = y;
    this.position = 0;
    this.velocity = 0;
  }
  
  void calculateForce() {
    force = 0;
    if(mousePressed && dist(map(mouseX, 0, width, 0, cells.length), map(mouseY, 0, height, 0, cells[0].length), x, y) < 2) {
      force += 1;
    }
    force += forceFor(1, 0);
    force += forceFor(-1, 0);
    force += forceFor(0, 1);
    force += forceFor(0, -1);
  }
  
  float forceFor(int dx, int dy) {
    float otherPosition = springPosition(x + dx, y + dy);
    float offset = otherPosition - position;
    return offset * K;
  }
  
  void update() {
    velocity += force * DT;
    position += velocity * DT;
    
    float potentialEnergy = 0.5 * K * position*position;
    energy += 
  }
}

Cell[][] cells;

public float energy;

void step() {
  for(int x = 0; x < cells.length; x++) {
    for(int y = 0; y < cells[0].length; y++) {
      cells[x][y].calculateForce();
    }
  }
  
  for(int x = 0; x < cells.length; x++) {
    for(int y = 0; y < cells[0].length; y++) {
      cells[x][y].update();
    }
  }
  
}

float springPosition(int x, int y) {
  if(x < 0 || x >= cells.length ||
     y < 0 || y >= cells[0].length) {
       // boundary conditions = always zero
       return 0;
     } else {
       return cells[x][y].position; 
     }
}

void setup() {
  size(700, 700);
  colorMode(RGB, 1.0);
  cells = new Cell[100][100];
  for(int x = 0; x < cells.length; x++) {
    for(int y = 0; y < cells[0].length; y++) {
      cells[x][y] = new Cell(x, y);
    }
  }
}

void draw() {
  for(int i = 0; i < 20; i++) {
    step();
  }
  println(frameRate);
  scale(width / cells.length, height / cells[0].length);
  for(int x = 0; x < cells.length; x++) {
    for(int y = 0; y < cells[0].length; y++) {
      int col = color(cells[x][y].position + 0.5, cells[x][y].velocity + 0.5, 0);
      fill(col); noStroke();
      rect(x, y, 1, 1);
    }
  }
}
