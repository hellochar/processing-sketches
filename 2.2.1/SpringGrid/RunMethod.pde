  interface RunMethod {
  void run(Cell c);
}

public final RunMethod method1 = new RunMethod() {
  
  void run(Cell cell) {
    //each cell gets this much velocity for being 1 pos away from its neighbors for 1 second, so vel = (k*distance)*t, and acc = k*distance;
    //using a cheating approximate integration (holding x as constant) one gets v1 = v0 - k*x*t.
    float dacc = 0;
    for(Cell c : cell.neighbors) {
      float diff = cell.pos - c.pos;
      dacc += diff;
    }
    cell.vel -= cell.owner.kNeighborValue / cell.neighbors.size() * dacc * cell.owner.timeStep;
//    cell.vel -= cell.owner.kNeighborValue * dacc / 4  * cell.owner.timeStep;
    
    //self spring: this could get interesting.
    cell.vel -= cell.owner.kSelfValue * cell.pos * cell.owner.timeStep;
    
    //Drag force
    //OLD, INCORRECT IDEA:
      //the velocity will drop to (1-dragFactor)% of it's original velocity after 1 second. vel = v0*e^(-kt), where v0*(1-dragFactor) = v0*e(-k).
      //this means -ln(1 - dF) = k.
      //deriving velocity gives the equation a = -k*v0*e^(-kt), which is what will be used.
  //    float kVal = -log(1 - cell.owner.dragFactor);
  //    cell.vel += -kVal*cell.vel*exp(-kVal * cell.owner.timeStep);
  
    //NEW, WORKING IDEA:
      //The velocity will drop to (1-dragFactor)% of it's original velocity after 1 second. The general idea is that v(t) = k(c) * v(t - c).
      //The equation satisfying this is v(t) = A * e^(-kt). Then, v(t+dt) = e^(-k*dt)v(t), so v(t+dt) - v(t) = v(t)*(e^(-k*dt) - 1), which is the acceleration.
    cell.vel += cell.vel*(exp(-cell.owner.timeStep*cell.owner.dragFactor) - 1);
  }
};
