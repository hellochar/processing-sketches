float y0 = 0.1;
float dt = 0.04;

class Record {
  float t;
  float y;
  float prevY = Float.NEGATIVE_INFINITY;

  Record(float t, float y) {
    this.t = t;
    this.y = y;
  }

  Record stepExact(float dt) {
    float newT = t + dt;
    float newY = exactY(newT, y0);
    return new Record(newT, newY);
  }

  Record stepEuler(float dt) {
    // taylor series expansion of y(t), for any other number a, is y(t) = y(a) + y'(a)*(t-a) + y''(a)*(t-a)^2/2! + y'''(a)*(t-a)^3/3! + ...
    // simple euler turns this into:
    // y(t) = y(a) + y'(a) * (t-a)
    // we can pick t = t+dt and a = t, to get
    // y(t+dt) = y(t) + y'(t) * (t+dt - t)
    // y(t+dt) = y(t) + y'(t) * dt
    float newT = t + dt;
    float newY = y + dy(y, t) * dt;
    return new Record(newT, newY);
  }
  
  Record stepSuvat(float dt) {
    // take into account the second order term y''(t).
    // get y''(t) by numerical differentiation of y'(t).
    float acc = (dy(y, t + dt/2) - dy(y, t - dt/2)) / (dt);
    float newT = t + dt;
    float newY = y + dy(y, t) * dt + acc * dt * dt / 2;
    
    //float contribDy = dy(y, t) * dt;
    //float contribAcc = acc * dt * dt / 2;
    //println(contribDy / contribAcc);
    
    // this is totally useless, it's basically exactly the same as euler.
    // this is because the first order term dominates the second order term, so the 
    // acceleration bit does almost nothing.
    return new Record(newT, newY);
  }

