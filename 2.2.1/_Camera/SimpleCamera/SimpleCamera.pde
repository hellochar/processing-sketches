import JMyron.*;

JMyron my;//a camera object

void setup(){
  size(320,240);
  my = new JMyron();//make a new instance of the object
  my.start(width,height);//start a capture at 320x240
  my.adaptivity(10);
  
  my.findGlobs(0);//disable the intelligence to speed up frame rate
//  println("Myron " + m.version()); 
}

void draw(){
  my.update();//update the camera view
  int[] img = my.image(); //get the normal image of the camera
  int[] dif = my.differenceImage();
  loadPixels();
  arraycopy(img, pixels);
  updatePixels();
}

public void stop(){
  my.stop();//stop the object
  super.stop();
}
