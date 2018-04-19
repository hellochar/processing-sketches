import java.util.*;

float symmetricRandom(float low, float high, float y) {
  return map(noise(y) + noise(-y), 0, 2, low, high);
}

class Leaf {
  List<Small> world = new ArrayList();

  Small root;
  // outer boundary from last growth step
  List<Small> boundary = new ArrayList();
  // nodes without any children
  List<Small> terminalNodes = new ArrayList();
  
  float x, y, scale;

  Leaf(float x, float y, float scale) {
    this.x = x;
    this.y = y;
    this.scale = scale;
    root = new Small(new PVector(EXPAND_DIST, 0));
    root.distanceToRoot = 0;
    root.costToRoot = 0;
    boundary.add(root);
  }

  float TOO_CLOSE_DIST = 10;
  float EXPAND_DIST = TOO_CLOSE_DIST * 1.01;
  float MAX_PATH_COST = 300;
  float SIDEWAYS_COST_RATIO = 0.01;
  float SIDE_ANGLE = PI / 2 * 0.7; // past PI/2 doesn't make sense
  float SIDE_ANGLE_RANDOM = PI / 2 * 0.2;
  int DEPTH_STEPS_BEFORE_BRANCHING = 1;
  float TURN_TOWARDS_X_FACTOR = 0.5;
  float AVOID_NEIGHBOR_FORCE = 0;
  boolean growForwardBranch = true;

  class Small {
    PVector position;
    Small parent;
    List<Small> children;
    // number of ancestors in this subtree,
    // computed with computeWeights()
    int weight;
    // cached sum of all offsets up to root
    float distanceToRoot;
    // similar to distance to root but make sideways movement more expensive
    float costToRoot;
    // number of parents away from root
    int depth = 0;

    Small(PVector pos) {
      this.position = pos;
      this.children = new LinkedList();
      world.add(this);
    }

    void add(Small s) {
      s.parent = this;
      this.children.add(s);
      PVector sOffset = s.offset();
      float mag = sOffset.mag();
      s.distanceToRoot = this.distanceToRoot + mag;

      float cost = 0;
      // base cost of growth
      cost += dist(0, 0, sOffset.x, sOffset.y);
     
      // original cost function
      // cost += dist(0, 0, sOffset.x, sOffset.y * 5);
      
      // disincentivize growing too laterally
      // cost += abs(sOffset.y * sOffset.y) * SIDEWAYS_COST_RATIO;
      
      // super disincentivize growing too far, this is an exponential
      cost += s.distanceToRoot / 10;
      
      // disincentivize growing behind you
      cost += exp(-s.position.x) * 0.01;
      
      // disincentivize growing laterally when you're too close to the base
      cost += s.position.y * s.position.y * 1 / (1 + s.position.x * s.position.x);
      
      // but incentivize growing some
      // cost -= log(1 + abs(sOffset.x * sOffset.x));
      
      // incentivize growing in the middle area
      // cost -= 
      
      s.costToRoot = this.costToRoot + cost;

      s.depth = this.depth + 1;
    }

    PVector offset() {
      if (this.parent != null) {
        return this.position.copy().sub(this.parent.position);
      } else {
        return this.position.copy();
      }
    }

    // attempt to grow outwards in your direction and to the side
    void branchOut() {
      PVector offset = this.offset();

      if (growForwardBranch || depth % DEPTH_STEPS_BEFORE_BRANCHING != 0) {
        PVector forwardOffset = offset.copy().setMag(EXPAND_DIST);
        // make offset go towards +x
        forwardOffset.x += (EXPAND_DIST - forwardOffset.x) * TURN_TOWARDS_X_FACTOR;
        maybeAddBranch(forwardOffset);
      }

      float rotAngle = SIDE_ANGLE + symmetricRandom(-SIDE_ANGLE_RANDOM, SIDE_ANGLE_RANDOM, this.position.y);
      if (depth % DEPTH_STEPS_BEFORE_BRANCHING == 0) {
        PVector positiveTurnOffset = offset.copy().setMag(EXPAND_DIST).rotate(rotAngle);
        maybeAddBranch(positiveTurnOffset);
      }

      if (depth % DEPTH_STEPS_BEFORE_BRANCHING == 0) {
        PVector negativeTurnOffset = offset.copy().setMag(EXPAND_DIST).rotate(-rotAngle);
        maybeAddBranch(negativeTurnOffset);
      }
    }

