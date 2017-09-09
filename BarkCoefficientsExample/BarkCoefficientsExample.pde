import oscP5.*;

OscP5 oscP5;

void setup() {
  size(800,500);
  oscP5 = new OscP5(this, 7000);
  colorMode(HSB);
}


void draw() {
  background(0);
  noStroke();
  for ( int i = 0; i < barkCoefficients.length; i++) {
    float bark = barkCoefficients[i];
    float x = map(i, -1, barkCoefficients.length, 0, width); 
    float radius = bark * 100;
    
    fill(38 - bark*bark * 5, bark * 100, 255, 128);
    ellipse(x, height/2, radius, radius);    
  }
}

float[] barkCoefficients = new float[24];

void oscEvent(OscMessage theOscMessage) {
  Object[] args = theOscMessage.arguments();
  for ( int i = 0; i < args.length; i++) {
    barkCoefficients[i] = ((Double)args[i]).floatValue();
  }
}
