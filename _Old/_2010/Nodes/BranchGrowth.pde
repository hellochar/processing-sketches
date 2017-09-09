class BranchGrowth extends SingleGrowth {

    public int num;
    public float angOffset, len;

    public BranchGrowth() {
    }

    public String getText() {
      return "num="+num+", angOffset="+angOffset+", len="+len;
    }
    
    public BranchGrowth(int numChild, float angOffset, float len) {
        this.num = numChild;
        this.angOffset = angOffset;
        this.len = len;
    }

    public int getGrowNum() {
        return num;
    }

    public BranchGrowth createRandom() {
        return new BranchGrowth((int)random(1, 5), random(180), random(25, 200));
    }


    public Set getGrowth(MNode parent) {
        float angOffset = radians(this.angOffset);
        Set set = new HashSet();
        float ang = parent.ang - angOffset / 2;
        for (int k = 0; k < num; k++) {
            set.add(new MNode(parent.getX() + len * cos(ang), parent.getY() + len * sin(ang), parent.size * .8, parent.lineScale, ang, parent.col));
            ang += angOffset;
        }
        return set;
//            println(id+": "+getChildren().size());
    }
}

