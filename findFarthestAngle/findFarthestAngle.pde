import zhang.*;

import point2line.*;

Vect2 mid;

List<Vect2> vects;

void setup() {
  size(500, 500);
  mid = new Vect2(width/2, height/2);
  vects = new ArrayList();
  noLoop();
}

float radius = 200;

Comparator<Vect2> angleCompare = new Comparator<Vect2>() {
  
  public int compare(Vect2 a, Vect2 b) {
    return (int)Math.signum(a.angle() - b.angle());
  }
  
  public boolean equals(Object o) {
    return false;
  }
};

/**
 * List must be sorted according to each Vect2's angle() method.
 */
private static Vect2 findFarthestAngle(List<Vect2> vects) {
  if(vects.isEmpty()) bestVec = new Vect2();
  Vect2 bestVec;
  else {
    int bestIndex = 0; float bestAng = 0;
    for(int i = 0; i < vects.size(); i++) {
      float angle = Methods.angleDistance(vects.get(i).angle(), vects.get((i+1)%vects.size()).angle());
      if(abs(angle) > bestAng) { bestAng = angle; bestIndex = i; }
    }
    float newAng = vects.get(bestIndex).angle() + bestAng / 2;
    return new Vect2(newAng);
  }
}

void draw() {
  background(0);
  stroke(255); smooth(); noFill();
  ellipse(mid.x, mid.y, radius, radius);
  for(Vect2 v : vects) {
    line(mid, v);
  }
  
  Vect2 bestVec = findFarthestAngle(vects);
//  float minAng = 0, maxIntensity = 0;
//  for(int ang = 0; ang < 360; ang ++) {
//    float angle = radians(ang);
//    Vect2 newV = new Vect2(angle).scaled(radius*2);
//    float intens = intensityFor(angle);
//    stroke(color(map(intens, 0, PI, 0, 20)));
//    if(intens > maxIntensity) { maxIntensity = intens; minAng = angle; }
//    line(mid, newV);
//  }
//  Vect2 bestVec = new Vect2(minAng).scaled(maxIntensity*10);
  stroke(255, 0, 0);
  line(mid, bestVec);
}

void line(Vect2 m, Vect2 v2) {
  Vect2 v = v2.added(m);
  line(mid.x, m.y, v.x, v.y);
}

//float intensityFor(float ang) {
//  float num = 0;
////  print("For angle "+degrees(ang)+", ");
//  for(Vect2 v : vects) {
//    num += abs(Methods.angleDistance(ang, v.angle()));
////    print(Methods.angleDistance(ang, v.angle())+", ");
//  }
////  println();
//  return num;
//}


void mousePressed() {
  Vect2 newVect = new Vect2(mouseX, mouseY).subtracted(mid);
  vects.add(newVect);
  Collections.sort(vects, angleCompare);
//  println("Added vect "+newVect+"("+degrees(newVect.angle())+"). size is now "+vects.size());
  redraw();
}
