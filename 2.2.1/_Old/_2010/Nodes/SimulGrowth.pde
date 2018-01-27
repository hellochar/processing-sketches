class SimulGrowth extends GrowthSet {

  public SimulGrowth() {
    super(new HashSet());
  }

  public int getGrowNum() {
    int k = 0;
    Iterator i = grows.iterator();
    while(i.hasNext()) {
      Growth g = (Growth) i.next();
      k += g.getGrowNum();
    }
    return k;
  }

  public SimulGrowth createRandom() {
    SimulGrowth s = new SimulGrowth();
    int k = (int)random(1, 4);
    for(int x = 0; x < k; x++) {
      s.grows.add(getRandomGrowth());
    }
    return s;
  }

  public Set grow(MNode parent) {
    Set set = new HashSet();
    Iterator i = grows.iterator();
    while(i.hasNext()) {
      Growth g = (Growth) i.next();
      set.addAll(g.grow(parent));
    }
    return set;
  }

}

