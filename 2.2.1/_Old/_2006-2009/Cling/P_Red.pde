
class Red extends Particle
{
  Red(int x, int y) 
  {
    this.x = x;
    this.y = y;
    c = RED_COLOR;
  }

  void run() {
    int dx = RED_MOVE_X;
    int dy = RED_MOVE_Y;
    int ox = 0;
    int oy = 0;
    boolean near = false;
    int partnered = 0;
    int nearby = 0;
    if(green()) partnered = RED_PARTNERED_MOVE_RATE;
    for(int nx = -1; nx < 2; nx++)
      for(int ny = -1; ny < 2; ny++)
      {
        color ct = w.getpix(x+nx, y+ny);
        if(ct!=black) nearby++;
        if(ct == red && (x+nx!=x | y+ny!=y)) {
          if(!near) near = true;
          partnered++;
          ox -= nx*RED_AVOID_RATE;
          oy -= ny*RED_AVOID_RATE;
        }
        else if(ct == blue)
        {
          partnered--;
        }
        else if(ct == green)
        {
          near = true;
          ox -= nx*RED_AVOID_RATE;
          oy -= ny*RED_AVOID_RATE;
          partnered++;
        }
      }
    if(partnered >= RED_PARTNER_REQ) {
      if(redMoveXType == RED_MOVE_X_RANDOM) { if(dx < 0) dx = -dx; dx = (int)random(-dx-1, dx+1); }
      if(redMoveYType == RED_MOVE_Y_RANDOM) { if(dy < 0) dy = -dy; dy = (int)random(-dy-1, dy+1); }
      if(!near){
        offset(dx, dy);
      } else {
        dx = bounds(dx+ox, RED_LOWBOUND_X, RED_HIGHBOUND_X);
        dy = bounds(dy+oy, RED_LOWBOUND_Y, RED_HIGHBOUND_Y);
        if(w.getpix(x+dx, y+dy) == black) offset(dx, dy);
        else if(w.getpix(x, y+dy) == black) move(x, y+dy);
        else if(w.getpix(x+dx, y) == black) move(x+dx, y);
      }
    }
    else w.setpix(x, y, green);
  }
}
