float x, y, vx, vy, ax, ay;

float timeStep = 1;

void setup() {
  size(1000, 600);
  x = width/2; 
  y = height/2; 
  vx = random(-5, 5); 
  vy = random(-5, 5);
  ax = ay = 0;
}

void draw() {
  //  background(128);
  noStroke(); 
  fill(0, 20);
  ellipse(x, y, 10, 10);
  if (mousePressed) {
    //    frameRate(5);
    applyCentripetalForce(); 
    stroke(255); 
    fill(128);
    ellipse(kx, ky, 10, 10);
  } 
  else frameRate(60);
  update();
}

float kx, ky;
void mousePressed() {
  float ang = atan2(vy, vx);
  kx = x + cos(ang+PI/2)*50;
  ky = y + sin(ang+PI/2)*50;
}

void applyCentripetalForce() {
  float ox = kx - x, 
  oy = ky - y;

  float r = sqrt(ox*ox + oy*oy);
  float v = sqrt(vx*vx + vy*vy);

  float theta = atan2(oy, ox);

  float dax = v*v*cos(theta) / r, 
  day = v*v*sin(theta) / r;

  ax += dax;
  ay += day;
}

void update() { 
  stroke(0, 255, 0);
  line(x, y, x+ax*10, y+ay*10);
  vx += ax*timeStep; 
  vy += ay*timeStep; 
  stroke(255, 0, 0);
  line(x, y, x+vx, y+vy);
  x += vx*timeStep; 
  y += vy*timeStep;

  ax = ay = 0;
}

