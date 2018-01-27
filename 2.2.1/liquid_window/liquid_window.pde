  /////////////////////////////////////
  //                                 //
  //  ///////     liquid window      //                         
  //  //                             //
  //  /////////////////////////////////
  //
  /////////// (c) Martin Schneider 2009
   
  // http://www.k2g2.org/blog:bit.craft
 
 
  // This sketch demonstrates how you can create shaped windows
  // and make them reactive ....
   
  // You can only observe the shaped window effect if you
  // run the sketch on your local machine.
   
  // It will not work as an online applet!
   
   
  // Mouse Map
   
  // left button   : create liquid particles
  // middle button : drag and shake the window
  // right button  : rotate the window
    
  // Press any key to toggle gravity.
 
 
 
///// shaped window /////
float rot;                      // window rotation in radians
float[] polyX, polyY;           // polygon points for window shape
float modelMouseX, modelMouseY; // mouse position in model coordinates
float hiliting;                 // window hilighting value
float strokeWeight = 3;
 
///// fluid simulation /////
boolean gravity = true;
ArrayList particles = new ArrayList();;
float friction = .8;
   
   
void setup() {
   
  size(500, 500);
 
  // number of window corners
  int n = 120;   
 
  // supershape parameters
  float a = 1, b = 1, m = 5, n1 = 2.5, n2 = 7, n3 = 7;
 
  // calculate shape coords 
  polyX = new float[n];
  polyY = new float[n];
  for(int i=0; i<n; i++) {
    float phi = map(i, 0, n-1, 0, TWO_PI);
    float r =  pow(pow(abs(cos(m * phi / 4) / a), n2) + pow(abs(sin(m * phi / 4) / b),n3), - 1/n1);
    polyX[i] = width/2 * ( 1 + .4 * r * sin(phi));
    polyY[i] = width/2 * ( 1 + .4 * r * cos(phi));
   
  }
   
  // use polygon to shape the window
  setWindowShape(polyX, polyY);
   
  smooth();
 
}
 
 
void draw() {
  
  updateScreenInfo();
   
  // color scheme
  float hilite = (mouseInside() || mousePressed) ? 1 : 0;
  hiliting = lerp(hiliting, hilite, .1);
  stroke(lerpColor(#666666, #666699, hiliting));
  fill(lerpColor(#cccccc, #ccccff, hiliting));
   
  // rotation around the center
  translate(width/2, height/2);
  rotate(rot);
  translate(-width/2,-height/2);
   
  // draw window shape
  shapeWindow(polyX, polyY);
   
  // draw particles
  strokeWeight(strokeWeight);
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle particle = (Particle) particles.get(i);
    particle.update(i);
  }
   
  // save mouse position in model space
  modelMouseX = modelX(mouseX, mouseY);
  modelMouseY = modelY(mouseX, mouseY);
   
  // add new particles
  if(pointInside(mouseX, mouseY) && mousePressed && mouseButton == LEFT)
    particles.add(new Particle(modelMouseX, modelMouseY));
 
}
 
 
void mouseDragged() {
  if(mouseButton == CENTER) {
    dragWindow();
  }
  if(mouseButton == RIGHT) {
    // rotate angle around the center of the window
    rot += atan2(pmouseX - width/2, pmouseY - height/2) - atan2(mouseX - width/2, mouseY - height/2);
  }
}
 
 
void shapeWindow(float[] x, float[] y) {
   
  if(online) {
    // clean the screen if online
    background(255);
    strokeWeight(strokeWeight);
  } else {
    // double the stroke since half of it is going to be clipped
    strokeWeight(2*strokeWeight);
  }
   
  // draw outline polygon
  strokeJoin(ROUND);
  beginShape();
    for(int i=0; i< x.length; i++) vertex(x[i], y[i]);
  endShape();
     
  // cut the window
  setWindowShape(x, y);
   
}
 
 
// toggle gravity
void keyPressed() {
    gravity = !gravity;
}
