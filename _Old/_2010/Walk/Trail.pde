class Trail {
  PVector loc;
  float r, g, b;
  float size;
  
  Trail(PVector loc, float r, float g, float b, float size) {
    this.loc = loc;
    this.r = r;
    this.g = g;
    this.b = b;
    this.size = size;
  }
  
  Trail(Trail t, float angle, float speed) {
    this(t.loc.add(PVector.polar(speed, angle)),
    constrain(t.r+random(-5, 5), 0, 255), constrain(t.g+random(-5, 5), 0, 255), constrain(t.b+random(-5, 5), 0, 255),
    map(speed, minSpeed, maxSpeed, 10, 2));
  }
}
