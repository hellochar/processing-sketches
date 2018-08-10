class Vein {
  PVector position;
  Vein parent;
  List<Vein> children;
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
  PVector _offset;
  Leaf leaf;

  Vein(Leaf leaf, PVector pos) {
    this.leaf = leaf;
    this.position = pos;
    this.children = new LinkedList();
    this._offset = this.position.copy();
    leaf.world.add(this);
  }

  void add(Vein s) {
    s.parent = this;
    s._offset = s.position.copy().sub(this.position);

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

    //Vein lastBranch = this;
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
    
    // drought outside user skeleton area
    cost += 20;

    PVector screen = s.screenCoordinates();
    int depthX = (int)map(screen.x, 0, width, 0, depthImage.width);
    int depthY = (int)map(screen.y, 0, height, 0, depthImage.height);
    int depthPixelIndex = depthY * depthImage.width + depthX;
    if (depthPixelIndex >= 0 && depthPixelIndex < depthImage.pixels.length) {
      float alpha = brightness(depthImage.pixels[depthPixelIndex]);
      if (alpha < 255) {
        cost = 0;
      }
    }

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

  void update() {
    this._offset.rotate(sin(millis() / 500f + PI/2) * 0.001 * depth);
  }

  void computePositions() {
    // based off offsets
    if (this.parent != null) {
      this.position.set(this.parent.position);
      this.position.add(this._offset);
    }
    for (Vein s : children) {
      s.computePositions();
    }
  }

  PVector offset() {
    return this._offset.copy();
  }

  ReasonStopped reason;
  // attempt to grow outwards in your direction and to the side
  List<Vein> branchOut() {
    List<Vein> nodes = new ArrayList();
    if (isTerminal) {
      reason = ReasonStopped.Crowded;
      nodes.add(this);
      return nodes;
    }
    PVector offset = this.offset();
    float mag = min(EXPAND_DIST, offset.mag());
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
   * Get the non-immediate-family Vein nearest to the point.
   */
  Vein nearestCollidableNeighbor(PVector point) {
    Vein nearestNeighbor = null;
    float nearestNeighborDist = 1e10;
    for (Vein s : leaf.world) {
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

  boolean isImmediateFamily(Vein s) {
    return s == this || s.parent == this;
  }

  boolean isAncestor(Vein s) {
    Vein tester = this;
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
    for (Vein s : leaf.boundary) {
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
    Vein nearestNeighbor = nearestCollidableNeighbor(childPosition);
    if (nearestNeighbor != null && nearestNeighbor.position.dist(childPosition) < TOO_CLOSE_DIST) {
      childPosition.set(nearestNeighbor.position);

      // we're too close! terminate ourselves
      return ReasonStopped.Crowded;

      //isTerminal = true;
    }

    Vein newVein = new Vein(leaf, childPosition);
    newVein.isTerminal = isTerminal;
    this.add(newVein);
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
      for (Vein s : this.children) {
        s.computeWeight();
        weight += s.weight;
      }
      this.weight = weight;
    }
  }
}