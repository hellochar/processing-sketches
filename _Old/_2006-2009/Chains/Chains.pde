import traer.physics.*;
ParticleSystem ps;

float segLength = 10;

void setup() {
  size(800, 600);
  ps = new ParticleSystem(.12, .01);
}

Particle selected;
float strength = 1, damping = .9;
float size = 9;
boolean shiftDown;

void keyPressed() {
  if(key == CODED & keyCode == SHIFT) {
    shiftDown = true;
  }
}

void keyReleased() {
  if(key == CODED & keyCode == SHIFT) {
    shiftDown = false;
  }
}

void mousePressed() {
  if(selected != null) {
    float lastX = selected.position().x(), lastY = selected.position().y();
    float ang = atan2(mouseY-lastY, mouseX-lastX),
          dist = dist(mouseX, mouseY, lastX, lastY);
    Particle prev = selected;
    for(float a = 0; a < dist; a += segLength) {
      Particle p = ps.makeParticle(1, lastX+a*cos(ang), lastY+a*sin(ang), 0);
      ps.makeSpring(prev, p, strength, damping, segLength);
      prev = p;
    }
    Particle last = ps.makeParticle(1, mouseX, mouseY, 0);
    if(shiftDown)
      last.makeFixed();
    ps.makeSpring(prev, last, strength, damping, segLength);
    selected = null;
  }
  else {
    for(int a = 0; a < ps.numberOfParticles(); a++) {
      Particle p = ps.getParticle(a);
      if(dist(mouseX, mouseY, p.position().x(), p.position().y()) < size) {
        selected = p;
        if(shiftDown)
          selected.makeFixed();
        return;
      }
    }
    selected = ps.makeParticle(1, mouseX, mouseY, 0);
    if(shiftDown)
      selected.makeFixed();
  }
}

void draw() {
  ps.tick();
  background(200);
  strokeWeight(4);
  stroke(color(64, 128));
  for(int a = 0; a < ps.numberOfSprings(); a++) {
    Spring s = ps.getSpring(a);
    line(s.getOneEnd().position().x(), s.getOneEnd().position().y(), s.getTheOtherEnd().position().x(), s.getTheOtherEnd().position().y());
  }
  noStroke();
  for(int a = 0; a < ps.numberOfParticles(); a++) {
    Particle p = ps.getParticle(a);
    if(p.isFixed()) {
      fill(color(255, 255, 0, 128));
    }
    else {
      fill(color(64, 128));
    }  
    ellipse(p.position().x(), p.position().y(), size, size);
  }
}
