import java.util.*;

enum ReasonStopped {
  Expensive, Crowded
};

Leaf leaf;

void setup() {
  fullScreen();
  noiseSeed(0);
  initLeafSingle();
}

void initLeafSingle() {
  leaf = new Leaf();
  //for (int z = 0; z < 1000; z++) {  
  //  leaf.expandBoundary();
  //}
}

void draw() {
  background(255);
  textSize(16); stroke(0);
  resetMatrix();
  text(mouseX+","+mouseY, mouseX, mouseY);
  useLeafMatrix();
  //  leaf.SECONDARY_BRANCH_SCALAR = 0.85;
  //  leaf.SECONDARY_BRANCH_PERIOD = max(1, (int)map(mouseY, 0, height, 1, 10));
  //  leaf.DEPTH_STEPS_BEFORE_BRANCHING = max(1, (int)map(mouseX, 0, width, 1, 6));

  if (true) { // constant live morphing
    initLeafSingle();
    //leaf.BASE_DISINCENTIVE = pow(10, map(cos(millis() / 450f), -1, 1, 0, 3));
    //leaf.BASE_DISINCENTIVE = pow(10, map(mouseX, 0, width, 0, 3));

    //leaf.SIDE_ANGLE = map(sin(millis() / 3000f), -1, 1, PI / 6, PI/2);
    //leaf.SIDE_ANGLE = map(mouseY, 0, height, PI/6, PI/2);

    //leaf.SIDEWAYS_COST_RATIO = map(mouseX, 0, width, 0, 1);

    //leaf.COST_BEHIND_GROWTH = pow(10, map(mouseX, 0, width, -10, 3));

    //leaf.GROW_FORWARD_FACTOR = pow(map(mouseX, 0, width, 0, 5), 3);

    //leaf.MAX_PATH_COST = pow(10, map(mouseX, 0, width, 0, 3));

    //leaf.BRANCH_SCALAR = map(mouseX, 0, width, 0.5, 1.0);
    leaf.SECONDARY_BRANCH_SCALAR = 0.85;
    // leaf.SECONDARY_BRANCH_PERIOD = max(1, (int)map(mouseY, 0, height, 1, 10));
    leaf.DEPTH_STEPS_BEFORE_BRANCHING = 3; // max(1, (int)map(mouseX, 0, width, 1, 6));
    // leaf.COST_TO_TURN = map(mouseX, 0, width, -100, 100);

    for (int i = 0; i < 1000 && !leaf.finished; i++) {
      leaf.expandBoundary();
      //if (leaf.finished) {
      //  println("finished in " + i + " iterations");
      //}
    }
    //if (!leaf.finished) {
    //  println("not finished");
    //}
  }
  
  //println(screenX(0, 0));
  //println(screenY(0, 0));
  
  leaf.drawWorld();
  
  //List<PVector> vecs = new ArrayList();
  //for (Leaf.Small s : leaf.world) {
  //  float sx = screenX(s.position.x, s.position.y);
  //  float sy = screenY(s.position.x, s.position.y);
  //  vecs.add(new PVector(sx, sy));
  //}
  //resetMatrix();
  //for(PVector v : vecs) {
  //  stroke(255, 0, 0);
  //  strokeWeight(10);
  //  point(v.x, v.y);
  //  textSize(12);
  //  text(v.x+","+v.y, v.x, v.y);
  //}

  //fill(0);
  //textAlign(LEFT, TOP);
  //textSize(20);
  //text(leaf.COST_TO_TURN, 0, 0);
}

PMatrix2D mat;

void useLeafMatrix() {
  // translate leaf coordinates into screen coordinates
  // leaves are rooted at 0, 0, have their main axis growing towards +x
  // y is lateral "fatness".
  
  // on the screen we want the leaf to be rooted at width/2, height * 0.9
  // whose main axis growing towards -y
  
  // this will also affect processing's screenX/screenY which we use while growing the leaf!
  
  translate(width/2, height * 0.9);
  rotate(-PI / 2);
  scale(10);
  
  mat = new PMatrix2D();
  mat.translate(width/2, height * 0.9);
  mat.rotate(-PI / 2);
  mat.scale(10);
}


float leafToScreenX(float x, float y) {
  return mat.multX(x, y);
}

float leafToScreenY(float x, float y) {
  return mat.multY(x, y);
}

void mousePressed() {
}

void keyPressed() {
}