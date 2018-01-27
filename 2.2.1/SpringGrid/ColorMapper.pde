abstract class ColorMapper {
  abstract protected int colorFor(float pos);
  
  int colorFor(Cell c) {
    if(c.fixed) return color(255, 255, 0);
    else return colorFor(c.pos);
  }
}

class TwoColorMapper extends ColorMapper {
  
  int negColor, posColor;
  float edge;
  
  public TwoColorMapper(int neg, int pos, float edge) {
    negColor = neg;
    posColor = pos;
    this.edge = edge;
  }
  
  public TwoColorMapper() {
    this(color(255, 0, 0), color(0, 255, 0), 40);
  }
  
  int colorFor(float pos) {
    if(pos < 0) 
      return lerpColor(negColor, 0xFF << 24, constrain(map(pos, -edge, 0, 0, 1), 0, 1));
      return lerpColor(posColor, 0xFF << 24, constrain(map(pos, edge, 0, 0, 1), 0, 1));
  }
}

class ZeroMapper extends ColorMapper {
  int c;
  float scale;
  
  public ZeroMapper(int c, float s) {
    this.c = c;
    scale = s;
  }
  
  public ZeroMapper() {
    this(color(90, 40, 170), 40);
  }
  
  int colorFor(float pos) {
    return lerpColor(color(0), c, constrain(scale / ( 1 + pos*pos), 0, 1));
  }
}
