
//strangeness
/*
double cap = 5.0;
double div = 7;
double top = .4;
double mult = 10;
double xDif, yDif, current, dif;
void solveFor(double x, double y) {
  xDif = x*x/top-y*x;
  yDif = y*y/top-x*y;
  current = 0;
  dif = xDif-yDif;
  do {
    current += dif;
    if(current/div%1 < top) {
      break;
    }
  }
  while(current < cap);
  setPixAt(x, y, color((float)(current/cap*255)));
}
*/

/*
void keyPressed() {
  switch(keyCode) {
  case UP:
    div++;
    render();
    break;
  case DOWN:
    if(div > 1) {
      div--;
      render();
    }
    break;
  case LEFT:
    if(top > .01) {
      top -= .01;
      render();
    }
    break;
  case RIGHT:
    if(top < .99) {
      top += .01;
      render();
    }
    break;
  }
  if(key == '=') {
    mult++;
    render();
  }
  else if(key == '-') {
    mult--;
    render();
  }
}*/
