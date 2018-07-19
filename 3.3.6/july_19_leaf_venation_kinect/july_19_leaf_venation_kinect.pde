import java.util.*;

enum ReasonStopped {
  Expensive, Crowded
};

Leaf[] leaves;

boolean liveMorph = false;

void setup() {
  size(960, 540);
  noiseSeed(0);
  initLeafSingle();
  //initLeafGrid();
}

void initLeafSingle() {
  leaves = new Leaf[1];
  leaves[0] = new Leaf(width/6, height/2, 4);
  for (int z = 0; z < 10000; z++) {
    leaves[0].expandBoundary();
    if (leaves[0].finished) {
      break;
    }
    println(z);
  }
}

void initLeafGrid() {
  int gridHeight = 6;
  int gridWidth = 9;
  leaves = new Leaf[gridWidth * gridHeight];
  for (int i = 0; i < leaves.length; i++) {
    float x = i % gridWidth + 0.5;
    float y = i / gridWidth + 0.5;
    Leaf leaf;
    do {
      leaf = new Leaf(
        map(x - 0.4, 0, gridWidth, 0, width), 
        map(y, 0, gridHeight, 0, height), 
        1.75
        );

      //leaf.MAX_PATH_COST = 150;
      // leaf.AVOID_NEIGHBOR_FORCE = map(y, 0, gridHeight, 0, 0);
      // leaf.DEPTH_STEPS_BEFORE_BRANCHING = (int)map(x, 0, gridWidth, 1, 5);
      // leaf.SIDE_ANGLE = map(x, 0, gridWidth, PI / 8, PI / 2);
      // leaf.SIDEWAYS_COST_RATIO = map(y, 0, gridHeight, 0.0, 0.2);
      //leaf.BASE_DISINCENTIVE = pow(10, map(x, 0, gridWidth, 0, 5));
      //leaf.TURN_TOWARDS_X_FACTOR = map(y, 0, gridHeight, 0.01, 1.0);
      //leaf.STRAIGHT_INCENTIVE_FACTOR = map(x, 0, gridWidth, 0, 10);

      for (int z = 0; z < 1000; z++) {
        leaf.expandBoundary();
        //if (leaves[0].finished) {
        //println(z);
        //}
      }
    } while (leaf.isDegenerate());
    println(i);
    leaves[i] = leaf;
  }
}

void mousePressed() {
  if (!liveMorph) {
    if (mouseButton == LEFT) {
      for (Leaf l : leaves) {
        l.expandBoundary();
      }
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    initLeafSingle();
  }
}

void draw() {
  background(255);
  if (mousePressed && mouseButton == RIGHT) {
    scale(5);
    float centerX = mouseX;
    float centerY = mouseY;
    float leftX = centerX;
    float topY = centerY;
    translate(-leftX, -topY);
  }
  // translate(0, height / 2);
  //scale(0.5, 0.5);

  //leaves[0].expandBoundary();
  //if (keyPressed && key == ' ') {
  //  initLeafSingle();

  //  leaves[0].SECONDARY_BRANCH_SCALAR = 0.85;
  //  leaves[0].SECONDARY_BRANCH_PERIOD = max(1, (int)map(mouseY, 0, height, 1, 10));
  //  leaves[0].DEPTH_STEPS_BEFORE_BRANCHING = max(1, (int)map(mouseX, 0, width, 1, 6));
  //}

  if (liveMorph && mousePressed && mouseButton == LEFT) {
    initLeafSingle();
    //leaves[0].BASE_DISINCENTIVE = pow(10, map(cos(millis() / 450f), -1, 1, 0, 3));
    //leaves[0].BASE_DISINCENTIVE = pow(10, map(mouseX, 0, width, 0, 3));

    //leaves[0].SIDE_ANGLE = map(sin(millis() / 3000f), -1, 1, PI / 6, PI/2);
    //leaves[0].SIDE_ANGLE = map(mouseY, 0, height, PI/6, PI/2);

    //leaves[0].SIDEWAYS_COST_RATIO = map(mouseX, 0, width, 0, 1);

    //leaves[0].COST_BEHIND_GROWTH = pow(10, map(mouseX, 0, width, -10, 3));

    //leaves[0].GROW_FORWARD_FACTOR = pow(map(mouseX, 0, width, 0, 5), 3);

    //leaves[0].MAX_PATH_COST = pow(10, map(mouseX, 0, width, 0, 3));

    //leaves[0].BRANCH_SCALAR = map(mouseX, 0, width, 0.5, 1.0);
    leaves[0].SECONDARY_BRANCH_SCALAR = 0.85;
    leaves[0].SECONDARY_BRANCH_PERIOD = max(1, (int)map(mouseY, 0, height, 1, 10));
    leaves[0].DEPTH_STEPS_BEFORE_BRANCHING = 3; // max(1, (int)map(mouseX, 0, width, 1, 6));
    leaves[0].COST_TO_TURN = map(mouseX, 0, width, -100, 100);

    for (int i = 0; i < 1000 && !leaves[0].finished; i++) {
      leaves[0].expandBoundary();
      if (leaves[0].finished) {
        println("finished in " + i + " iterations");
      }
    }
    if (!leaves[0].finished) {
      println("not finished");
    }
  }
  for (Leaf l : leaves) {
    //l.expandBoundary();
    l.draw();
  }
  fill(0);
  textAlign(LEFT, TOP);
  textSize(20);

  text(leaves[0].COST_TO_TURN, 0, 0);
  //saveFrame("leaves.png");
  //noLoop();
  //println(frameRate);
}