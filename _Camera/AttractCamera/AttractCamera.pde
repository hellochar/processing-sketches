import zhang.*;

import JMyron.*;

JMyron my;//a camera object

Grid g;
 
void setup(){
  size(640, 480);
  my = new JMyron();//make a new instance of the object
  my.start(width,height);//start capture
  my.adaptivity(10);
  
  my.findGlobs(0);//disable the intelligence to speed up frame rate
  
  g = new UniformGrid(width, height);
  for(int i = 0; i < 200; i++) {
    g.pollAdd(new Particle(random(width), random(height)));
  }
//  println(g.getAllEntities().size());
//  println("Myron " + m.version()); 
}

void draw(){
  my.update();//update the camera view
  int[] img = my.image(); //get the normal image of the camera
//  int[] dif = my.differenceImage();
  loadPixels();
  arraycopy(img, pixels);
  updatePixels();
  println(frameRate);
  g.step();
  g.show();
}

public void stop(){
  my.stop();//stop the object
  super.stop();
}
