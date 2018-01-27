import java.util.*;

Set<Geometry> S = new HashSet(),
              Sprev = new HashSet();
Set<PMatrix2D> T = new HashSet();

import zhang.Camera;

public void setup() {
  size(500, 500);
  reset();
  new Camera(this);
}

public void reset() {
  S.clear();
  Sprev.clear();
  S.add(new Geometry());
  PMatrix2D p1 = new PMatrix2D();
  p1.rotate(PI/8);
  T.add(p1);

//  PMatrix2D p1 = new PMatrix2D();
//  p1.translate(.25f, .25f);
//  p1.scale(.5f);
//  T.add(p1);

//  PMatrix2D p2 = new PMatrix2D();
//  p2.rotate(PI/8);
//  p2.translate(1.25f, .25f);
//  T.add(p2);

}

/**
EBNF grammar. Should support creation of transform, rotate, scale, (and maybe shearX/Y later) matricies, and be able to combine them with + and *. 
for the future: Arbitrary 3x2 matricies should be buildable

Expr ::= Term { op Term }
Term ::= MatrLit | "(" Expr ")"
MatrLit ::= T(num, num) | R(num) | S(num[, num]) | M(num, num, num, num, num, num)
num  ::= any float parsable by Float.parseFloat()
op   ::= (no character) | * | +
*/
public PMatrix2D parse(String s) {
  return null;
}

boolean drawSPrev = false;
void draw() {
  background(0);
  noStroke();
//  noFill();
  fill(60, 230, 25, 40);
  for(Geometry g : S) {
    g.render();
  }
  if(drawSPrev) {
  stroke(210, 40, 65);
  for(Geometry g : Sprev) {
    g.render();
  }
  }
}

void mousePressed() {
  Sprev = S;
  S = iterated();
}

void keyPressed() {
  if(key == 'r') {
    reset();
  }
}

/*
a) you have a set of geometric objects (points, lines, polygons, curves, etc) (named S)
b) you have a set of transformations (rotate, translate, scale, shear, etc) (named T)
c) you apply each transformation to each object in that set, which gives you the set of transformed objects S' (giving you num(S)*num(T) new objects)
d) Use S' as the set S in a)
*/
Set<Geometry> iterated() {
  Set<Geometry> Sprime = new HashSet();
  for(Geometry g : S) {
    for(PMatrix2D t : T) {
      Sprime.add(g.transformed(t));
    }
  }
  return Sprime;
}

void vertex(PVector v) {
  vertex(v.x, v.y);
}

class Geometry {
  PMatrix2D t; //The transformation this geometry should undertake
  
  Geometry() {
    t = new PMatrix2D();
    t.scale(width/2);
  }
  
  void draw() {
   PVector a = t.mult(new PVector(), null),
           b = t.mult(new PVector(1, 0), null),
           c = t.mult(new PVector(1, 1), null),
           d = t.mult(new PVector(0, 1), null);
           
   beginShape();
   vertex(a);
   vertex(b);
   vertex(c);
   vertex(d);
   endShape(CLOSE);
//   rectMode(CORNERS);
//   rect(o.x, o.y, r.x, r.y);
//    rect(0, 0, 1, 1);
  }
  
  void render() {
//    pushMatrix();
////    applyMatrix(t);
    draw();
//    popMatrix();
  }
  
  Geometry transformed(PMatrix2D p) {
    Geometry g = new Geometry();
    g.t = t.get(); //clone my transform to the new geometry
    g.t.apply(p); //apply the new transform to the new geometry
    return g;
  }
  
}
