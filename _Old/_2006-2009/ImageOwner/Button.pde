abstract class Button {
  float x, y;
  PGraphics owner;
  Interface face;

  Button(float x, float y, PGraphics owner, Interface face) {
    this.x = x;
    this.y = y;
    this.owner = owner;
    face.setValues(x, y);
    this.face = face;
    allButtons = (Button[])append(allButtons, this);
  }

  /*
  void setRotation(float r) {
   face.theta = r;
   }
   
   float getRotation() {
   return face.theta;
   }*/

  abstract void action();

  void run() {
    if(face.mouseOver())
      action();
    face.show();
  }

}

class PenButton extends Button {
  Pen p;

  PenButton(float x, float y, PGraphics owner, Interface face, Pen p) {
    super(x, y, owner, face);
    this.p = p;
  }

  void action() {
    curPen = p;
  }
}
