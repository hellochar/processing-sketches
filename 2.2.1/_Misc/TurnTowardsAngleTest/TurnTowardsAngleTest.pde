import zhang.*;

float ang = -PI/4;
float wantAng = -PI/2;

PVector avel = new PVector(1, 1);

PVector bvel = new PVector(-1, -1);

void setup() {
  size(200, 200);
}

void draw() {
  background(255);
  if(mousePressed) {
    float angle = atan2(height/2-mouseY, width/2-mouseX)+PI;
    if(mouseButton == LEFT) ang = angle;
    else wantAng = angle;
  }
  stroke(0);
  line(ang);
  
  stroke(255, 0, 0);
  strokeWeight(3);
  line(wantAng);
  
  strokeWeight(1);
  stroke(0, 128);
  line(Methods.turnTowardsAngleAmount(ang, wantAng, 2));
}

void line(float ang) {
  line(width/2, height/2, width/2*(1+cos(ang)), height/2*(1+sin(ang)));
}
