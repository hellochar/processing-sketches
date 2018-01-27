abstract class Life {
  Particle p;
  float life;
  
  Life(PVector l, float life) {
    loc = l;
    this.life = life;
  }
  
  abstract void run();
  
}