  // also called Heun's method
  Record stepImprovedEuler(float dt) {
    // the idea with improved Euler is to take into account the second order term - the y''(a) portion. How do we do this?
    // 1) explicitly write a function for y''(a) (with respect to dt)
    // 2) approximate y''(a) based off of y'(a)
    // ok - how do we approximate y''(a)
    // well, we have numerical differentiation:
    // x'(t) = (x(t+h) - x(t-h)) / (2h)
    // this is actually a special case of the taylor series expansion yet again
    // ok - starting from basics:
    // y'(t) = y'(a) + y''(a)*(t-a) + ...
    // if we set a = t+dt
    // y'(t) = y'(t+dt) + y''(t+dt) * (t-(t+dt))
    // y'(t) - y'(t+dt) = y''(t+dt) * -dt
    // y''(t+dt) = (y'(t+dt) - y'(t)) / dt
    // this is forward differentation
    // this isn't quite what we want though - we want y''(t), not y''(t+dt)
    // y'(t+dt) = y'(t) + y''(t)*((t+dt) - t)
    // y'(t+dt) - y'(t) = y''(t)*dt
    // y''(t) = (y'(t+dt) - y'(t)) / dt
    // ok, this is pretty good. so plugging this back into the original y(t) expansion:
    // y(t) = y(a) + y'(a)*(t-a) + y''(a)*(t-a)^2/2!
    // WHERE: t = t+dt
    // a = t
    // y(t+dt) = y(t) + y'(t)*(t+dt-t) + y''(t)*(t+dt-t)^2 / 2
    // y(t+dt) = y(t) + y'(t)dt + (y'(t+dt) - y'(t)) / dt * dt^2 / 2
    // y(t+dt) = y(t) + y'(t)dt + (y'(t+dt) - y'(t))dt / 2
    // y(t+dt) = y(t) + y'(t)dt + y'(t+dt)dt/2 - y'(t)dt/2
    // y(t+dt) = y(t) + y'(t)dt/2 + y'(t+dt)dt/2
    // y(t+dt) = y(t) + (y'(t) + y'(t+dt)) / 2 * dt
    // is this improved euler? instead of using only y'(t), we average y'(t) and y'(t+dt)?
    // mm, i fucked this up kinda. ok well lets try it
    
    float newT = t + dt;
    // i'm so close. the only problem is that I'm still using y in the second dy, rather than a first-level approximation.
    // how do they get there?
    //float newY = y + (dy(y, t) + dy(y, newT)) / 2 * dt;
    
    // lets try this one more time. We want to find y(t). We have y(0).
    // we have y'(t), but simple integration does not work on it, since y' is a function of y:
    // y'(t, y(t)) = <something>
    // but with Taylor series expansion we can find y(t):
    // y(t) = y(a) + y'(a, y(a))*(t-a) + y''(a, y(a))*(t-a)^2/2! + ...
    // plugging in: t = t+dt
    // a = t
    // y(t+dt) = y(t) + y'(t, y(t))*dt + y''(t, y(t))*dt^2 / 2
    // the things we have:
    // t
    // dt
    // y(t)
    // y'(t, y(t))
    
    // the things we're missing:
    // y''(t, y(t))
    
    // how do we get y''(t, y(t))?
    // well, we can derive y'(t, y(t)).
    // how do we derive y'(t, y(t))?
    // 1) finite difference formula: y''(t, y(t)) = (y'(t+h, y(t+h)) - y'(t, y(t))) / h
    //   aside: this itself comes from Taylor expansion: y'(t+h, y(t+h)) = y'(t, y(t)) + y''(t, y(t))*h + ... (ignoring the rest)
    
    // ok, so the things we have:
    // t
    // y'(t, y(t))
    
    // free floaters
    // h - we can set h to anything
    
    // the things we're missing:
    // y(t+h), which blocks y'(t+h, y(t+h))
    
    // wait wait, this is interesting - if we set h to dt, then y(t+h) becomes y(t+dt), which is the thing we're trying to solve
    // in the first place! what happens then? Can we algebra it all onto one side?
    
    // set h = dt
    // y''(t, y(t)) = (y'(t+dt, y(t+dt)) - y'(t, y(t))) / dt
    // oh nope, that doesn't work because the y(t+dt) is just notated inside the computation for y'(t+dt, y(t+dt)).
    // it's just a notation saying "we need the slope in the future, but part of getting that slope is having the 
    // point, which is exactly the thing we're trying to solve". Chicken and egg problem.
    // ok, so, we're kinda stuck at this point. But we're humans and we try to be resourceful, so we say
    // "fuck it, lets just throw *something* into y(t+dt) at that point."
    // Even though the final goal is to find y(t+dt) in the first place, we have all this other equational machinery
    // whose purpose is to provide an accurate approximation of y(t+dt).
    // I mean in a perfect world we could iterate this infinite times to converge onto the perfect true number.
    // But we don't, so we just need to find some sort of "seed" bootstrap number for y(t+dt).
    // Hey wait - we already have a shitty way to calculate y(t+dt)! It's just the first order Euler method, the one
    // that goes crazy after a while when you do it 100 times and the errors compound.
    // but just using it once, right now, as a starting point, is probably a decent approximation. Ok, lets try it.
    // the equation, again, is y(t+dt) = y(t) + y'(t, y(t)) * dt
    // we have all this. This unlocks y(t+dt) in y'(t+dt, y(t+dt)):
    // y'(t+dt, y(t+dt)) ~= y'(t+dt, y(t) + y'(t, y(t)) * dt) . Plugging this back into the y'' equation:
    // y''(t, y(t)) ~= (y'(t+dt, y(t) + y'(t, y(t)) * dt) - y'(t, y(t))) / dt
    // now we have everything. We can plug this back into the original y(t+dt) equation:
    // y(t+dt) = y(t) + y'(t, y(t))*dt + y''(t, y(t))*dt^2 / 2
    // y(t+dt) = y(t) + y'(t, y(t))*dt + (y'(t+dt, y(t) + y'(t, y(t)) * dt) - y'(t, y(t))) / dt * dt^2 / 2
    // I'm just gonna use the variable E = y(t) + y'(t, y(t)) * dt to make it look a bit better
    // y(t+dt) = y(t) + y'(t, y(t)) * dt + (y'(t+dt, E) - y'(t, y(t))) * dt / 2
    // y(t+dt) = y(t) + y'(t, y(t)) * dt / 2 + y'(t+dt, E) * dt / 2
    // y(t+dt) = y(t) + (y'(t, y(t)) + y'(t+dt, E)) / 2 * dt
    // there it is!    
    
    // this is the proper way to do it. It's... pretty good!
    float newY0 = y + dy(y, t) * dt;
    float newY = y + (dy(y, t) + dy(newY0, newT)) / 2 * dt;
    return new Record(newT, newY);
  }
  
