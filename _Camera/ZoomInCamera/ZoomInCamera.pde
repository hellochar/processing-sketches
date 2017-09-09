import JMyron.*;

JMyron my;//a camera object

PImage img2;

void setup(){
  size(640,480);
  img2 = createImage(width, height ,RGB);
  my = new JMyron();//make a new instance of the object
  my.start(width,height);//start a capture at 320x240
  my.adaptivity(25);
  
  my.findGlobs(0);//disable the intelligence to speed up frame rate
//  println("Myron " + m.version()); 
background(0);
}

void draw(){
  my.update();//update the camera view
  int[] img = my.image(); //get the normal image of the camera
  int[] dif = my.differenceImage();
  loadPixels();
  for(int i = 0; i < dif.length; i++) {
    if(brightness(dif[i]) > 10)
      pixels[i] = dif[i];
//    else 
  }
  updatePixels();
  
  img2.copy(g, 0, 0, width, height, 0, 0, width, height);
  float inset = 10;
  image(img2, -inset, -inset, width+inset*2, height+inset*2);
}

public void stop(){
  my.stop();//stop the object
  super.stop();
}
