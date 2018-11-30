class Leaf {
  List<Vein> world = new ArrayList();

  Vein root;
  // outer boundary from last growth step
  List<Vein> boundary = new ArrayList();
  // nodes without any children
  List<Vein> terminalNodes = new ArrayList();
  boolean finished = false;

  Leaf() {
    root = new Vein(this, new PVector(EXPAND_DIST, 0));
    root.distanceToRoot = 0;
    root.costToRoot = 0;
  }

  void firstGrow() {
    for (float y = -160; y <= 160; y += 12) {
    //for (float y = -12; y <= 12; y += 12) {
      PVector target = new PVector(3, y);
      PVector targetOffset = target.copy().sub(root.position);
      root.maybeAddBranch(targetOffset.copy().normalize(), targetOffset.mag());
    }
    boundary.addAll(root.children);
  }

  void expandBoundary() {
    if (finished) {
      return;
    }

    // reset weights
    for (Vein s : world) {
      s.weight = -1;
    }
    root.computeWeight();

    List<Vein> newBoundary = new ArrayList();
    for (Vein s : boundary) {
      s.branchOut();
      //newBoundary.addAll(s.branchOut());
      newBoundary.addAll(s.children);
    }
    if (newBoundary.size() == 0) {
      finished = true;
    }
    //world.addAll(newBoundary);

    for (Vein s : boundary) {
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
    for (Vein s : world) {
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
    // color startColor = #397a4c;
    //color startColor = #000000;
    //color startColor = #ffffff;
    //color startColor = #21851b;
    for (Vein s : world) {
      if (s.depth < 2) {
        continue;
      }
      strokeWeight(1 * log(1 + s.weight) / 7);
      stroke(lerpColor(branchStartColor, branchEndColor, s.costToRoot / MAX_PATH_COST), 128);
      //stroke(startColor, 128);
      //stroke(green, 128);
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
    for (Vein s : terminalNodes) {
      if (s.reason == ReasonStopped.Expensive) {
        strokeWeight(1.3);
        stroke(leafColor, 128);
        s.draw();
      }
    }

    // drawBoundary();
  }

  void update() {
    for (Vein s : world) {
      s.update();
    }
    root.computePositions();
  }

  // degenerate:
  // doesn't grow at all
  // terminal nodes < 10
  // alternatively, to get rid of grass:
  //   terminal nodes who are terminal because it was too expensive.size < 10 
  boolean isDegenerate() {
    return terminalNodes.size() < 10;
  }
}