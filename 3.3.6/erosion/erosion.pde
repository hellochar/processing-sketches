import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

// terrain/erosion simulation.
// start with a grid of cells.
// each cell has an amount of rock
// and an amount of water

// we do an iteration to figure out
// the new amount of rock and water in the next step

// water flows from higher levels to lower levels (level = rock + water)
// when water flows, it moves a small amount of rock
// proportional to its flow as well

class Cell {
  int x, y;
  float water;
  float rock;
  
  float nextWater;
  float nextRock;
  
  Cell(int x, int y, float water, float rock) {
    this.x = x;
    this.y = y;
    this.water = water;
    this.rock = rock;
    nextWater = water;
    nextRock = rock;
  }
  
  // the rules are:
  // give more as the level difference is more
  // don't give more water combined than you have total
  void computeNextState() {
    Cell up = cellAt(x, y - 1);
    Cell down = cellAt(x, y + 1);
    Cell left = cellAt(x - 1, y);
    Cell right = cellAt(x + 1, y);
    float upContrib = computeWaterContribution(up);
    float downContrib = computeWaterContribution(down);
    float leftContrib = computeWaterContribution(left);
    float rightContrib = computeWaterContribution(right);
    float sum = upContrib + leftContrib + downContrib + rightContrib;

    if (sum > 0) {
      // give up to some amount factor of your water each turn proportional to the sum, say, sum / (sum+10); should be between 0 to 1
      // furthermore, only give up to 10% of your water each turn
      float percentageOfWaterToGive = sum / (sum+1) * 0.25;
      // now distribute this further amongst the neighbors according to their individual weights
      float totalWaterToGive = this.water * percentageOfWaterToGive;
      giveWater(up, totalWaterToGive, upContrib, sum);
      giveWater(down, totalWaterToGive, downContrib, sum);
      giveWater(left, totalWaterToGive, leftContrib, sum);
      giveWater(right, totalWaterToGive, rightContrib, sum);
      //println(upContrib, downContrib, leftContrib, rightContrib, sum, percentageOfWaterToGive, totalWaterToGive, nextWater);
    }
  }
  
  // totalWaterToGive = water ranging from 0 to this.water
  // amountNormalized = percentage ranging from 0 to 1
  void giveWater(Cell other, float totalWaterToGive, float contrib, float sum) {
    float amount = totalWaterToGive * contrib / sum;
    other.nextWater += amount;
    this.nextWater -= amount;
    // when you give water, also give a tiny bit of sediment to them if your rock level is taller than theirs
    if (this.rock > other.rock && totalWaterToGive > 0.1) {
      // this is smoothing things out, where I want it to be *more* imbalanced
      float rockDiff = this.rock - other.rock;
      //float rockGiveFactor = rockDiff / (rockDiff + 0.1) * 1;
      float rockGiveFactor = 0.1;
      float rockGiveAmount = rockDiff * (contrib / sum) * rockGiveFactor;
      // eh just fuck it; technically here we could break energy conservation but lets just see what happens
      
      other.nextRock += rockGiveAmount;
      this.nextRock -= rockGiveAmount;
    }
    //float rockContrib = 
    //other.nextRock += amount * 0.01;
    //this.nextRock -= amount * 0.01;
  }
  
  float computeWaterContribution(Cell other) {
    float levelDifference = this.level() - other.level(); // positive means I flow into them
    if (levelDifference <= 0) {
      // don't process me; the other will give water to me on their computation 
      return 0;
    }
    
    // give more as the level difference is more
    return levelDifference * levelDifference * levelDifference * levelDifference * levelDifference;
  }
  
  void updateState() {
    this.water = nextWater;
    this.rock = nextRock;
  }
  
  float level() {
    return water + rock;
  }
  
  void vertexRock() {
    vertex(x, y, this.rock);
  }
  
  void vertexLevel() {
    vertex(x, y, this.level());
  }
}

float prand(float x, float y) {
  return abs(sin(x * 23.3941 + y * 569.1232) * 9504.349301) % 1;
}

float ridgeRand(float x, float y) {
  return prand(floor(x), floor(y));
}

float fract(float x) {
  return x - floor(x);
}

float hermite(float x) {
  return x * x * (3 - 2 * x);
}

