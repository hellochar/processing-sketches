double func(double t) {
  double t2 = t*t,
  t3 = t2*t,
  t4 = t2*t2,
  t6 = t4*t2;
  return t2*
    Math.sin(t3+t4)*
    Math.sqrt(4*t2+
    9*t4+
    16*t6);
}

void setup() {
  double acc = 0;
  double dt = .0000001;
  for(double t = 0; t < 5; t += dt) {
//    for(int k = 0; k < 50 && t < 5; t += dt, k++) {
      acc += func(t) * dt;
//    }
//    println(t / 5 * 100+" % done!");
  }
  println(acc);
}

