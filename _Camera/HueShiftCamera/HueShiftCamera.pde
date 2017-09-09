import JMyron.*;

JMyron my;//a camera object
 
void setup(){
  size(640,480);
  my = new JMyron();//make a new instance of the object
  my.start(width,height);//start a capture at 320x240
  my.adaptivity(10);
  
  my.findGlobs(0);//disable the intelligence to speed up frame rate
  my.settings();
//  println("Myron " + m.version()); 
  colorMode(HSB, 1);
}

void draw(){
  my.update();//update the camera view
  int[] img = my.image(); //get the normal image of the camera
  int[] dif = my.differenceImage();
  loadPixels();
  arraycopy(img, pixels);
  for(int i =0 ; i < img.length; i++) {
    int c = lerpColor(img[i], color(map(mouseX, 0, width, 0, 1)%1, 3*saturation(img[i]), brightness(img[i])), map(mouseY, 0, height, 0, 1));
    pixels[i] = c;
  }
  updatePixels();
}

public void stop(){
  my.stop();//stop the object
  super.stop();
}
