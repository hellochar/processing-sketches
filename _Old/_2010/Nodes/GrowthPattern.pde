class GrowthPattern extends GrowthSet {

  public GrowthPattern() {
    super(new LinkedList());
  }

  public GrowthPattern createRandom() {
    GrowthPattern pat = new GrowthPattern();
    int num = (int) random(1, 4);
    for (int k = 0; k < num; k++) {
      pat.addGrowth(getRandomGrowth());
    }
    return pat;
  }
  
    public int getGrowNum() {
        int k = 1;
        Iterator i = grows.iterator();
        while(i.hasNext()) {
            Growth g = (Growth) i.next();
            k *= g.getGrowNum();
        }
        return k;
    }

  public Set grow(Set parents) {
    Iterator growIterator = grows.iterator();
    while(growIterator.hasNext()) {
      Growth g = (Growth) growIterator.next();
      Set children = new HashSet();
      Iterator setIterator = parents.iterator();
      while(setIterator.hasNext()) {
        MNode n = (MNode)setIterator.next();
        children.addAll(g.grow(n));
      }
//      println("finisehd growing for "+g);
      parents = children;
    }
//    println("done growing");
    return parents;
  }

  public Set grow(MNode parent) {
    Set set = new HashSet();
    set.add(parent);
    return grow(set);
  }
}



