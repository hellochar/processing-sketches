class Particle extends Entity {
  float dx, dy;
  
  Particle(float x_, float y_) {
    super(x_, y_, g);
//    dx = random(-4, 4);
//    dy = random(-4, 4);
  }
  
  void run() {
//    println("ran!");
    Iterator i = getGrid().getInCircle(x(), y(), 20).iterator();
//    dx = dy = 0;
    dx *= .95;
    dy *= .95;
    while(i.hasNext()) {
      Particle p = (Particle) i.next();
      if(p != this) {
      float dist = dist(p);
      dx -= 3 * (p.x()-x())/dist;
      dy -= 3 * (p.y()-y())/dist;
      }
    }
    set(x()+dx, y()+dy);
  }
  
  void outOfBounds() {
    float nx = x(), ny = y();
    if(x() <= 0 || x() >= width) {
      dx *= -1;
      nx = constrain(nx, 0, width);
    }
    if(y() <= 0 || y() >= height) {
      dy *= -1;
      ny = constrain(ny, 0, height);
    }
    set(nx, ny);
    println("out of bounds at "+x()+", "+y());
  }
  
  void show() {
    stroke(255);
    smooth();
    float size = 5;
    float sq2 = sqrt(2);
    line(x()+size, y(), x()-size, y());
    line(x()+size/sq2, y()+size/sq2, x()-size/sq2, y()-size/sq2);
    line(x(), y()+size, x(), y()-size);
    line(x()-size/sq2, y()+size/sq2, x()+size/sq2, y()-size/sq2);
  }
}
