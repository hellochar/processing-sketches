/**
 * Loop. 
 * 
 * Move the cursor across the screen to draw. 
 * Shows how to load and play a QuickTime movie file.  
 *
 * Takes in a .mov file and attempts to match it to a library of videos. It will first
 * parse the file into its individual frames, and then decompose the image
 * to change each frame into (4) integers, and match this data profile against a library
 * of indexed frame profiles. Problems: 
 * a) different contrast/brightness/gamma - solution = match algorithm must be scale and translation invariant
 * b) different framerate of copied video vs. original video - solution = match algorithm must translate integer profile to
 *    match based on real time elapsed.
 */

//PGraphics img;
List<PImage> images;

void setup() {
  size(320*2, 240, P2D);
  images = new LinkedList();
  for(int i = 1; i <= 9999; i++) {
    String str = "img"+lpad(""+i, '0', 4)+".jpg";
    if(createInput(str) == null) break;
    images.add(loadImage(str));
    println("loading "+str);
  }
//  outputAsCsv("test1.csv", aggregate(images));
//  size(img.width*2, img.height, P2D);
//  randImg();
  frameRate(30);
}

//void randImg() {
//  img.beginDraw();
//  img.background(0);
//  for(int i = 0; i < 20; i++) {
////    img.fill(color(0, 128, 255));
//    img.fill(color(random(255), random(255), random(255)));
//    img.rect(random(img.width), random(img.height), random(img.width), random(img.height));
//  }
////  img.stroke(255);
////  img.fill(255, 0, 0);
////  img.rect(0, 0, img.width/2, img.height/2);
////  img.fill(0, 255, 0);
////  img.rect(img.width/2, 0, img.width/2, img.height/2);
////  img.fill(0, 0, 255);
////  img.rect(0, img.height/2, img.width/2, img.height/2);
////  img.fill(255, 255, 0);
////  img.rect( img.width/2, img.height/2,  img.width/2, img.height/2);
//  img.endDraw();
//}

void draw() {
//  background(color(frameCount%255, 0, 0));
  int index = frameCount%images.size();
  PImage img = images.get(index);
  image(img, 0, 0);
  if(img.width > 1) {
  int[] vals = decompose(img);
  pushMatrix();
  translate(img.width, 0);
  displayDecomp(vals, img.width, img.height);
  popMatrix();
  line(width/4, 0, width/4, height);
  line(0, height/2, width/2, height/2);
//  println("--- End frame ---");
  }
  println(frameRate);
}
