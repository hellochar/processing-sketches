int indexTot = 0;

class Planet {
  PVector loc, vel, acc;
  final float mass, rad;
  int indtot = indexTot++;
  int gen;
  boolean dead = false;
  
  Planet(PVector loc_, PVector vel_, float m, int gen) {
    loc = loc_;
    vel = vel_;
    acc = new PVector();
    mass = m;
    this.gen = gen;
    rad = pow(.75*mass, 1.0/3);
  }
  
  Planet(PVector loc_, float m) {
    this(loc_, new PVector(), m, 0);
  }
  
  void run() {
    if(dead) return;
    for(Planet p : planets) {
      if(p == this || p.dead) continue;
      PVector of = PVector.sub(p.loc, loc);
      float dist2 = of.x*of.x+of.y*of.y+of.z*of.z, dist = sqrt(dist2);
      acc.add(PVector.mult(of, p.mass*GRAV_POW/dist2));
      if(dist < rad() + p.rad()) {//collision
        toRemove.add(this);
        toRemove.add(p);
        dead = p.dead = true;
        println(indtot+", "+p.indtot+" died!");
        float mtot = mass+p.mass;
        PVector mid = avg(loc, p.loc);
        if(mtot < 1000) { //combination
          toAdd.add(new Planet(mid, PVector.add(vel, p.vel), mtot, gen+1));
        }
        else { //explosion
          List<Float> masses = new LinkedList();
          float momentum = PVector.add(vel, p.vel).mag() * mtot;
          
          masses.add(mtot);
//          while(mtot > 0) {
//            float chunk;
//            if(.03*mtot < 10) chunk = mtot;
//            else chunk = random(.03*mtot, .4*mtot);
//            masses.add(chunk);
//            mtot -= chunk;
//          }
          momentum /= masses.size();
          //all pieces should get equal momentum
          for(int i = 0; i < masses.size(); i++) {
            PVector newVel = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
            newVel.normalize(); //gets a random direction
            newVel.mult(momentum / masses.get(i));
            println("new vel: "+newVel);
            toAdd.add(new Planet(PVector.add(mid, newVel), newVel, masses.get(i), gen+1));
          }
        }
      }
    }
  }
  
  float rad() {
    return rad;
  }
  
  void update() {
    acc.mult(DELTA_T);
    vel.add(acc);
    
    vel.mult(.98);
    PVector p = PVector.mult(vel, DELTA_T);
    loc.add(p);
    acc.set(0, 0, 0);
  }
  
  void draw() {
    pushMatrix();
    translate(loc.x, loc.y, loc.z);
    noStroke();
    fill(color(gen%5, 5, 5));
//    sphere(mass);
    sphere(rad());
    popMatrix();
  }
}
