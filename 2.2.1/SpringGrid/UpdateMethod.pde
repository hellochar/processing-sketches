abstract class UpdateMethod {
  
  abstract void update(Cell c);
  
}

public final UpdateMethod eulers = new UpdateMethod() {
  void update(Cell c) {
    //First implementation - forward Euler integration. a(t) = f(t, v(t)); in this case, a(t) = acceleration at time t, which is a function of time and the velocity. The function
    //in this case is just velocity is acceleration times time; v(t) = a(t) * t.
    //y_t+dt = y_t + dt*f(t, y_t).
//      vel = vel + timeStep*acc;
    
    //Perform the same thing to the position.
      c.pos += c.owner.timeStep*c.vel;
  }
};

public final UpdateMethod midpoint = new UpdateMethod() { //todo: FIX THIS
  void update(Cell c) {
    //midpoint method goes like this:
    //x(n+1) = x(n) + h*v(t_n+h/2, y_n+h/2*v(t_n, y_n)).
    //http://mymathlib.webtrellis.net/diffeq/midpoint_method.html
    //For the midpoint method the derivative of y(x) is approximated by the symmetric difference 
    //y'(x) = ( y(x+h) - y(x-h) ) / 2h
    float posGuess = c.pos + c.owner.timeStep * c.vel;
    float velGuess = (posGuess - c.lastPos) / (2 * c.owner.timeStep);
    c.pos = c.lastPos + c.owner.timeStep * velGuess;
  }
};
