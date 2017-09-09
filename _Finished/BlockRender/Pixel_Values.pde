abstract class PV {
  abstract int pixelValue(int x, int y, float mx, float my);
  
  void mousePressed() {}
  void keyPressed() {}
}
PV shadows = new PV() {

public static final int COLOR_ZERO = 0xFF1CD6E5, //28, 214, 229
                        COLOR_ONE = 0xFF0B5E64; //11, 94, 100
                        
  int pixelValue(int x, int y, float mx, float my) { //should return a color
    float dx = x - mx,
          dy = y - my;
    float weightP = 1, weightMe = 20;
    float midX = (mouseX * weightP + mx * weightMe) / (weightP+weightMe),
          midY = (mouseY * weightP + my * weightMe) / (weightP+weightMe);
    float ox = midX - x,
          oy = midY - y,
          d2 = ox*ox+oy*oy;
    float value = 1/(1+d2*d2 / pow(10, 4)) * (dx*dx+dy*dy) / (CELL_SIZE*CELL_SIZE/4); //1/(1+d^4) * distance from center, returns a value from 0 to 1
    return lerpColor(COLOR_ZERO, COLOR_ONE, value);
  }
};

PV newPV = new PV() {
  
  float scalar = 1;
  
  void keyPressed() {
    if(keyCode == LEFT) scalar *= .8f;
    else if(keyCode == RIGHT) scalar /= .8f;
  }
  
  int pixelValue(int x, int y, float mx, float my) { //should return a value from 0 to 1.
    float dx = x - mx,
          dy = y - my;
    
    float weightP = 1, weightMe = 5;
    float midX = (mouseX * weightP + mx * weightMe) / (weightP+weightMe),
          midY = (mouseY * weightP + my * weightMe) / (weightP+weightMe);
    float ox = midX - x,
          oy = midY - y,
          d2 = ox*ox+oy*oy;
    
    float value = (d2);
    
    return color(value*scalar);
  }
  
};
