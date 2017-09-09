//2 drawer
/*
double var = 2;
double equals = 1*var;
double prec = 25;
void solveFor(double x, double y) {
  equals = 1*var;
//  double value = 4*x*x*(y+2)-9*y*y*(y+2)+y*Math.pow(Math.E, x);
  double value = (4*x*x+9*y*y)*(y+2)*(Math.pow(Math.E, x));
//  setPixAt(x, y, colorBands[(int)Math.max(Math.min(prec/Math.abs(value-equals), colorBands.length-1), 0)]);
  setPixAt(x, y, lerpColor(c0, c1, (float)((255-prec*constrain((float)Math.abs(value-equals), 0, 255/(float)prec))/255)));
}
*/
