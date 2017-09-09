import java.util.*;

class Tri {
  PVector a, b, c;
  
  public Tri(PVector a, PVector b, PVector c) {
    this.a = a;
    this.b = b;
    this.c = c;
  }
  
  void draw() {
    noFill();
    stroke(255);
    line(a.x, a.y, b.x, b.y);
    line(b.x, b.y, c.x, c.y);
    line(c.x, c.y, a.x, a.y);
  }
}

List<Tri> tris;

void setup() {
  tris = new ArrayList<Tri>();
  tris.add(new Tri(new PVector(0,0), new PVector(width, 0), new PVector(width * cos(PI/3), width * sin(PI/3))));
}

void draw() {
}
