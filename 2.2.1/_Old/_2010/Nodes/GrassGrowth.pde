class GrassGrowth extends SingleGrowth {

    public int num;
    public float radius, len, angOffset;

    public GrassGrowth() {
    }
    
    public String getText() {
      return "num="+num+", radius="+radius+", len="+len+", angOffset="+angOffset;
    }
    
    public int getGrowNum() {
      return num;
    }

    public GrassGrowth(int num, float radius, float dist, float angOffset) {
        this.num = num;
        this.radius = radius;
        this.len = dist;
        this.angOffset = angOffset;
    }

    public Growth createRandom() {
        return new GrassGrowth((int)random(1, 5), random(45), random(100, 200), random(360));
    }

    public Set getGrowth(MNode parent) {
        float angOffset = radians(this.angOffset);
        Set set = new HashSet();
        float dx = parent.getX() + len * cos(parent.ang),
              dy = parent.getY() + len * sin(parent.ang);
        for(int x = 0; x < num; x++) {
            float ang = map(x, 0, num, 0, TWO_PI) + angOffset + parent.ang;
            float mx = dx + radius * cos(ang),
                  my = dy + radius * sin(ang);
            set.add(new MNode(mx, my, 
                    parent.size * .8, parent.lineScale, 
                    atan2(my - parent.getY(), mx - parent.getX()), 
                    parent.col));
        }
        return set;
    }

}
