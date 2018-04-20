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
  float SIDE_ANGLE_RANDOM = PI / 2 * 0.0;
  int DEPTH_STEPS_BEFORE_BRANCHING = 2;
  float TURN_TOWARDS_X_FACTOR = 0.0;
  float AVOID_NEIGHBOR_FORCE = 0;
  float randWiggle = 0.00;
  float BASE_DISINCENTIVE = 100;
  float COST_DISTANCE_TO_ROOT_DIVISOR = 1e5;
  float COST_BEHIND_GROWTH = 0;
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
      // disabled - this does make it longer, but that responsibility is more cleanly covered with maxCost
      // cost -= log(1 + (sOffset.x / EXPAND_DIST) * 2); // careful about blowing out the cost here
      // cost -= max(0, sOffset.x / EXPAND_DIST * INCENTIVE_GROW_FORWARD);

      // disincentivize getting too wide - position units
      // disabled - this helps control line vs round but that's already controlled with sideways_cost_ratio
      // cost += abs(s.position.y * s.position.y) * COST_AVOID_WIDE;

      // super disincentivize growing too far, this is an exponential - position units
      // this is kind of just a failsafe to prevent rampant growth from other costs
      // we should probably just keep this at like 1e5 or so
      cost += s.distanceToRoot * s.distanceToRoot / COST_DISTANCE_TO_ROOT_DIVISOR;

      // disincentivize growing behind you - position units
      cost += exp(-s.position.x * COST_BEHIND_GROWTH);
      // println(cost);
      // cost += max(0, -s.position.x) * COST_BEHIND_GROWTH;

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
        forwardOffset.setMag(EXPAND_DIST);
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

    /**
     * Get the non-immediate-family Small nearest to the point.
     */
    Small nearestCollidableNeighbor(PVector point) {
      Small nearestNeighbor = null;
      float nearestNeighborDist = 1e10;
      for (Small s : world) {
        if (isImmediateFamily(s)) {
          continue;
        }
        float dist = dist(s.position.x, s.position.y, point.x, point.y);
        if (dist < nearestNeighborDist) {
          nearestNeighborDist = dist;
          nearestNeighbor = s;
        }
      }
      return nearestNeighbor;
    }
    
    boolean isImmediateFamily(Small s) {
      return s == this || s.parent == this;
    }

    /**
     * Returns a new offset after the old would-be point has been repelled from everyone except 
     * immediate family (siblings or parent)
     */
    PVector avoidEveryone(PVector offset) {
      PVector position = this.position.copy().add(offset);
      PVector force = new PVector();
      for (Small s : world) {
        if (isImmediateFamily(s)) {
          continue;
        }
        float dist = dist(s.position.x, s.position.y, position.x, position.y);
        if (dist > 0) {
          PVector awayFromNeighborOffset = position.copy().sub(s.position);
          float forceMag = AVOID_NEIGHBOR_FORCE / (dist * dist);
          //float forceMag = AVOID_NEIGHBOR_FORCE / dist;
          awayFromNeighborOffset.setMag(forceMag);
          force.add(awayFromNeighborOffset);
        }
      }
      // note - this can actually move you into another neighbor... just ignore that for now though
      PVector newOffset = offset.copy().add(force).setMag(EXPAND_DIST);
      return newOffset;
    }

    ReasonStopped maybeAddBranch(PVector offset) {
      if (this.costToRoot > MAX_PATH_COST) {
        return ReasonStopped.Expensive;
      }
      //// make offset go towards +x
      //offset.x += (EXPAND_DIST - offset.x) * TURN_TOWARDS_X_FACTOR;
      // offset.setMag(EXPAND_DIST);
      PVector avoidedOffset = avoidEveryone(offset);
      // we've now moved away from everyone.
      PVector childPosition = this.position.copy().add(avoidedOffset);
      boolean isTerminal = false;
      Small nearestNeighbor = nearestCollidableNeighbor(childPosition);
      if (nearestNeighbor != null && nearestNeighbor.position.dist(childPosition) < TOO_CLOSE_DIST) {
        // we're too close! terminate ourselves
        return ReasonStopped.Crowded;
        
        //isTerminal = true;
        //childPosition.set(nearestNeighbor.position);
      }

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
    Collections.sort(world, new Comparator() {
      public int compare(Object obj1, Object obj2) {
        Small s1 = (Small)obj1;
        Small s2 = (Small)obj2;
        return Integer.compare(s1.weight, s2.weight);
      }
    }
    );
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
    }
    );
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
  leaves[0] = new Leaf(width/6, height/2, 1);
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
    leaf.BASE_DISINCENTIVE = pow(10, map(x, 0, gridWidth, 0, 5));
    leaf.TURN_TOWARDS_X_FACTOR = map(y, 0, gridHeight, 0.01, 1.0);
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
    //translate(-mouseX, -mouseY);
    scale(0.5);
    translate(width, height/2);
  }
  // translate(0, height / 2);
  // scale(0.5, 0.5);
  if (liveMorph) {
    initLeafSingle();
    // parameters:


    /* base_disincentive
     * 0 to 1, 10, 100, and 1000 all produce interesting changes
     * generally speaking, 0 = cordate, 1000 = linear/lanceolate
     */
    leaves[0].BASE_DISINCENTIVE = 0;
    //leaves[0].BASE_DISINCENTIVE = pow(10, map(cos(millis() / 450f), -1, 1, 0, 3));
    //leaves[0].BASE_DISINCENTIVE = pow(10, map(mouseX, 0, width, 0, 3));

    /*
     * max_path_cost
     * Linear scalar of how big the plant grows; good numbers are 100 to 1000.
     */
    leaves[0].MAX_PATH_COST = 1000;

    /* cost_distance_to_root
     * Failsafe on unbounded growth. Basically leave this around 1e5 to bound the plant at distance ~600.
     */
    leaves[0].COST_DISTANCE_TO_ROOT_DIVISOR = pow(10, 5);

    /* side_angle
     * controls the complexity of the edge and angular look of the inner vein system
     *   <PI / 6 = degenerate "nothing grows" case.
     *   PI/6 to PI/2 = the fractal edge changes in interesting ways.
     *     generally at PI/6 it's more circular/round, and at PI/2 it's more pointy.
     */
    leaves[0].SIDE_ANGLE = PI / 5;
    //leaves[0].SIDE_ANGLE = map(sin(millis() / 3000f), -1, 1, PI / 6, PI/2);
    //leaves[0].SIDE_ANGLE = map(mouseY, 0, height, PI/6, PI/2);

    /* sideways_cost_ratio
     * Powerful number that controls how fat the leaf grows.
     * -1 = obovate, truncate, obcordate
     * -0.2 = cuneate, orbicular
     * 0 = ellipse
     * 1+ = spear-shaped, linear, subulate
     */
    //leaves[0].SIDEWAYS_COST_RATIO = 0.25;
    leaves[0].SIDEWAYS_COST_RATIO = 0.25;
    //leaves[0].SIDEWAYS_COST_RATIO = map(mouseX, 0, width, 0, 1);

    /*
     * cost_behind_growth
     * keeps leaves from unboundedly growing backwards.
     * 1e-3 and below basically has no effect.
     * from 1e-3 to 1, the back edge of the leaf shrinks to nothing.
     * You probably want this around 0.2 to 0.5.
     * Around 0.3 you can get cordate shapes with the right combination of parameters.
     */
    leaves[0].COST_BEHIND_GROWTH = 0.2; // pow(10, map(mouseX, 0, width, -10, 3));

    /**
     * turn_towards_x_factor
     * gives veins an upwards curve.
     * 0 makes veins perfectly straight.
     * 1 makes veins curve sharply towards x.
     * careful - high numbers > 0.5 can cause degenerate early vein termination.
     * -1 is an oddity that looks cool but isn't really realistic (veins flowing backwards).
     */
    leaves[0].TURN_TOWARDS_X_FACTOR = 0.1;
    
    /**
     * avoid_neighbor_force
     * tends to spread veins out even if they grow backwards
     * you probably want at least some of this; it gives variety and better texture to the veins
     * 100 is a decent amount
     * This may ruin fragile venation patterns though.
     * you can also go negative which creates these inwards clawing veins. It looks cool, but isn't really realistic.
     * avoid neighbor can help prevent early vein termination from e.g. turn_towards_x_factor.
     */
    leaves[0].AVOID_NEIGHBOR_FORCE = 10;
    
    /**
     * turn_depths_before_branching
     * kind of like a detail slider - how dense do you want the veins to be.
     * 1 is messier and has "hair" veins
     * 2 is more uniform
     * 3+ bit spacious and e.g. gives room for turn_towards_x_factor
     * 6 is probably max here.
     */
    leaves[0].DEPTH_STEPS_BEFORE_BRANCHING = 1;
    
    /**
     * adds a random noise to every side_angle
     * at 0 the leaf looks perfectly straight/mathematically curvy
     * and allows for interesting fragile vein patterns to appear
     * as this bumps up the patterns will start to give way to chaos and
     * a more messy look. This can open up the way for veins to flow in places
     * they might not have before.
     * anything beyond like PI / 4 will be pretty messy. 
     */
    leaves[0].SIDE_ANGLE_RANDOM = 0.1;
    //leaves[0].SIDE_ANGLE_RANDOM = map(mouseX, 0, width, 0, PI / 2);
    
    /**
     * You can set this to false and set the sideways angle between PI/6 and PI/12 to get dichotimous veining.
     * This might work for petals.
     */
    leaves[0].growForwardBranch = true;

    for (int i = 0; i < 20; i++) {
      leaves[0].expandBoundary();
    }
  }
  for (Leaf l : leaves) {
    //l.expandBoundary();
    l.draw();
  }
  //println(frameRate);
}