    void maybeAddBranch(PVector offset) {
      //// make offset go towards +x
      //offset.x += (EXPAND_DIST - offset.x) * TURN_TOWARDS_X_FACTOR;
      
      offset.setMag(EXPAND_DIST);
      PVector childPosition = this.position.copy().add(offset);
      if (this.costToRoot > MAX_PATH_COST) {
        return;
      }
      Small nearestNeighbor = null;
      float nearestNeighborDist = 1e10;
      for (Small s : world) {
        float dist = dist(s.position.x, s.position.y, childPosition.x, childPosition.y);
        if (dist < TOO_CLOSE_DIST && s.parent != this) {
          // we're too close, abort.
          return;

          //// "attach" to nearby neighbor
          //childPosition = s.position;
          //break;
        }
        if (dist < nearestNeighborDist) {
          nearestNeighborDist = dist;
          nearestNeighbor = s;
        }
      }
      if (nearestNeighbor != null) {
        // one last step - avoid your neighbor a little bit
        PVector awayFromNeighborOffset = childPosition.copy().sub(nearestNeighbor.position);
        float force = AVOID_NEIGHBOR_FORCE / nearestNeighborDist;
        awayFromNeighborOffset.setMag(force);
        offset.add(awayFromNeighborOffset);
        offset.setMag(EXPAND_DIST);
        // note - this can actually move you into another neighbor... just ignore that for now though
        childPosition = this.position.copy().add(offset);
      }
      
      // we're not too close! put one here
      Small newSmall = new Small(childPosition);
      this.add(newSmall);
    }

    void draw() {
      if (this.parent != null) {
        line(this.parent.position.x, this.parent.position.y, this.position.x, this.position.y);
      } else {
        line(0, 0, this.position.x, this.position.y);
      }
    }
  }

  void computeWeights() {
    // start from the boundaries and work backwards
    for (Small s : world) {
      s.weight = 1;
    }
    Set<Small> level = new HashSet();
    // level.addAll(boundary);
    level.addAll(terminalNodes);
    while (level.size() > 0) {
      Set<Small> newLevel = new HashSet();
      for (Small s : level) {
        if (s.parent != null) {
          s.parent.weight += s.weight;
          newLevel.add(s.parent);
        }
      }
      level = newLevel;
    }
  }
  
  void expandBoundary() {
    List<Small> newBoundary = new ArrayList();
    for (Small s : boundary) {
      s.branchOut();
      newBoundary.addAll(s.children);
    }
    //world.addAll(newBoundary);
    boundary = newBoundary;
    terminalNodes.clear();
    for (Small s : world) {
      if (s.children.size() == 0) {
        terminalNodes.add(s);
      }
    }
    computeWeights();
  }
  
  void draw() {
    pushMatrix();
    translate(x, y);
    scale(scale);
    drawWorld();
    popMatrix();
  }

  void drawWorld() {
    for (Small s : world) {
      strokeWeight(log(1 + s.weight / 3));
      stroke(0, 128);
      s.draw();
      fill(0, 64);
      text(int(100 * (s.costToRoot / MAX_PATH_COST)), s.position.x, s.position.y);
      textAlign(BOTTOM, RIGHT);
    }
    for (Small s : boundary) {
      stroke(64, 220, 75, 128);
      s.draw();
    }
    drawBoundary();
  }

  void drawBoundary() {
    stroke(64, 64, 64, 64);
    noFill();
    beginShape();
    for (Small s : boundary) {
      vertex(s.position.x, s.position.y);
    }
    endShape();
  }
}

Leaf[] leaves;

void setup() {
  size(1920, 1080);
  // initLeafSingle();
  initLeafGrid();
}

void initLeafSingle() {
  leaves = new Leaf[1];
  leaves[0] = new Leaf(width/2, height/2, 1);
}

void initLeafGrid() {
  int gridHeight = 10;
  int gridWidth = 5;
  leaves = new Leaf[gridWidth * gridHeight];
  for (int i = 0; i < leaves.length; i++) {
    float x = i % gridWidth + 0.5;
    float y = i / gridWidth + 0.5;
    Leaf leaf = new Leaf(
      map(x, 0, gridWidth, 0, width),
      map(y, 0, gridHeight, 0, height),
      0.33
    );
    //leaf.MAX_PATH_COST = 150;
    // leaf.AVOID_NEIGHBOR_FORCE = map(y, 0, gridHeight, 0, 0);
    // leaf.DEPTH_STEPS_BEFORE_BRANCHING = (int)map(x, 0, gridWidth, 1, 5);
    leaf.SIDEWAYS_COST_RATIO = map(x, 0, gridWidth, 0.0, 1.0);
    // leaf.SIDE_ANGLE = map(x, 0, gridWidth, PI / 8, PI / 2);
    leaf.TURN_TOWARDS_X_FACTOR = map(y, 0, gridHeight, 0.01, 1.0);
    leaves[i] = leaf;
    // leaf.draw();
  }
}

void mousePressed() {
  for (Leaf l : leaves) {
    l.expandBoundary();
    // l.draw();
  }
}

void draw() {
  background(255);
  if (mousePressed && mouseButton == RIGHT) {
    translate(width/2 - mouseX, height/2 - mouseY);
    scale(2);
  }
  // translate(0, height / 2);
  // scale(0.5, 0.5);
  for (Leaf l : leaves) {
    //l.expandBoundary();
    l.draw();
  }
}