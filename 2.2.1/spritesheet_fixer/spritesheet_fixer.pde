void setup() {
  size(1920, 1080, P2D);
  fixImage("roguelikeSheet_transparent");
  fixImage("roguelikeDungeon_transparent");
  fixImage("roguelikeChar_transparent");
}

void fixImage(String name) {
  // load from /data folder
  PImage img = loadImage(name+".png");
  int rows = (img.width + 1) / 17;
  int cols = (img.height + 1) / 17;
  PGraphics newImg = createGraphics(nearestPoT(rows*16), nearestPoT(cols*16), P2D);
  int yOffset = newImg.height - cols*16;
  newImg.noSmooth();
  newImg.beginDraw();
  for(int x = 0; x < rows; x++) {
    for(int y = 0; y < cols; y++) {
      newImg.copy(img, x*17, y*17, 16, 16, x*16, y*16+yOffset, 16, 16);
    }
  }
  newImg.endDraw();
  // save in base directory
  newImg.save(name+".png");
  image(newImg, 0, 0);
}

int nearestPoT(int x) {
  return (int)pow(2, ceil(log(x) / log(2)));
}
