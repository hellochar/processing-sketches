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
      this.points[k] = PVector.add(loc, PVector.add(randomVec(.5*radius),Methods.fromPolar(k*dang, radius)));
    }
  }
  
  void show() {
    fill(t.r, t.g, t.b);
    beginShape();
    for(int a = 0; a < points.length; a++) {
      PVector l = points[a];
      if(camera.isVisible(l))
        curveVertex(l.x, l.y);
    }
    endShape();
  }
}

PVector randomVec(float mag) {
  float angle = random(TWO_PI);
  return Methods.fromPolar(mag, angle);
}

