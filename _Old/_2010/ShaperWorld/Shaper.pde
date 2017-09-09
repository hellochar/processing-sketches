public final int SINE = 1,
SAW = 2,
SQ = 3,
TRI = 4;

class Shaper extends Unit {
  int type;
  Particle p;
  Oscillator o;
  float dx, dy;

  Shaper(int type, float x, float y) {
    super(x, y);
    this.type = type;
    p = ps.makeParticle(1, x, y, 0);
    for(int a = 0; a < ps.numberOfParticles(); a++) {
      ps.makeAttraction(p, ps.getParticle(a), 100, 10);
    }
    switch(type) {
    case SINE:
      o = new SineWave(freqFor(x), ampFor(y), 44100);
      break;
    case SAW:
      o = new SawWave(freqFor(x), ampFor(y), 44100);
      break;
    case SQ:
      o = new SquareWave(freqFor(x), ampFor(y), 44100);
      break;
    case TRI:
      o = new TriangleWave(freqFor(x), ampFor(y), 44100);
      break;
    }
    out.addSignal(o);
  }

  public float x() {
    return p.position().x();
  }

  public float y() {
    return p.position().y();
  }

  public void run() {
  }

  public void update() {
    dx = x()-x;
    dy = y()-y;
    x = x();
    y = y();
    o.setFreq(freqFor(x));
    o.setAmp(ampFor(y));
  }

  void draw() {
    float angle = atan2(dy, dx);
    float speed = dist(0, 0, dx, dy);
    pushMatrix();
    translate(x, y);
    rotate(angle);
    stroke(color(speed*25, 0, 0));
    
    switch(type) {
      case SINE:
        ellipse(0, 0, 1, 1);
        break;
      case SAW:
        beginShape();
        vertex(-.5, -.5);
        for(float x = -.5; x < .5; x += .5) {
          vertex(x, .5);
          vertex(x, -.5);
        }
        vertex(.5, .5);
        endShape();
        break;
      case SQ:
        rect(-.5, -.5, 1, 1);
        break;
      case TRI:
        beginShape();
        vertex(-.5, -.5);
        vertex(0, .5);
        vertex(.5, -.5);
        endShape();
        break;
    }
    if(!out.isEnabled(o)) {
      ellipse(0, 0, 5, 5);
    }
    popMatrix();
  }

}

