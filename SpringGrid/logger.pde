

void addLogger(int x, int y) {
    loggers.add(new logger(x, y));
}

class logger {
  float thresh = 1;
  int x, y;
  float timeStarted;
  Cell c;
  List<Float> values,
              times,
              vels;
  
  logger(int x, int y) {
    this.x = x;this.y = y;
    c = grid.cellAt(x, y);
  }
  
  String print() {
    String s = "time, pos, vel";
    for(int i = 0; i < values.size(); i++) {
      s += (times.get(i)+", "+values.get(i))+", "+vels.get(i)+"\n";
    }
    return s;
  }
  
  void draw() {
    noStroke(); fill(255, 255, 0);
    rect(x*grid.multX, y*grid.multY, grid.multX, grid.multY);
  }

  void run() {
    if(values == null) {
      if(abs(c.pos) > thresh) { values = new LinkedList(); times = new LinkedList(); vels = new LinkedList(); }
      else return;
    }
    times.add(grid.timeElapsed);
    values.add(c.pos);
    vels.add(c.vel);
  }
  
  public String toString() {
    if(values == null) return "logger at "+x+", "+y+" never procced!";
    return "logger at "+x+", "+y+"!\n"+print();
  }
}
Set<logger> loggers = new HashSet();

void stop() {
  for(logger l : loggers) println(l);
}

