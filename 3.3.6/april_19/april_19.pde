import java.util.*;

float symmetricRandom(float low, float high, float y) {
  return map(noise(y) + noise(-y), 0, 2, low, high);
}

enum ReasonStopped { 
  Expensive, Crowded
};

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
  float MAX_PATH_COST = 400;
  float SIDEWAYS_COST_RATIO = 0.5;
  float SIDE_ANGLE = PI / 2 * 0.7; // past PI/2 doesn't make sense
  float SIDE_ANGLE_RANDOM = PI / 2 * 0.2;
  int DEPTH_STEPS_BEFORE_BRANCHING = 2;
  float TURN_TOWARDS_X_FACTOR = 0.0;
  float AVOID_NEIGHBOR_FORCE = 0;
  float randWiggle = 0.01;
  float BASE_DISINCENTIVE = 1000;
  float BASE_DIST_FALLOFF = 200;
  boolean growForwardBranch = true;


  class Small {
    PVector position;
    Small parent;
    List<Small> children;
    // number of ancestors in this subtree,
    // computed with computeWeight()
    int weight = -1;
    // cached sum of all offsets up to root
    float distanceToRoot;
    // similar to distance to root but make sideways movement more expensive
    float costToRoot;
    // number of parents away from root
    int depth = 0;
    boolean isTerminal = false;

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
      // base cost of growth - offset units
      cost += dist(0, 0, sOffset.x, sOffset.y);

      // original cost function, offset units
      //cost += dist(0, 0, sOffset.x, sOffset.y * (1 + SIDEWAYS_COST_RATIO));

      // disincentivize growing too laterally - offset units
      cost += abs(sOffset.y * sOffset.y) * SIDEWAYS_COST_RATIO;

      // incentivize growing forward - offset units
      // cost -= log(1 + (sOffset.x / EXPAND_DIST) * 2); // careful about blowing out the cost here
      // cost -= min(0, sOffset.x / EXPAND_DIST * 1);

      // disincentivize getting too wide - position units
      // cost += abs(s.position.y) * 0.1;

      // super disincentivize growing too far, this is an exponential - position units
      // cost += s.distanceToRoot / 50;

      // disincentivize growing behind you - position units
      cost += exp(-s.position.x) * 0.01;

      // disincentivize growing laterally when you're too close to the base - position units
      // this makes nice elliptical shapes
      cost += BASE_DISINCENTIVE * s.position.y * s.position.y * 1 / (1 + s.position.x * s.position.x);

      // disincentivize growing laterally when you're too close to the base, but with much stronger falloff - position units
      // good parameters
      // cost += 1000 * s.position.y * s.position.y * 1 / (1 + exp(s.position.x * s.position.x / 200));
      // cost += BASE_DISINCENTIVE * s.position.y * s.position.y * 1 / (1 + exp(s.position.x * s.position.x / BASE_DIST_FALLOFF));

      // give an incentive for going over a specific point - position units
      // cost -= 1 / (1 + exp(30 - s.position.x));

      // incentivize middle distances to the root
      // cost -= 1000 / (1 + exp(pow(100 - s.distanceToRoot, 2)));


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

    ReasonStopped reason;
    // attempt to grow outwards in your direction and to the side
    void branchOut() {
      if (isTerminal) {
        reason = ReasonStopped.Crowded;
        return;
      }
      PVector offset = this.offset();

      if (growForwardBranch || depth % DEPTH_STEPS_BEFORE_BRANCHING != 0) {
        PVector forwardOffset = offset.copy().setMag(EXPAND_DIST);
        // make offset go towards +x
        forwardOffset.x += (EXPAND_DIST - forwardOffset.x) * TURN_TOWARDS_X_FACTOR;
        forwardOffset.rotate(symmetricRandom(-randWiggle, randWiggle, this.position.y * 100));
        reason = maybeAddBranch(forwardOffset);
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

    ReasonStopped maybeAddBranch(PVector offset) {
      //// make offset go towards +x
      //offset.x += (EXPAND_DIST - offset.x) * TURN_TOWARDS_X_FACTOR;

      // offset.setMag(EXPAND_DIST);
      PVector childPosition = this.position.copy().add(offset);
      if (this.costToRoot > MAX_PATH_COST) {
        return ReasonStopped.Expensive;
      }
      boolean isTerminal = false;
      Small nearestNeighbor = null;
      float nearestNeighborDist = 1e10;
      PVector force = new PVector();
      for (Small s : world) {
        float dist = dist(s.position.x, s.position.y, childPosition.x, childPosition.y);

        PVector awayFromNeighborOffset = childPosition.copy().sub(s.position);
        float forceMag = -AVOID_NEIGHBOR_FORCE / dist;
        awayFromNeighborOffset.setMag(forceMag);
        force.add(awayFromNeighborOffset);

        if (dist < TOO_CLOSE_DIST && s.parent != this) {
          // we're too close, abort.
          return ReasonStopped.Crowded;

          //childPosition = s.position;
          // isTerminal = true;

          // avoid your neighbor a little bit
          //PVector awayFromNeighborOffset = childPosition.copy().sub(s.position).setMag(TOO_CLOSE_DIST);
          //// note - this can actually move you into a previous neighbor... just ignore that for now though
          //childPosition.add(awayFromNeighborOffset);
          //isTerminal = true;

          //float force = AVOID_NEIGHBOR_FORCE / nearestNeighborDist;
          //awayFromNeighborOffset.setMag(force);
          //offset.add(awayFromNeighborOffset);
          //offset.setMag(EXPAND_DIST);
          //// note - this can actually move you into another neighbor... just ignore that for now though
          //childPosition = this.position.copy().add(offset);


          //break;
        }
        if (dist < nearestNeighborDist) {
          nearestNeighborDist = dist;
          nearestNeighbor = s;
        }
      }
      
      // note - this can actually move you into another neighbor... just ignore that for now though
      offset.add(force);
      offset.setMag(EXPAND_DIST);
      childPosition = this.position.copy().add(offset);
      
      //if (nearestNeighbor != null) {
      //  // one last step - avoid your neighbor a little bit
      //  PVector awayFromNeighborOffset = childPosition.copy().sub(nearestNeighbor.position);
      //  float force = AVOID_NEIGHBOR_FORCE / nearestNeighborDist;
      //  awayFromNeighborOffset.setMag(force);
      //  offset.add(awayFromNeighborOffset);
      //  offset.setMag(EXPAND_DIST);
      //  // note - this can actually move you into another neighbor... just ignore that for now though
      //  childPosition = this.position.copy().add(offset);
      //}

      // we're not too close! put one here
      Small newSmall = new Small(childPosition);
      newSmall.isTerminal = isTerminal;
      this.add(newSmall);
      return null;
    }

    void draw() {
      if (this.parent != null) {
        line(this.parent.position.x, this.parent.position.y, this.position.x, this.position.y);
      } else {
        line(0, 0, this.position.x, this.position.y);
      }
    }

    void computeWeight() {
      if (this.weight == -1) {
        int weight = 1;
        for (Small s : this.children) {
          s.computeWeight();
          weight += s.weight;
        }
        this.weight = weight;
      }
    }
  }

  void computeWeights() {
    for (Small s : world) {
      s.weight = -1;
    }
    root.computeWeight();
    // start from the boundaries and work backwards
    //Set<Small> level = new HashSet();
    //// level.addAll(boundary);
    //level.addAll(terminalNodes);
    //while (level.size() > 0) {
    //  Set<Small> newLevel = new HashSet();
    //  for (Small s : level) {
    //    if (s.parent != null) {
    //      s.parent.weight += s.weight;
    //      newLevel.add(s.parent);
    //    }
    //  }
    //  level = newLevel;
    //}
  }

  boolean finished = false;
  void expandBoundary() {
    if (finished) {
      return;
    }
    List<Small> newBoundary = new ArrayList();
    for (Small s : boundary) {
      s.branchOut();
      newBoundary.addAll(s.children);
    }
    if (newBoundary.size() == 0) {
      finished = true;
    }
    //world.addAll(newBoundary);

    for (Small s : boundary) {
      if (s.children.size() == 0) {
        terminalNodes.add(s);
      }
    }
    boundary = newBoundary;
    
    //for (Small s : world) {
    //  if (s.children.size() == 0) {
    //    terminalNodes.add(s);
    //  }
    //}
    computeWeights();
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    textSize(14 / scale);
    scale(scale);
    drawWorld();
    popMatrix();
  }

  void drawWorld() {
    for (Small s : world) {
      //strokeWeight(log(1 + s.weight / 3));
      strokeWeight(pow(s.weight, 1f / 3));
      stroke(0, 128);
      s.draw();
      fill(0, 64);
      //text(int(100 * (s.costToRoot / MAX_PATH_COST)), s.position.x, s.position.y);

      //text(s.weight, s.position.x, s.position.y);
      textAlign(BOTTOM, RIGHT);
    }
    for (Small s : terminalNodes) {
      if (s.reason == ReasonStopped.Expensive) {
        strokeWeight(1);
        stroke(64, 255, 75);
        s.draw();
      }
    }
    drawBoundary();
  }

  void drawBoundary() {
    stroke(64, 255, 64);
    strokeWeight(0.5);
    noFill();
    beginShape();
    // vertex(root.position.x, root.position.y);
    Collections.sort(terminalNodes, new Comparator() {
      public int compare(Object obj1, Object obj2) {
        Small s1 = (Small)obj1;
        Small s2 = (Small)obj2;
        return Float.compare(atan2(s1.position.y, s1.position.x), atan2(s2.position.y, s2.position.x));
      }
    });
    for (Small s : terminalNodes) {
      if (s.reason == ReasonStopped.Expensive) {
        vertex(s.position.x, s.position.y);
      }
    }
    endShape();
  }
}

Leaf[] leaves;

boolean liveMorph = true;

void setup() {
  size(800, 600);
  initLeafSingle();
  //initLeafGrid();
}

void initLeafSingle() {
  leaves = new Leaf[1];
  leaves[0] = new Leaf(width/6, height/2, 1.0);
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
      0.5
      );
    //leaf.MAX_PATH_COST = 150;
    // leaf.AVOID_NEIGHBOR_FORCE = map(y, 0, gridHeight, 0, 0);
    // leaf.DEPTH_STEPS_BEFORE_BRANCHING = (int)map(x, 0, gridWidth, 1, 5);
    // leaf.SIDE_ANGLE = map(x, 0, gridWidth, PI / 8, PI / 2);
    // leaf.SIDEWAYS_COST_RATIO = map(y, 0, gridHeight, 0.0, 0.2);
    // leaf.TURN_TOWARDS_X_FACTOR = map(y, 0, gridHeight, 0.01, 1.0);
    leaf.BASE_DISINCENTIVE = pow(10, map(x, 0, gridWidth, 0, 5));
    leaf.BASE_DIST_FALLOFF = pow(5, map(y, 0, gridHeight, 0, 5));
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

void draw() {
  background(255);
  if (mousePressed && mouseButton == RIGHT) {
    translate(-mouseX, -mouseY);
    scale(2);
  }
  // translate(0, height / 2);
  // scale(0.5, 0.5);
  if (liveMorph) {
    initLeafSingle();
    // leaves[0].SIDE_ANGLE = map(sin(millis() / 3000f), -1, 1, PI / 6, PI/2);
    // leaves[0].BASE_DISINCENTIVE = pow(10, map(cos(millis() / 450f), -1, 1, 0, 3));
    leaves[0].BASE_DISINCENTIVE = 10;
    leaves[0].SIDEWAYS_COST_RATIO = map(mouseX, 0, width, 0, 1);
    leaves[0].SIDE_ANGLE = map(mouseY, 0, height, PI/6, PI/2);
    
    // leaves[0].TURN_TOWARDS_X_FACTOR = map(mouseY, 0, height, 0, 1);
    for (int i = 0; i < 100; i++) {
      leaves[0].expandBoundary();
    }
  }
  for (Leaf l : leaves) {
    //l.expandBoundary();
    l.draw();
  }
  println(frameRate);
}