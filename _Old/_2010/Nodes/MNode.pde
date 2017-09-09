
private static int counter = 1;

class MNode {

  float x, y;
  Set children;

  final static float rad = 3;
  float mx, my, ang, size, lineScale;
  protected int frameCount;
  int id = counter++;
  int col;

  public MNode(float x, float y, float size, float lineScale, float ang, int col) {
    this.x = x;
    this.y = y;
    children = new HashSet();
    nodes.add(this);
    this.mx = x;
    this.my = y;
    this.size = size;
    this.lineScale = lineScale;
    this.ang = ang;
    this.col = col;
  }

  Vec2 getLoc() {
    return new Vec2(getX(), getY());
  }

  private void align() {
    float ang = radians(frameCount * 2 + getX() + getY());
    setX(mx + rad * cos(ang));
    setY(my + rad * sin(ang));
    frameCount++;
  }


  float angleTo(MNode n) {
    return atan2(n.y - y, n.x - x);
  }

  public Set getChildren() {
    return children;
  }

  public void add(MNode c) {
    children.add(c);
  }

  public void remove(MNode c) {
    children.remove(c);
  }

  public boolean contains(MNode c) {
    return children.contains(c);
  }

  public float getX() {
    return x;
  }

  public void setX(float x) {
    this.x = x;
  }

  public float getY() {
    return y;
  }

  public void setY(float y) {
    this.y = y;
  }

  public void setLoc(float x, float y) {
    mx = x;
    my = y;
    align();
  }

  void setLoc(Vec2 loc) {
    setLoc(loc.x, loc.y);
  }

  void act() {
    align();
  }

  void drawConnects() {
    pushStyle();
    pushMatrix();
    strokeWeight(size * lineScale);
    stroke(0);
    noFill();
    Iterator i = getChildren().iterator();
    //    println(id+": "+getChildren().size());
    while(i.hasNext()) {
      MNode b = (MNode) i.next();
      switch(lineMode) {
      case 0: 
        break;
      case LINE:
        line(getX(), getY(), b.getX(), b.getY());
        break;
      case CURVE:
//        float x1 = ctlPt(this, 1) * width;
//        float y1 = ctlPt(this, 2) * height;
//        float x2 = ctlPt(b, 1) * width;
//        float y2 = ctlPt(b, 2) * height;
//        curve(x1, y1, getX(), getY(), b.getX(), b.getY(), x2, y2);
        float[] pt = ctlPts(this, b);
        curve(pt[0], pt[1], getX(), getY(), b.getX(), b.getY(), pt[2], pt[3]);
        break;
      case BEZIER:
//        float x3 = ctlPt(this, 1) * width;
//        float y3 = ctlPt(this, 2) * height;
//        float x4 = ctlPt(b, 1) * width;
//        float y4 = ctlPt(b, 2) * height;
//        bezier(getX(), getY(), x3, y3, x4, y4, b.getX(), b.getY());
        pt = ctlPts(this, b);
        bezier(getX(), getY(), pt[0], pt[1], pt[2], pt[3], b.getX(), b.getY());
        break;
      }
    }
    popMatrix();
    popStyle();
  }

  void drawEllipses() {
    pushStyle();
    pushMatrix();
    strokeWeight(size * lineScale / 5);
    stroke(0);
//    noFill();
//    ellipse(getX(), getY(), size, size);
    //            fill(m.color / 2);
    //            ellipse(m.getX(), m.getY(), size * 0.8F, size * 0.8F);
    fill(col);
    ellipse(getX(), getY(), size / 2, size / 2);
    popMatrix();
    popStyle();
  }
}

private float[] ctlPts(MNode a, MNode b) {
  float[] ret = new float[4];
  float len = dist(a.x, a.y, b.x, b.y);
  ret[0] = a.x + ctlPt(a, 1) * len;
  ret[1] = a.y + ctlPt(a, 2) * len;
  ret[2] = b.x + ctlPt(b, 1) * len;
  ret[3] = b.y + ctlPt(b, 2) * len;
  return ret;
}

private float ctlPt(float x, float y, float z) {
  return noise(x * 0.002, y * 0.002, z);
}

private float ctlPt(MNode m, float z) {
  return ctlPt(m.getX(), m.getY(), z);
}
