float maxSpeed = 10, minSpeed = .2;

class Walker extends ArrayList {
  float angle;
  float speed;

  Walker(PVector loc, float ang, float speed, float r, float g, float b) {
    super();
    add(new Trail(loc, r, g, b, map(speed, minSpeed, maxSpeed, 10, 2)));
    this.angle = ang;
    this.speed = speed;
  }
  
  Trail last() {
    return (Trail) get(size()-1);
  }
  
  void show() {
    for(int a = 0; a < size()-1; a++) {
      Trail t = (Trail)get(a);
      strokeWeight(t.size);
      stroke(color(t.r, t.g, t.b, 200));
      Trail next = (Trail)get(a+1);
      if(camera.isOnScreen(t.loc) || camera.isOnScreen(next.loc))
        line(t.loc.x, t.loc.y, next.loc.x, next.loc.y);
    }
  }
  
  void changeSpeed(float change) {
    speed = constrain(speed+change, minSpeed, maxSpeed);
  }

  void run() {
    if(random(1) > .1)
      angle += radians(random(-4, 4));
    else {
      angle += radians(random(20, 90)*Math.signum(random(-1, 1)));
    }
    if(random(1) < .1) {
      splatters.add(new Splatter(last(), (int)random(7, 12), random(25, 30)));
    }
    changeSpeed(random(-.5, .5));
    add(new Trail(last(), angle, speed));
  }

}

