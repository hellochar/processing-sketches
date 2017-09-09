abstract class Function {

  int col;

  Function(int c) {
    col = c;
  }

  void setColor(color c) {
    col = c;
  }

  void draw() {
    beginLine();
    render.stroke(col);
    for(float x = xMin; x < xMax; x += xIncr * precision) {
      vertex(x, func(x));
    }
    endLine();
  }

  abstract float func(float x);

}

