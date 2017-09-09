// Based on original code by Jared "BlueThen" C.
// ( http://www.openprocessing.org/visuals/?visualID=5974 )
 
 
class Particle {
 
  float x, y;                   // position in the window
  float vx, vy;                 // speed
  float absScreenX, absScreenY; // absolute position on the screen
   
  // spray a particle inside the shape
  Particle(float _x, float _y) {
    boolean inside = false;
    while(!inside) {
        x = _x + random(-10, +10);
        y = _y + random(-10, +10);
        inside = pointInside(screenX(x,y),screenY(x,y));
    }
    absScreenX = windowX + screenX(x,y);
    absScreenY = windowY + screenY(x,y);
  }
   
  void update(int num) {
     
   // slow down
   vx *= friction;
   vy *= friction;
    
   // walk thru all particles
   for (int i = 0; i < particles.size(); i++)  {
     if (i != num) {
       
        Particle particle = (Particle) particles.get(i);
        float tx = particle.x;
        float ty = particle.y;
        float radius = dist(x,y,tx,ty);
         
        // interact
        if (radius < 35) {
           
           float angle = atan2(y-ty,x-tx);
            
           // attract
           if (radius < 30) {
             vx += (30 - radius) * 0.07 * cos(angle);
             vy += (30 - radius) * 0.07 * sin(angle);
           }
            
           // repell
           if (radius > 25) {
             vx -= (25 - radius) * 0.005 * cos(angle);
             vy -= (25 - radius) * 0.005 * sin(angle);
           }
        }
      }
    }
      
      
    // save previous coordinates
    float px = x;
    float py = y;
    float pabsScreenX = absScreenX;
    float pabsScreenY = absScreenY; 
     
    // move particle
    x += vx;
    y += vy;
     
    // calculate screen coordinates
    float screenX = screenX(x,y);
    float screenY = screenY(x,y);
    absScreenX = windowX + screenX;
    absScreenY = windowY + screenY;
 
    // move freely if the particle is on the inside
    if(pointInside(screenX, screenY)) {
       
      // get absolute movement
      float dx = absScreenX - pabsScreenX;
      float dy = absScreenY - pabsScreenY - (gravity ? 9.81 : 0);
      
      // acceleration
      vx -= (dx * cos(rot) + dy * sin(rot)) * .1;
      vy -= (dx * -sin(rot) + dy * cos(rot)) * .1;
       
    // bounce back if the particle would be outside
    } else {
       
      // restore position
      x = px; y = py;
       
      // invert speed
      vx *= -1; vy *= -1;    
  
    }
    
    // draw particle
    line(px,py,x,y);
  }
   
} 

