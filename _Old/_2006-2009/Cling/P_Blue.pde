
class Blue extends Particle
{
  Blue(int x, int y) 
  {
    this.x = x;
    this.y = y;
    c = BLUE_COLOR;
  }

  void run() {
    int dx = BLUE_MOVE_X;
    int dy = BLUE_MOVE_Y;
    int ox = 0;
    int oy = 0;
    boolean near = false;
    int partnered = 0;
    int nearby = 0;
    if(green()) partnered = BLUE_PARTNERED_MOVE_RATE;
    for(int nx = -1; nx < 2; nx++)
      for(int ny = -1; ny < 2; ny++)
      {
        color ct = w.getpix(x+nx, y+ny);
        if(ct!=black) nearby++;
        if(ct == blue && (x+nx!=x | y+ny!=y)) {
          if(!near) near = true;
          partnered++;
          ox -= nx*BLUE_AVOID_RATE;
          oy -= ny*BLUE_AVOID_RATE;
        }
        else if(ct == red)
        {
          partnered--;
        }
        else if(ct == green)
        {
          near = true;
          ox -= nx*BLUE_AVOID_RATE;
          oy -= ny*BLUE_AVOID_RATE;
          partnered++;
        }
      }
    if(partnered >= BLUE_PARTNER_REQ) {
      if(blueMoveXType == BLUE_MOVE_X_RANDOM) { if(dx < 0) dx = -dx; dx = (int)random(-dx-1, dx+1); }
      if(blueMoveYType == BLUE_MOVE_Y_RANDOM) { if(dy < 0) dy = -dy; dy = (int)random(-dy-1, dy+1); }
      if(!near){
        offset(dx, dy);
      } else {
        dx = bounds(dx+ox, BLUE_LOWBOUND_X, BLUE_HIGHBOUND_X);
        dy = bounds(dy+oy, BLUE_LOWBOUND_Y, BLUE_HIGHBOUND_Y);
        if(w.getpix(x+dx, y+dy) == black) offset(dx, dy);
        else if(w.getpix(x, y+dy) == black) move(x, y+dy);
        else if(w.getpix(x+dx, y) == black) move(x+dx, y);
      }
    }
    else w.setpix(x, y, green);
  }
}
