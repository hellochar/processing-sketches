class Dot {
  //loc is the current pixel location, and v is the pixels per second
  PVector loc, lastLoc, v, a;
  int c;
  
  Dot(PVector loc_, int c) {
    loc = loc_;
    lastLoc = new PVector(loc.x, loc.y, loc.z);
    v = new PVector();
    a = new PVector();
    this.c = c;
  }
  
  void run() {
    lastLoc.set(loc);
//    a = velAt(loc);
//    a.mult(millisThisFrame()/1000f);

    v = velAt(loc);
    println(v);
    v.mult(20*millisThisFrame()/1000f);
    
    loc.add(v);
  }
  
  void draw() {
    stroke(c);
    pushMatrix();
    translate(loc.x, loc.y, noiseAt(loc));
    noStroke();
    sphereDetail(8);
    fill(30, 100, 100);
    sphere(9);
    popMatrix();
//    strokeWeight(20);
//    line(lastLoc.x, lastLoc.y, noiseAt(lastLoc), loc.x, loc.y, noiseAt(loc));
  }
  
}
