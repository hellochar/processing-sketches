//an emitter inputs energy into the system by constantly vibrating the membrane at a given point.
//At each time step, it calculates how much acceleration should be added to that cell, and adds it to the cell's velocity.
class Emitter {
  int x, y;
  private float freq, amp; //number of periods per second, and amp is the maximum pixel displacement under equilibrium position.
  Grid owner;

  public Emitter(int x, int y, float freq, float amp) {
    this.x = x;
    this.y = y;
    this.freq = freq;
    this.amp = amp;
  }

  public Emitter(int x, int y) {
    this(x, y, 1, 250);
  }
  
  public void setFreq(float val) {
//    assert (1f / owner.timeStep) / 2 > freq;
    if(val > (1f / owner.timeStep / 2)) freq = (1f / owner.timeStep / 2);
    else freq = val;
  }
  
  void setOwner(Grid g) {
    assert g.inBounds(x, y);
    //according to the nyquist sampling theorem, the max frequency must be half the sampling freq; the sampling period is denoted by the timeStep
    assert (1f / g.timeStep) / 2 > freq;
    owner = g;
  }

  void run() {
    float val = val();
    owner.cellAt(x, y).pos = val*owner.timeStep;
  }

  float val() {
//    return amp * sin(TWO_PI * freq * owner.timeElapsed);
    //for the equation x = amp * sin(2pi*f*time), double derivation gives a = -(2pi*f)^2*amp*sin(2pi*f*t).
    float w = angularFreq();
    return -w*w*amp*sin(w*owner.timeElapsed);
  }
  
  float angularFreq() {
    return TWO_PI * freq;
  }

  void draw() {
    noFill(); 
    stroke(255);
    float mx = x*owner.multX,
    my = y*owner.multY;
    ellipse(mx, my, 10, 10);
    line(mx-5, my, mx+5, my); 
    line(mx, my-5, mx, my+5);
  }
}