float linearRand(float x, float y) {
  float r00 = ridgeRand(x, y);
  float r10 = ridgeRand(x+1, y);
  float r01 = ridgeRand(x, y+1);
  float r11 = ridgeRand(x+1, y+1);
  
  float lerpX = hermite(fract(x));
  float lerpY = hermite(fract(y));
  
  float xLin0 = lerp(r00, r10, lerpX);
  float xLin1 = lerp(r01, r11, lerpX);
  return lerp(xLin0, xLin1, lerpY);
}

float octaveNoise(float x, float y) {
  float sum = 0;
  float amplitude = 0.5;
  
  for (int i = 0; i < 8; i++) {
    float r = linearRand(x, y);
    sum += r * amplitude;
    float xNext = x * 2 * cos(PI/3) - y * 2 * sin(PI/3);
    float yNext = x * 2 * sin(PI/3) + y * 2 * cos(PI/3);
    x = xNext;
    y = yNext;
    amplitude *= 0.5;
  }
  return sum;
}

float noiseFn(float x, float y) {
  return octaveNoise(x / 100, y / 100);
}

int CELL_WIDTH = 250;
int CELL_HEIGHT = 250;

Cell[][] cells;

Cell cellAt(int x, int y) {
  int modX = ((x % CELL_WIDTH) + CELL_WIDTH) % CELL_WIDTH;
  int modY = ((y % CELL_HEIGHT) + CELL_HEIGHT) % CELL_HEIGHT;
  return cells[modX][modY];
}

void setup() {
  size(800, 600, P3D);
  cells = new Cell[CELL_WIDTH][CELL_HEIGHT];
  for (int i = 0; i < CELL_WIDTH; i++) {
    for (int j = 0; j < CELL_HEIGHT; j++) {
      //cells[i][j] = new Cell(i, j, random(1) * random(1) * random(1) * 15, noiseFn(i, j) * 2000);
      
      cells[i][j] = new Cell(i, j,
        //random(1) * random(1) * random(1) * 15,
        15,
        (sin((i + j) / 100f)+1)/2 * 2000
      );
    }
  }
  new PeasyCam(this, 500);
}

void draw() {
  background(255);
  lights();
  if (keyPressed) {
    iterate();
  }
  
  translate(-CELL_WIDTH/2 * 10, -CELL_HEIGHT/2 * 10);
  scale(10, 10);
  drawQuads();
  //drawPoints();
}

void iterate() {
  for (int i = 0; i < CELL_WIDTH; i++) {
    for (int j = 0; j < CELL_HEIGHT; j++) {
      cells[i][j].computeNextState();
    }
  }
  for (int i = 0; i < CELL_WIDTH; i++) {
    for (int j = 0; j < CELL_HEIGHT; j++) {
      cells[i][j].updateState();
    }
  }
  checkEnergyConservation();
}

void checkEnergyConservation() {
  float totalRock = 0;
  float totalWater = 0;
  for (int i = 0; i < CELL_WIDTH; i++) {
    for (int j = 0; j < CELL_HEIGHT; j++) {
      Cell c = cells[i][j];
      totalRock += c.rock;
      totalWater += c.water;
    }
  }
  println("totalRock:", totalRock, "totalWater:", totalWater);
}

void drawPoints() {
  for (int i = 0; i < CELL_WIDTH-1; i++) {
    for (int j = 0; j < CELL_HEIGHT-1; j++) {
      stroke(#964B00);
      point(i, j, cells[i][j].rock);
      stroke(161, 196, 252, 64);
      point(i, j, cells[i][j].level());
    }
  }
}

void drawQuads() {
  noStroke();
  fill(#964B00); // brown for rock
  beginShape(QUADS);
  for (int i = 0; i < CELL_WIDTH-1; i++) {
    for (int j = 0; j < CELL_HEIGHT-1; j++) {
      cells[i][j].vertexRock();
      cells[i+1][j].vertexRock();
      cells[i+1][j+1].vertexRock();
      cells[i][j+1].vertexRock();
    }
  }
  endShape();
  fill(161, 196, 252, 192); // light blue for water
  beginShape(QUADS);
  for (int i = 0; i < CELL_WIDTH-1; i++) {
    for (int j = 0; j < CELL_HEIGHT-1; j++) {
      Cell c00 = cells[i][j];
      Cell c10 = cells[i+1][j];
      Cell c11 = cells[i+1][j+1];
      Cell c01 = cells[i][j+1];
      if (c00.water > 1 && c10.water > 1 && c11.water > 1 && c01.water > 1) {
        c00.vertexLevel();
        c10.vertexLevel();
        c11.vertexLevel();
        c01.vertexLevel();
      }
    }
  }
  endShape();
}