  Record stepVerlet(float dt) {
    // ok, how is verlet supposed to work?
    // well, what even are other ways to integrate?
    // we're still trying to find y(t+dt). We have: y(t), y(t-dt). y'(t, y(t)). y'(t-dt, y(t-dt)).
    // Again, this is all based on taylor series:
    // y(t+dt) = y(t) + y'(t)*dt + y''(t)*dt^2 / 2 + y'''(t)*dt^3 / 6 + ...
    
    // so, the general strategy with Heun is a two-step approximation:
    // first, approximate the future position with Euler.
    // Use that approximate future position to get a future slope.
    // Average the future slope and the current slope for a better slope estimate.
    // move forward linearly with that slope estimate.
    
    // what are other ways we could conceivably estimate y(t+dt)?
    // 1. instead of using a linear add, use a polynomial curve. Wait, is this what suvat does already?
    // 2. sample the slope at the midpoint and use that slope. Eh, this is basically Heun's but in the middle (midpoint method).
    // 3. Take advantage of history. Well, we have the previous point, which tells us the previous slope.
    // we can use the previous slope to inform our current slope. 
    // ok - so. backing up a second. There exists, the "perfect" slope, that will get you directly onto the
    // curve in the future. We do all this work to find that slope number. The thing about history is that
    // we "have" the perfect slope of the last frame. Actually that's not really true, that last number is just
    // an imperfect approximation using whatever algorithm we're using.
    // ok whatever. lets look it up.
    
    // ah ok. So verlet is pretty simple, but it requires the concept of acceleration (2nd derivative).
    // It uses the second order central finite difference:
    // y''(t) = (y(t+dt) - 2y(t) + y(t-dt)) / dt^2
    // this again starts from the central difference formula, which itself stems from the taylor expansion.
    // ok, so, Taylor expansion: y(t+dt) = y(t) + y'(t)*dt + y''(t)*dt^2 / 2! + y'''(t)*dt^3 / 3! + ...
    // right now we're still in "perfect" land - exactly 0 error.
    // we want a reasonable approximation for y'. 
    // One way - just "ignore" everything in y'' and above, relegate it to a "small number that we don't care about" S(t, dt).
    // y(t+dt) = y(t) + y'(t)*dt + S(t, dt)
    // ok, there's an entirely different field on handling errors, but basically there's a special notation O() that denotes
    // how much error we're getting. We're going to give S that treatment and turn it into an O(dt). We're also going to take
    // it out of the equation and just kind of implicitly know "hey, there's this error term, just, take note of it"
    // and therefore we get this:
    // y(t+dt) = y(t) + y'(t)*dt
    // solving for y'(t): y'(t) = (y(t+dt) - y(t)) / dt, with error O(dt).
    // So that's pretty basic, called the forward difference.
    // The central difference is a cool trick you can do that gives less error. We start with:
    // y(t+dt) = y(t) + y'(t)*dt + y''(t)*dt^2 / 2! + y'''(t)*dt^3 / 3! + ...
    // y(t-dt) = y(t) - y'(t)*dt + y''(t)*dt^2 / 2! - y'''(t)*dt^3 / 3! + ...
    // then we subtract them:
    // y(t+dt) - y(t-dt) = 2y'(t)*dt + 2y'''(t)*dt^3 / 3! + ...
    // something magical happens: y(t), y''(t), etc. all disappear! Remember we're still in perfect land, but we've just
    // gotten rid of a whole ton of terms to worry about. That's pretty amazing.
    // so now we again we relegate everything in dt^3 and above to a random S(t, dt) function. But critically, this S(t, dt)'s
    // biggest term is dt^3, which means the error is only O(dt^2).
    // So now solving for y'(t), we have:
    // y'(t) = (y(t+dt) - y(t-dt)) / (2dt), with error O(dt^2). 
    // i mean, this is clearly superior.
    
    // ok, so we can do it again for the second order:
    // y''(t) = (y'(t+dt/2) - y'(t-dt/2)) / dt
    // y'(t+dt/2) = (y(t+dt) - y) / dt
    // y'(t-dt/2) = (y(t) - y(t-dt)) / dt
    // y''(t) = ((y(t+dt) - y(t)) / dt - (y(t) - y(t-dt)) / dt) / dt
    // y''(t) = y(t+dt) - 2y(t) + y(t-dt) / dt^2
    // solving for y(t+dt) = y''(t)*dt^2 + 2y(t) - y(t-dt)
    
    float newT = t+dt;
    Record r = null;
    if (prevY == Float.NEGATIVE_INFINITY) {
      // only on the first step, use another method
      r = this.stepImprovedEuler(dt);
    } else {
      float newY = ddy(t, y)*dt*dt + 2*y - prevY;
      r = new Record(newT, newY);
    }
    r.prevY = this.y;
    return r;
  }
  
