PGraphics img, imgRect;
PImage wholeNote, quarterNote, gClef;
float tabWidth;

void setup() {
  size(700, 700);
  wholeNote = loadMaskedImage("Whole Note.png", color(255));
  quarterNote = loadMaskedImage("Quarter Note.PNG", color(255));
  gClef = loadMaskedImage("G-Clef.PNG", color(255));
  img = createGraphics(600, 800, JAVA2D);
  imgRect = createGraphics(width - 100, height - 100, JAVA2D);
  tabWidth = 6;
  clearSheet();
  drawStaff(20, 20);
}

PImage loadMaskedImage(String name, int bgColor) {
  PImage img = loadImage(name);
  PImage mask = createImage(img.width, img.height, ALPHA);
  for(int a = 0; a < img.pixels.length; a++) {
    if(img.pixels[a] == bgColor)
      mask.pixels[a] = 0;
    else
      mask.pixels[a] = 255;
  }
  img.mask(mask);
  return img;
}

PImage resizeProportional(PImage which, int newVal, String dir) {
  int scalar = dir.equals("VERTICAL") ? which.height : which.width;
  float ratio = (float)newVal / scalar;
  PImage newImg;
  if(dir.equals("VERTICAL")) {
    newImg = createImage((int) (which.width * ratio), newVal, RGB);
  }
  else {
    newImg = createImage(newVal, (int) (which.height * ratio), RGB);
  }
  newImg.copy(which, 0, 0, which.width, which.height, 0, 0, newImg.width, newImg.height);
  return newImg;
}

void clearSheet() {
  img.beginDraw();
  img.fill(255);
  img.stroke(color(0));
  img.smooth();
  img.rect(0, 0, img.width-1, img.height-1);
  img.endDraw();
}

//draws the first line at the y exactly
void drawStaff(int y, int inset) {
  img.beginDraw();
  img.smooth();
  img.image(gClef, inset + 10, y - 5);
  img.stroke(color(0));
  for(int a = 0; a < 5; a ++) {
    img.line(inset, y + a * tabWidth, img.width - inset, y + a * tabWidth);
  }
  img.endDraw();
}

float staffWidth() {
  return tabWidth * 5;
}

void draw() {
  background(204);
  imgRect.beginDraw();
  imgRect.fill(color(255));
  imgRect.rect(0, 0, imgRect.width, imgRect.height);
  imgRect.translate(px, py);
  imgRect.noStroke();
  imgRect.image(img, 0, 0);
  imgRect.endDraw();
  image(imgRect, 100, 100);
}

void mouseMoved() {
  if(mouseX > 100 & mouseY > 100) {
    cursor(MOVE);
  }
  else {
    cursor(ARROW);
  }
}

float px, py;
boolean draggingSheet = false;

void mousePressed() {
  if(mouseX > 100 & mouseY > 100) {
    draggingSheet = true;
  }
}

void mouseReleased() {
  draggingSheet = false;
}

void mouseDragged() {
  if(draggingSheet) {
    px += mouseX-pmouseX;
    py += mouseY-pmouseY;
  }
}
