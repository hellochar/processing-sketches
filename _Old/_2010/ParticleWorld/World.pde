import processing.core.*;

class World {
  Set<Particle> set;
  PApplet pap;
  
  public World(PApplet p) {
    set = new HashSet<Particle>();
    this.pap = p;
  }
  
  public void step() {
    for(Particle p : set) {
      p.run(set);
    }
    for(Particle p : set) {
      p.update();
    }
    for(Particle p : set) {
      p.draw();
    }
  }
}
