PImage img, copy;

public void setup() {
  img = loadImage("xzhang0000.png");
  size(img.width, img.height);
  copy = createImage(width, height, ARGB);
  img.loadPixels(); copy.loadPixels();
  for(int i = 0; i < img.pixels.length; i++) {
//    if(colorDistance(color(255), img.pixels[i]) < 1) {
////    if(brightness(img.pixels[i]) > 200) {
//      copy.pixels[i] = color(255, 0);
//    }
//    else copy.pixels[i] = img.pixels[i];
    copy.pixels[i] = color(0, 255 - brightness(img.pixels[i]));
  }
  copy.updatePixels();
  img.updatePixels();
  copy.save("xzhang0000-with-alpha.png");
}


public float colorDistance(int target, int arg) {
  return PApplet.dist(0, 0, 0, red(target) - red(arg), green(target)-green(arg), blue(target)-blue(arg));
}

public void draw() {
  background(frameCount % 255);
  image(copy, 0, 0);
//  println(colorDistance(color(255), copy.get(mouseX, mouseY)));
  println(frameCount % 255);
}
