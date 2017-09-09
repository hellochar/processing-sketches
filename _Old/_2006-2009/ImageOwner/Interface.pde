abstract class Interface {

  private float x, y/*, theta*/;

  protected Interface() {
    setValues(0, 0);
  }

  void setValues(float x, float y/*, float theta*/) {
    this.x = x;
    this.y = y;
    //    this.theta = theta;    
  }

  final void show() {
    gui.pushMatrix();
    gui.translate(x, y);
    //    g.rotate(theta);
    draw();
    gui.popMatrix();
    gui.endDraw();
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y + guiHOffset;
  }

  abstract void draw();
  abstract boolean mouseOver();
}

class CircleInterface extends Interface {
  float size;

  CircleInterface(float size) {
    super();
    this.size = size;
  }

  void draw() {
    gui.stroke(color(255));
    gui.fill(color(mouseOver() ? 128 : 0));
    gui.ellipse(0, 0, size, size);
  }

  boolean mouseOver() {
    return dist(mouseX, mouseY, getX(), getY()) < size / 2.0;
  }
}

class RectInterface extends Interface {
  float w, l;

  RectInterface(float w, float l) {
    super();
    this.w = w;
    this.l = l;
  }

  void draw() {
    gui.stroke(color(255));
    gui.fill(color(mouseOver() ? 128 : 0));
    gui.rect(-w/2, -l/2, w, l);
  }

  boolean mouseOver() {
    return abs(mouseX - getX()) < w/2 & abs(mouseY - getY()) < l / 2;
  }
}
