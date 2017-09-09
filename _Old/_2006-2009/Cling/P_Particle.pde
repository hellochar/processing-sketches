abstract class Particle
{
  color c;
  int x;
  int y;
  boolean alive = true;

  abstract void run();

  void move(int nx, int ny)
  {
    w.setpix(x, y, black);
    w.setpix(nx, ny, c);
    x = nx;
    y = ny;
  }
  
  void kill() {
    alive = false;
    w.setpix(x, y, black);
  }
  
  void offset(int dx, int dy) {
    move(x+dx, y+dy);
  }

  color current() {
    return w.getpix(x, y);
  }

  boolean green() {
    return current() == green;
  }

}
