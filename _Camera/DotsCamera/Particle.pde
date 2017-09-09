
public static float speed = 1;
  
class Particle {
  float lx, ly, x, y, dx, dy;
  float life;
  float hue;
  
  Particle(float x, float y, float dx, float dy, float hue) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.hue = hue;
    life = 1;
  }
  
  Particle(float x, float y, float hue) {
    this(x, y, random(-speed, speed), random(-speed, speed), hue);
  }
  
  void run(Iterator i) {
    lx = x;
    ly = y;
    dx += random(-.1, .1);
    dy += random(-.1, .1);
    x += dx;
    y += dy;
    life -= .01;
    if(life <= 0)
      if(i != null) i.remove();
      else particles.remove(this);
    hue = (hue+random(.02))%1;
  }
  
  void draw() {
    if(life > 0) {
    strokeWeight(2);
    stroke(hue, 1, 1, life/2);
    line(lx, ly, x, y);
    float d1 = 1000000, d2 = 1000000;
    Particle p1 = null, p2 = null;
    for(int i = 0; i < particles.size(); i++) {
      Particle p = (Particle) particles.get(i);
      if(p == this) continue;
      float dist = dist(x, y, p.x, p.y);
      if(dist < 100 && dist < d2) {
        if(dist < d1) {
          d1 = dist;
          p1 = p;
        }
        else {
          d2 = dist;
          p2 = p;
        }
      }
    }
    if(p1 != null)
      line(p1.x, p1.y, x, y);
    if(p2 != null)
      line(p2.x, p2.y, x, y);
    noStroke();
    
    float size = sqrt(life) * 14;
    
//    fill(hue, .2, 1, life/10);
//    ellipse(x, y, size, size);
//    fill(hue, .3, 1, life/5);
//    ellipse(x, y, size*5/8, size*5/8);
//    fill(hue, .6, 1, life/2);
//    ellipse(x, y, size/2, size/2);
    fill(hue, .9, 1, life);
    ellipse(x, y, size*3/8, size*3/8);
    }
  }
  
}
