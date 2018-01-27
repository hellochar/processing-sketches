PVector loc(float t) {
//  return new PVector(.1*dist*dist, 0, dist);
  return new PVector(cos(t), cos(t)+sin(t), cos(t));
}
//
public static int divider = 10000;
public static float dtdivider = interval / divider;
PVector deriv(float t) {
  return PVector.div(PVector.sub(loc(t), loc(t-dtdivider)), interval/divider);
}
//
//PVector tangent(float t) {
//  PVector p = deriv(t);
//  return p / p.mag();
//}
//
//PVector normal(float t) {
//  PVector tangent = tangent(t),
//          dtangent = deriv(tangent);
//  
//}
