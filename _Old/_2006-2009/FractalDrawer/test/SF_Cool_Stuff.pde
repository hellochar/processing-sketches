//Good stuff
/*
double nx, ny;
double xtemp, ytemp;
void solveFor(double x, double y) {
  iter = 0;
  nx = x+xIncr/2;
  ny = y+yIncr/2;
  if(nx == 0 | ny == 0) iter = maxIter;
  while(Math.abs(nx) > .01 & iter++ < maxIter) {
    xtemp = nx * ny + x;
    ytemp = nx/ny + y;
    nx = xtemp;
    ny = ytemp;
  }
  if(iter >= maxIter) {
    setPixAt(x, y, #000000);
  }
  else {
    setPixAt(x, y, colorBands[iter%colorBands.length]);
  }
}
*/
