import com.hamoid.*;

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

// each runner has a "score" that determines how "good"
// this runner was at achieving the goal.
// a runner that dies gets a score of 0
// a runner that hits the goal gets a massive reward 1000
// a runner that gets closer to the goal gets a bigger reward (e.g. 100 - dist)
// a runner that reaches the goal earlier gets a bigger reward (100 - time)

// we start with a ton of runners, each with randomized movements. 
// some of these will be better, some of these will be worse
// we then create a new generation by taking the top
// 50% scorers, replicating each of them, and mutating them
// e.g. changing 10% of the directions

// then we do it again and again and hope the runners get better

String videoName = "mazerunner_learnedhelplessness.mp4";

float continuationChance = 0.1;

final int GEN_LIFETIME = 500;
final int gridWidth = 30, gridHeight = 30;
final int goalX = gridWidth/2, goalY = 5;

boolean[][] obstructed = new boolean[gridWidth][gridHeight];
// surround the perimeter with obstructions
//{
//  for(int x = 0; x < gridWidth; x++) {
//    obstructed[x][0] = true;
//    obstructed[x][gridHeight-1] = true;
//  }
//  for(int y = 0; y < gridHeight; y++) {
//    obstructed[0][y] = true;
//    obstructed[gridWidth-1][y] = true;
//  }
//}
int[] numRunners = new int[gridWidth * gridHeight];

Generation gen, prevGen;
int genNumber = 0;

float DS;

VideoExport export;

void setup() {
  size(800, 800, P2D);
  smooth(8);
  DS = (float)width / gridWidth;
  gen = randomGeneration();
  export = new VideoExport(this, videoName);
  export.setFrameRate(30);
  export.startMovie();
  frameRate(30);
}


void mouseDragged() {
  int ix = (int)(mouseX / DS);
  int iy = (int)(mouseY / DS);
  if (ix >= 0 && ix < gridWidth && iy >= 0 && iy < gridHeight) {
    obstructed[ix][iy] = mouseButton == LEFT ? true : false;
  }
}

boolean isFast = true;

void keyPressed() {
  if (key == ' ') {
    isFast = !isFast;
  }
}

void draw() {
  //boolean isFast = false; // !(keyPressed && key == ' ');
  background(1, 26, 39);
  //fill(1, 26, 39, 20);
  //noStroke();
  //rect(0, 0, width, height);
  //goalX = (int)map(sin(frameCount / 60f), -1, 1, 0, gridWidth);
  
  if (gen.age >= GEN_LIFETIME) {
    prevGen = gen;
    gen = gen.nextGeneration();
    genNumber++;
  }
  for (int i = 0; i < (isFast ? GEN_LIFETIME : 1); i++) {
    gen.step();
    for (Runner w : gen.population) {
      float px = w.x * DS;
      float py = w.y * DS;
      //text((int)w.score(), px, py);
      //blendMode(ADD);
      fill(#fcfdf1, isFast ? 12 : 128);
      noStroke();
      //fill(#fcfdf1);
      //fill(lerpColor(color(255, 64, 64), color(64, 255, 64), (20 + w.score()) / 20), 12);
      ellipse(px + DS/2, py + DS/2, DS, DS);
    }
  }
  
  // draw grid
  strokeWeight(1);
  stroke(#88847d, 64);
  for(int x = 0; x <= gridWidth; x++) {
    float px = x * DS;
    line(px, 0, px, gridHeight * DS);
  }
  for(int y = 0; y <= gridHeight; y++) {
    float py = y * DS;
    line(0, py, gridWidth * DS, py);
  }
  //for (Runner w : gen.population) {
  //  float px = w.x * DS;
  //  float py = w.y * DS;
  //  text((int)w.score(), px, py);
  //  fill(#fcfdf1);
  //  ellipse(px + DS/2, py + DS/2, DS, DS);
  //}
  for (int x = 0; x < gridWidth; x++) {
    for (int y = 0; y < gridHeight; y++) {
      if (obstructed[x][y]) {
        fill(#f3d210); //yellow obstruction
        //fill(255, 64, 75);
        rect(x * DS, y * DS, DS, DS);
      }
    }
  }
  fill(128, 223, 64);
  rect(goalX * DS, goalY * DS, DS, DS);
  int numAtGoal = 0;
  for (Runner w : gen.population) {
    if (w.x == goalX && w.y == goalY) {
      numAtGoal++;
    }
  }
  if (numAtGoal > 0) {
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(numAtGoal, (goalX+0.5)*DS, (goalY + 0.5) * DS);
  }
  
  //frameRate(10);
  fill(255, 255, 0);
  rect(0, 0, map(gen.age, 0, GEN_LIFETIME, 0, width), 10);
  textAlign(LEFT, TOP);
  textSize(16);
  fill(255);
  text("Generation " + genNumber, 0, 10);
  if (keyPressed && key == 'i') {
    drawPrevGenScores();
  }
  export.saveFrame();
}

void drawPrevGenScores() {
  if (prevGen == null) return;
  pushMatrix();
  fill(0, 192);
  rect(0, 0, width, height);
  fill(255);
  stroke(255);
  for (int rank = 0; rank < prevGen.population.size(); rank++) {
    Runner r = prevGen.population.get(rank);
    drawRunnerScore(r, rank);
    translate(0, textAscent() + textDescent());
  }
  popMatrix();
}

void drawRunnerScore(Runner r, int rank) {
  String text = (rank+1) + ": " + r.score();
  text(text, 0, 0);
  pushMatrix();
  translate(130, (textAscent() + textDescent()) / 2);
  drawPath(r.path);
  popMatrix();
}

void drawPath(Direction[] path) {
  for (Direction d : path) {
    drawDirection(d);
    translate(12, 0);
  }
}

void exit() {
  export.endMovie();
  super.exit();
}