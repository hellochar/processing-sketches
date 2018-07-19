class Leaf {
  List<Small> world = new ArrayList();

  Small root;
  // outer boundary from last growth step
  List<Small> boundary = new ArrayList();
  // nodes without any children
  List<Small> terminalNodes = new ArrayList();
  
  PImage depthImage;

  Leaf() {
    root = new Small(new PVector(EXPAND_DIST, 0));
    root.distanceToRoot = 0;
    root.costToRoot = 0;
    boundary.add(root);
  }

  // distance between branches. this kind of controls the fine detail of the leaves.s
  float TOO_CLOSE_DIST = 2;
  /**
   * < 0.5 always degenerates - no branching
   * 0.75 still has some degenerates
   * 0.75 to 1 - creates nicer complex boundaries
   * 1 - normal
   * 1 to 1.5 - makes more aristate and cuneate shapes
   * > 1.5 degenerates - vein crisscrossing
   */
  float EXPAND_SCALAR = 0.85;

  float EXPAND_DIST = TOO_CLOSE_DIST * EXPAND_SCALAR;
  /**
   * max_path_cost
   * Linear scalar of how big the plant grows; good numbers are 100 to 1000.
   * For high fidelity, pump this up to like 5000
   */
  float MAX_PATH_COST = 300;
  /* sideways_cost_ratio
   * Powerful number that controls how fat the leaf grows.
   * -1 = obovate, truncate, obcordate
   * -0.2 = cuneate, orbicular
   * 0 = ellipse
   * 1+ = spear-shaped, linear, subulate
   */
  float SIDEWAYS_COST_RATIO = -0.2;

  /* side_angle
   * controls the complexity of the edge and angular look of the inner vein system
   *   <PI / 6 = degenerate "nothing grows" case.
   *   PI/6 to PI/2 = the fractal edge changes in interesting ways.
   *     generally at PI/6 it's more circular/round, and at PI/2 it's more pointy.
   */
  float SIDE_ANGLE = PI / 3;
  /**
   * side_angle_random
   * adds a random noise to every side_angle
   * at 0 the leaf looks perfectly straight/mathematically curvy
   * and allows for interesting fragile vein patterns to appear
   * 
   * as this bumps up the patterns will start to give way to chaos and
   * a more messy look.
   * This can open up the way for veins to flow in places they might not
   * have before.
   * This also risks non-symmetricness.
   *
   * Anything beyond like PI / 4 will be pretty messy. 
   */
  float SIDE_ANGLE_RANDOM = PI / 6;

  /**
   * turn_depths_before_branching
   * kind of like a detail slider - how dense do you want the veins to be.
   * 1 is messier and has "hair" veins
   * 2 is more uniform
   * 3+ bit spacious and e.g. gives room for turn_towards_x_factor
   * 6 is probably max here.
   */
  int DEPTH_STEPS_BEFORE_BRANCHING = 2;

  /**
   * branch_depth_mod
   * the period of small to big branching.
   * Larger periods tend to create more lobed/palmate boundary shapes.
   * Use in conjunction with SECONDARY_BRANCH_SCALAR.
   * 
   * 1 will create no secondary branches.
   * 2-10 creates larger crevases.
   * To get complex boundaries, DEPTH_STEPS_BEFORE_BRANCHING * BRANCH_DEPTH_MOD should be around 10-20.
   */
  int SECONDARY_BRANCH_PERIOD = 5;

  /**
   * turn_towards_x_factor
   * gives veins an upwards curve.
   * 0 makes veins perfectly straight.
   * 1 makes veins curve sharply towards x.
   * careful - high numbers > 0.5 can cause degenerate early vein termination.
   * -1 is an oddity that looks cool but isn't really realistic (veins flowing backwards).
   */
  float TURN_TOWARDS_X_FACTOR = 0.1;

  /**
   * avoid_neighbor_force
   * tends to spread veins out even if they grow backwards
   * you probably want at least some of this; it gives variety and better texture to the veins
   * 100 is a decent amount
   * This may ruin fragile venation patterns though.
   * you can also go negative which creates these inwards clawing veins. It looks cool, but isn't really realistic.
   * avoid neighbor can help prevent early vein termination from e.g. turn_towards_x_factor.
   */
  float AVOID_NEIGHBOR_FORCE = 1;

  float randWiggle = 0.0;

  /* base_disincentive
   * 0 to 1, 10, 100, and 1000 all produce interesting changes
   * generally speaking, 0 = cordate, 1000 = linear/lanceolate
   */
  float BASE_DISINCENTIVE = 0;

  /* cost_distance_to_root
   * Failsafe on unbounded growth. Basically leave this around 1e5 to bound the plant at distance ~600.
   */
  float COST_DISTANCE_TO_ROOT_DIVISOR = 5e4; // 1e5;
  /*
   * cost_negative_x_growth
   * keeps leaves from unboundedly growing backwards.
   * 1e-3 and below basically has no effect.
   * from 1e-3 to 1, the back edge of the leaf shrinks to nothing.
   * You probably want this around 0.2 to 0.5.
   * Around 0.3 you can get cordate shapes with the right combination of parameters.
   */
  float COST_NEGATIVE_X_GROWTH = 1;

  /**
   * grow_forward_factor
   * basically incentivizes... growing forward. Makes leave ovate.
   * Anything below 10 basically has no effect. 
   * At 100 basically every leaf becomes ovate, and also increases the number of steps taken.
   */
  float GROW_FORWARD_FACTOR = 0;

  /**
   * max 1,
   * below 0.7 it starts degenerating
   */
  float SECONDARY_BRANCH_SCALAR = 0.85;

  /**
   * Can help define a more jagged/deeper edge.
   * < -100 = makes things much fatter/more kidney-like. Creates quite complex edges.
   * -100 - 0 = incentivizes curving; creates edges with many fine little details. 
   * 0 - 20 = no effect
   * 20 - 40 = helps make more jagged edges, like maple leaves (but it might be suppressed by other parameters)
   * 40 - 100 = even more jagged edges, but starting to degenerate
   * > 100 = degenerates
   * 
   */
  float COST_TO_TURN = -1;

  /**
   * You can set this to false and set the sideways angle between PI/6 and PI/12 to get dichotimous veining.
   * This might work for petals.
   */
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
    // on the path to root, the number of turns you have to make
    int numTurns = 0;
    boolean isTerminal = false;

    Small(PVector pos) {
      this.position = pos;
      this.children = new LinkedList();
      world.add(this);
    }

    void add(Small s) {
      s.parent = this;
      s.depth = this.depth + 1;
      // consider first child the "straight" child
      boolean isTurn = true;
      if (this.children.size() == 0) {
        s.numTurns = this.numTurns;
        isTurn = false;
      } else {
        s.numTurns = this.numTurns + 1;
        isTurn = true;
      }
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
      cost -= min(0, (sOffset.x - abs(sOffset.y)) / EXPAND_DIST * GROW_FORWARD_FACTOR);

      // disincentivize getting too wide - position units
      // disabled - this helps control line vs round but that's already controlled with sideways_cost_ratio
      // cost += abs(s.position.y * s.position.y) * 0.01;

      // super disincentivize growing too far, this is an exponential - position units
      // this is kind of just a failsafe to prevent rampant growth from other costs
      // we should probably just keep this at like 1e5 or so
      cost += s.distanceToRoot * s.distanceToRoot / COST_DISTANCE_TO_ROOT_DIVISOR;

      // disincentivize growing behind you - position units
      cost += exp(-s.position.x * COST_NEGATIVE_X_GROWTH);
      // println(cost);
      // cost += max(0, -s.position.x) * COST_BEHIND_GROWTH;

      // disincentivize growing laterally when you're too close to the base - position units
      // this makes nice elliptical shapes
      cost += BASE_DISINCENTIVE * s.position.y * s.position.y * 1 / (1 + s.position.x * s.position.x);
      
      // cost += s.closeToMouseness() / 10;
      
      PVector screen = s.screenCoordinates();
      int depthX = (int)map(screen.x, 0, width, 0, depthImage.width);
      int depthY = (int)map(screen.y, 0, height, 0, depthImage.height);
      int depthPixelIndex = depthY * depthImage.width + depthX;
      if (depthPixelIndex >= 0 && depthPixelIndex < depthImage.pixels.length) {
        float alpha = alpha(depthImage.pixels[depthPixelIndex]);
        //if (brightness < brightnessGate) {
        //  brightness = 0;
        //}
        //println(alpha);
        if (alpha == 0) {
          cost += 20;
        } else {
          cost -= 1;
        }
        //float value = constrain(map(alpha, 0, 255, 0, 100), 0, 100);
        //cost += value;
      }

      //Small lastBranch = this;
      //// children.get(0) is usually the forward vein. But we do .get(0) to be adaptable for
      //// other cases (not-always-growing-forward, or forward vein is blocked)
      //// keep going backwards until you hit a turn.
      //// incentivize going straight
      //int l = 0;
      //while (lastBranch.parent != null && lastBranch.parent.children.get(0) == lastBranch) {
      //  lastBranch = lastBranch.parent;
      //  l++;
      //}
      ////println(l, lastBranch.weight, log(1 + lastBranch.weight));
      //cost -= log( 1 + lastBranch.weight * STRAIGHT_INCENTIVE_FACTOR );

      // disincentivize curving too much
      //cost += s.numTurns * STRAIGHT_INCENTIVE_FACTOR;

      // disincentivize turns
      if (isTurn) {
        cost += COST_TO_TURN;
      }

      // disincentivize growing laterally when you're too close to the base, but with much stronger falloff - position units
      // good parameters
      // cost += 1000 * s.position.y * s.position.y * 1 / (1 + exp(s.position.x * s.position.x / 200));
      // cost += BASE_DISINCENTIVE * s.position.y * s.position.y * 1 / (1 + exp(s.position.x * s.position.x / BASE_DIST_FALLOFF));

      // give an incentive for going over a specific point - position units
      // cost -= 100 / (1 + exp(30 - s.position.x));

      // incentivize middle distances to the root
      // cost -= 1000 / (1 + exp(pow(50 - s.distanceToRoot, 2) / 100));


      // incentivize growing in the middle area
      // cost -=

      s.costToRoot = this.costToRoot + cost;
    }
    
    PVector screenCoordinates() {
      float screenX = leafToScreenX(position.x, position.y);
      float screenY = leafToScreenY(position.x, position.y);
      return new PVector(screenX, screenY);
    }
    
    float closeToMouseness() { 
      if (screenCoordinates().dist(new PVector(mouseX, mouseY)) < 50) {
        return 1000;
      } else {
        return 0;
      }
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
    List<Small> branchOut() {
      List<Small> nodes = new ArrayList();
      if (isTerminal) {
        reason = ReasonStopped.Crowded;
        nodes.add(this);
        return nodes;
      }
      PVector offset = this.offset();
      float mag = offset.mag();
      PVector forward = offset.normalize();

      if (growForwardBranch || depth % DEPTH_STEPS_BEFORE_BRANCHING != 0) {
        PVector heading = forward.copy();
        // make offset go towards +x
        heading.x += (1 - heading.x) * TURN_TOWARDS_X_FACTOR;
        heading.rotate(symmetricRandom(-randWiggle, randWiggle, 32 + this.position.x * 1242.319 + this.position.y * 1960)).normalize();
        // keep the same mag when moving forward
        reason = maybeAddBranch(heading, mag * 1.0);
      }

      float sideScalar = 1.0;
      int branchDepth = (int)(depth / DEPTH_STEPS_BEFORE_BRANCHING);
      sideScalar = branchDepth % SECONDARY_BRANCH_PERIOD == 0 ? 1 : SECONDARY_BRANCH_SCALAR;
      float rotAngle = SIDE_ANGLE + symmetricRandom(-SIDE_ANGLE_RANDOM, SIDE_ANGLE_RANDOM, this.position.y);
      if (depth % DEPTH_STEPS_BEFORE_BRANCHING == 0) {
        PVector positiveTurnOffset = forward.copy().rotate(rotAngle);
        maybeAddBranch(positiveTurnOffset, mag * sideScalar);
      }
      if (depth % DEPTH_STEPS_BEFORE_BRANCHING == 0) {
        PVector negativeTurnOffset = forward.copy().rotate(-rotAngle);
        maybeAddBranch(negativeTurnOffset, mag * sideScalar);
      }
      if (children.size() == 0) {
        nodes.add(this);
      } else {
        nodes.addAll(children);
      }
      return nodes;
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

    boolean isAncestor(Small s) {
      Small tester = this;
      while (tester != null) {
        if (tester == s) {
          return true;
        } else {
          tester = tester.parent;
        }
      }
      return false;
    }

    /**
     * Returns a new heading after the old would-be point has been repelled from everyone except 
     * immediate family (siblings or parent)
     */
    PVector avoidEveryone(PVector heading, float mag) {
      PVector offset = heading.copy().mult(mag);
      PVector position = this.position.copy().add(offset);
      PVector force = new PVector();
      for (Small s : boundary) {
        if (isImmediateFamily(s) || isAncestor(s)) {
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
      PVector newHeading = offset.copy().add(force).normalize();
      return newHeading;
    }

    ReasonStopped maybeAddBranch(PVector heading, float mag) {
      if (this.costToRoot > MAX_PATH_COST) {
        return ReasonStopped.Expensive;
      }
      //// make offset go towards +x
      //offset.x += (EXPAND_DIST - offset.x) * TURN_TOWARDS_X_FACTOR;
      // offset.setMag(EXPAND_DIST);
      PVector avoidedHeading = avoidEveryone(heading, mag);
      // we've now moved away from everyone.
      PVector childPosition = this.position.copy().add(avoidedHeading.setMag(mag));
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
        //vertex(this.parent.position.x, this.parent.position.y);
         line(this.parent.position.x, this.parent.position.y, this.position.x, this.position.y);
      } else {
        //vertex(0, 0);
        line(0, 0, this.position.x, this.position.y);
      }
      //vertex(this.position.x, this.position.y);
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

  boolean finished = false;
  void expandBoundary() {
    if (finished) {
      return;
    }

    // reset weights
    for (Small s : world) {
      s.weight = -1;
    }
    root.computeWeight();

    List<Small> newBoundary = new ArrayList();
    for (Small s : boundary) {
      s.branchOut();
      //newBoundary.addAll(s.branchOut());
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

    // reset weights
    for (Small s : world) {
      s.weight = -1;
    }
    root.computeWeight();
    //Collections.sort(world, new Comparator() {
    //  public int compare(Object obj1, Object obj2) {
    //    Small s1 = (Small)obj1;
    //    Small s2 = (Small)obj2;
    //    return Integer.compare(s1.weight, s2.weight);
    //  }
    //}
    //);
  }

  void draw() {
  }

  void drawWorld() {
    // computes whole subtree
    root.computeWeight();
    color gray = #397a4c;
    color green = #808080;
    for (Small s : world) {
      strokeWeight(log(1 + s.weight) / 4);
      stroke(lerpColor(gray, green, s.costToRoot / MAX_PATH_COST));
      s.draw();
      
      //PVector sc = s.screenCoordinates();
      //textSize(2);
      //pushMatrix();
      //translate(s.position.x, s.position.y);
      //rotate(PI / 2);
      //fill(0, 64);
      //textAlign(BOTTOM, RIGHT);
      ////text((int)sc.x+","+(int)sc.y, 0, 0);
      //// text((int)s.position.x+","+(int)s.position.y, 0, 0);
      ////text(s.closeToMouseness(), 0, 0);
      ////text(s.numTurns, s.position.x, s.position.y);
      //text(int(100 * (s.costToRoot / MAX_PATH_COST)), 0, 0);
      //popMatrix();
    }
    endShape();
    for (Small s : terminalNodes) {
      if (s.reason == ReasonStopped.Expensive) {
        strokeWeight(1.3);
        stroke(#77c063);
        s.draw();
      }
    }

    // drawBoundary();
  }

  // degenerate:
  // doesn't grow at all
  // terminal nodes < 10
  // alternatively, to get rid of grass:
  //   terminal nodes who are terminal because it was too expensive.size < 10 
  boolean isDegenerate() {
    return terminalNodes.size() < 10;
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