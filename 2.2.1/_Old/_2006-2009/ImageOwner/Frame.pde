class Frame {
  PGraphics window;
  boolean isDrawing = false;
  PImage img;
  int x, y, 
  insetX, insetY, insetColor;
  final int width, height;
  
  public Frame(int x, int y, int w, int h, int ix, int iy, PImage v) {
    this.x = x;
    this.y = y;
    insetX = ix;
    insetY = iy;
    window = createGraphics(w, h, P2D);
    width = w;
    height = h;
    img = v;
    window.beginDraw();
    window.noStroke();
    window.background(color(255));
    window.endDraw();
  }
  
  /*
  public void beginDraw() {
    if(isDrawing)
      return;
    isDrawing = true;
    img.beginDraw();
  }
  
  public void endDraw() {
    if(!isDrawing)
      return;
    isDrawing = false;
    img.endDraw();
  }
  */
  
  int liesOn(int tx, int ty) {
    if(tx < x | tx > x + width | ty < y | ty > y + height)
      return OUTSIDE;
    tx -= x;
    ty -= y;
    if(tx < insetX | width - tx < insetX | ty < insetY | height - ty < insetY)
      return INSET;
    return IMG;
  }
  
  void setInsetColor(int c) {
    insetColor = c;
  }
  
  public void update() {
    window.beginDraw();
    window.fill(insetColor);
    window.rectMode(CORNER);
    window.rect(0, 0, window.width, window.height);
    window.image(img, insetX, insetY);
    if(img.height > window.height - insetY) {
     
      window.rectMode(CORNERS); 
      window.rect(0, window.height - insetY, window.width, window.height);
    }
    if(img.width > window.width - insetX) {
      window.rectMode(CORNERS); 
      window.rect(window.width - insetX, 0, window.width, window.height);
    }
    window.endDraw();
  }
  
  public void draw() {
    image(window, x, y);
  }
}
