class Plant {
  
  float dx, dy;
  float hue;
  float lifeGiveRegenRate = .1;
  float x, y, life, lifeToGive;
  int millisAlive = 0, lastRun = 0;
  Set<Plant> near = new HashSet();
  
  public Plant(float x_, float y_, float life_) {
    x=x_;
    y = y_;
    life = life_;
    hue = 0;
    lastRun = millis();
  }
  
  Plant(Plant parent) {
    this(constrain(parent.x + parent.neighborhoodSize()*random(-2, 2), 0, width),
         constrain(parent.y + parent.neighborhoodSize()*random(-2, 2), 0, height),
         1);
    hue = (parent.hue + 7)%256; //resets after 37 generations
  }
  
  float neighborhoodSize() {
    return sqrt(life) * 20;
  }
  
  void run() {
    life = life*.99 - (.01 * millisAlive / 1000f);
    lifeToGive += lifeGiveRegenRate;
    float r = neighborhoodSize();
    
//    if(random(1) < .002) toAdd.add(new Plant(constrain(x + random(-35, 35), 0, width), constrain(y + random(-35, 35), 0, height), 1));
//    if(random(1) < .02) toAdd.add(new Plant(constrain(x + random(-r, r), 0, width), constrain(y + random(-r, r), 0, height), 1));
    if(random(1) < .02) toAdd.add(new Plant(this));
    
    near.clear();
    stroke(255);
    for(Plant p : plants) {
      if(p == this) continue;
      float ox = p.x - x,
            oy = p.y - y,
            d2 = ox*ox+oy*oy;
      if(d2 < sq(r*2 + millisAlive / 200f)) {
        near.add(p);
        line(x, y, p.x, p.y);
        dx -= ox/d2*1;
        dy -= oy/d2*1;
      }
    }
    
    switch(near.size() % 3) {
      case 0: break;
      case 1:
        float l = 0;
        for(Plant p : near) {
          float k = min(p.lifeToGive, .1 / near.size());
          l += k;
          p.lifeToGive -= k;
        }
        life += l;
        break;
      case 2: life -= .1*near.size() - .1; break;
    }
    
//    textAlign(CENTER, BOTTOM);
//    fill(255);
//    text(millisAlive, x, y - neighborhoodSize());
    
    if(life <= 0) die();
    int now = millis();
    millisAlive += now - lastRun;
    lastRun = now;
  }
  
  void update() {
    x += dx;
    y += dy;
  }
  
  float dist(Plant p) {
    return PApplet.dist(x, y, p.x, p.y);
  }
  
  void die() {
    toRemove.add(this);
    near.clear();
  }
  
  void draw() {
    noStroke();
    fill(hue, 255, 255, 128);
    float r = 20 + neighborhoodSize() * 5/4f;
    ellipse(x, y, r, r);
  }
}
