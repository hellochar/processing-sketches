import processing.core.PVector;
import java.util.*;

class Particle {
  private PVector loc, vel, acc;
  private Particle next;
  
  private Particle() {
  }
  
  public Particle(PVector loc) {
    next = new Particle();
    setLoc(loc);
    update();
  }
  
  public void run(Set<Particle> set) {
    for(Particle p : set) {
      if(p == this) continue;
      PVector add = getLoc();
      add.sub(p.getLoc());
      add.div(add.mag());
      add.div(100);
      setVel(PVector.add(getVel(), add));
    }
  }
  
  public void update() {
    loc = next.loc;
    vel = next.vel;
    acc = next.acc;
    vel.add(acc);
    loc.add(vel);
  }
  
  public void draw() {
    noStroke();
    fill(color(vel.length() * 10, 255, 255));
    ellipse(loc.x, loc.y, 4, 4);
  }
  
  public PVector getLoc() {
    return new PVector(loc);
  }
  
  public PVector getVel() {
    return new PVector(vel);
  }
  
  public PVector getAcc() {
    return new PVector(acc);
  }
  
  public void setLoc(PVector loc) {
    next.loc = loc;
  }
  
  public void setVel(PVector vel) {
    next.vel = vel;
  }
  
  public void setAcc(PVector acc) {
    next.acc = acc;
  }
}
