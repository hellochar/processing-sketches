/**
 * Visualize: Superformula
 * from Form+Code in Design, Art, and Architecture 
 * by Casey Reas, Chandler McWilliams, and LUST
 * Princeton Architectural Press, 2010
 * ISBN 9781568989372
 * 
 * This code was written for Processing 1.2+
 * Get Processing at http://www.processing.org/download
 */

float scaler = 200;
int m = 2;
float n1 = 18;
float n2 = 1;
float n3 = 1;

void setup() {
  size(700, 700);
  smooth();
  noFill();
  stroke(255);
}

void draw() {
  n2 = map(mouseX, 0, width, -20, 20);
  n3 = map(mouseY, 0, height, -20, 20);
  background(0);
  
  pushMatrix();
  translate(width/2, height/2);

  float newscaler = scaler;
  for (int s = 16; s > 0; s--) {  
    beginShape();
  
    float mm = m + s;
    float nn1 = n1 + s;
    float nn2 = n2 + s;
    float nn3 = n3 + s;
    newscaler = newscaler * 0.98;
    float sscaler = newscaler;

    PVector[] points = superformula(mm, nn1, nn2, nn3);
    curveVertex(points[points.length-1].x * sscaler, points[points.length-1].y * sscaler);
    for (int i = 0;i < points.length; i++) {
      curveVertex(points[i].x * sscaler, points[i].y * sscaler);
    }
    curveVertex(points[0].x * sscaler, points[0].y * sscaler);
    endShape();
  }
  popMatrix();
}


PVector[] superformula(float m,float n1,float n2,float n3) {
  int numPoints = 360;
  float phi = TWO_PI / numPoints;
  PVector[] points = new PVector[numPoints+1];
  for (int i = 0;i <= numPoints;i++) {
    points[i] = superformulaPoint(m,n1,n2,n3,phi * i);
  }
  return points;
}

PVector superformulaPoint(float m,float n1,float n2,float n3,float phi) {
  float r;
  float t1,t2;
  float a=1,b=1;
  float x = 0;
  float y = 0;

  t1 = cos(m * phi / 4) / a;
  t1 = abs(t1);
  t1 = pow(t1,n2);

  t2 = sin(m * phi / 4) / b;
  t2 = abs(t2);
  t2 = pow(t2,n3);

  r = pow(t1+t2,1/n1);
  if (abs(r) == 0) {
    x = 0;
    y = 0;
  }  
  else {
    r = 1 / r;
    x = r * cos(phi);
    y = r * sin(phi);
  }

  return new PVector(x, y);
}