  Record stepCentralDifference(float dt) {
    // Can we use the central difference idea to find y(t+dt)?
    // We already have y(t-dt), and we have y(t).
    // y(t+dt) = y(t-dt) + 2y'(t)*dt;
    // uh no that's total shit. That's basically just using a 2x timestep lol.
    
    // y(t+dt/2) = y(t-dt/2) + y'(t)*dt
    // hmm, we could do this, which looks interesting. yeah, if we shift t by dt/2:
    // y(t+dt) = y(t) + y'(t+dt/2, y(t+dt/2))*dt
    // this is the fucking midpoint method lmao
    
    // oh this is interesting. We don't have y(t+dt/2)... but we did with the original one:
    // y(t+dt/2) = y(t-dt/2) + y'(t)*dt
    // so, if we keep track of the velocities and positions in between every time step, we get
    // a more accurate reading. This is not exactly "just euler's with half the time step", since
    // you use the "half-step" y's to compute the on-step one (but not the other way around).
    // actually that might be worse than "just euler's with half the time step" since the half-step computations
    // are just accumulating normal euler's errors. 
    // this is not leapfrog integration. Leapfrog integration also takes into account accelerations. But it's kinda
    // this idea.
    float newT = t + dt;
    float prevT = t - dt;
   //float newY = 
   return null;
  }

  float pixelX() {
    return map(t, 0, 100, 0, width);
  }

  float pixelY() {
    return map(y, -0.2, 2, height, 0);
  }

  void putVertex() {
    vertex(pixelX(), pixelY());
  }
}


float exactY(float t, float y0) {
  // the exact solution is y(t) = e^(3.5*sin(t)) / ( C + e^(3.5*sin(t)) (wolfram-alpha'ed)

  // first find C with y0
  // e^(3.5*sin(0)) = e^(3.5*0) = 1, which implies y0 = 1 / (1 + C)
  // C = 1 / y0 - 1
  float C = 1 / y0 - 1;

  // now, use that for y(t)
  return exp(3.5 * sin(t)) / (C + exp(3.5 * sin(t)));
}

float dy(float y, float t) {
  // return sin(y - t) - y;
  return 3.5 * y * (1 - y) * cos(t);
}

// d^2y/dt^2
float ddy(float y, float t) {
  return 3.5 * (1 - 2 * y) * cos(t);
}

void setup() {
  size(800, 600, P2D);
  smooth(8);
}

void draw() {
  background(255);
  strokeWeight(2);
  noFill();
  colorMode(HSB);
  drawExact();
  drawEuler();
  drawSuvat();
  drawImprovedEuler();
  drawVerlet();
}

void drawExact() {
  Record r = new Record(0, y0);
  // exact
  stroke(0, 128);
  beginShape();
  while (r.pixelX() < width) {
    r.putVertex();
    r = r.stepExact(dt);
  }
  r.putVertex();
  endShape();
}

void drawEuler() {
  Record r = new Record(0, y0);
  stroke(140, 255, 255, 128);
  beginShape();
  while (r.pixelX() < width) {
    r.putVertex();
    r = r.stepEuler(dt); // this loses energy! but this system is not supposed to!!!!
  }
  r.putVertex();
  endShape();
}

void drawImprovedEuler() {
  Record r = new Record(0, y0);
  stroke(180, 255, 255, 128);
  beginShape();
  while (r.pixelX() < width) {
    r.putVertex();
    r = r.stepImprovedEuler(dt); // this loses energy! but this system is not supposed to!!!!
  }
  r.putVertex();
  endShape();
}

void drawSuvat() {
  Record r = new Record(0, y0);
  stroke(210, 255, 255, 128);
  beginShape();
  while (r.pixelX() < width) {
    r.putVertex();
    r = r.stepSuvat(dt); // this loses energy! but this system is not supposed to!!!!
  }
  r.putVertex();
  endShape();
}

void drawVerlet() {
  Record r = new Record(0, y0);
  stroke(255, 255, 255, 128);
  beginShape();
  while (r.pixelX() < width) {
    r.putVertex();
    r = r.stepVerlet(dt); // this loses energy! but this system is not supposed to!!!!
  }
  r.putVertex();
  endShape();
}