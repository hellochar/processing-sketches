final CircleInterface FACE_CIRCLE = new CircleInterface(25);
final RectInterface FACE_RECT = new RectInterface(25, 25);
final static int INSET = 1, IMG = 2, OUTSIDE = 3;

void initFinals() {
  circles = new PenButton(25, 25, gui, FACE_CIRCLE, new DrawPen(true) {
    void draw(int x, int y, int px, int py) {
      float size = random(12, 50);
      cgi.stroke(color(255, random(64, 196)));
      cgi.strokeWeight(random(1, 6));
      cgi.noFill();
      cgi.ellipse(0, 0, size, size);
    }
  }
  );
  rects = new PenButton(50+10, 25, gui, FACE_RECT, new DrawPen(true) {
    void draw(int x, int y, int px, int py) {
      float size = random(6, 22);
      cgi.fill(color(255, random(64, 196)));
      cgi.noStroke();
      cgi.rotate(random(0, HALF_PI));
      cgi.rect(-size/2, -size/2, size, size);
    }
  }
  );
  
  lines = new PenButton(60+27.5+10, 25, gui, new RectInterface(30, 6), new DrawPen(false) {
    void draw(int x, int y, int px, int py) {
      cgi.stroke(color(255));
      cgi.line(x, y, px, py);
    }
  });

}//end of initFinals
