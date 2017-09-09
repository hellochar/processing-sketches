
abstract class Pen {
  
  abstract void function(int mx, int my, int pmx, int pmy);
}

abstract class DrawPen extends Pen {
  
  boolean translate;
  
  DrawPen(boolean t) {
    translate = t;
  }
  
  final void function(int x, int y, int px, int py) {
    cgi.beginDraw();
    cgi.pushMatrix();
    if(translate)
      cgi.translate(x, y);
    draw(x, y, px, py);
    cgi.popMatrix();
    cgi.endDraw();
  }
  
  abstract void draw(int x, int y, int px, int py);
}
