class Splatter {
  Trail t;
  PVector[] points;
  
  Splatter(Trail t, int points, float radius) {
    this.t = t;
    this.points = new PVector[points];
    float dang = TWO_PI/points;
    float r = random(20, 30);
    PVector loc = PVector.add(t.loc, new PVector(random(r), random(r)));
    for(int k = 0; k < points; k++) {
      this.points[k] = PVector.add(loc, PVector.random(.5*radius).add(PVector.polar(k*dang, radius)));
    }
  }
  
  void show() {
    fill(t.r, t.g, t.b);
    beginShape();
    for(int a = 0; a < points.length; a++) {
      PVector l = points[a];
      if(camera.isOnScreen(l))
        curveVertex(l.x, l.y);
    }
    endShape();
  }
}
