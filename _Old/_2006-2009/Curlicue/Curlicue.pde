import zhang.Camera;

double s;
double ang = 0;
float len = 3;


double n = 3;

Camera c;

void setup() {
  size(1280, 800, P2D);
  c = new Camera(this);
  c.registerScrollWheel(1.05);
  textFont(createFont("Arial", 12));
  textAlign(LEFT, TOP);
}

void keyPressed() {
  if(key == 'r') {
    n -= .0000001;
  }
  else if(key == 't') {
    n += .0000001;
  }
}

void render() {
  translate(width/2, height/2);
  s = Math.sqrt(n);
  ang = 0;
  for(int k = 0; k < 10000; k++) {
    iterate();
  }
}

void draw() {
  background(255, 100);
  fill(0);
  text(String.valueOf(n), 0, 0);
//  c.scroll(15);
//  c.apply();
  render();
  println(frameRate);
}

void iterate() {
  line(0, 0, len, 0);
  translate(len, 0);
  double newAng = (ang + 2 * PI * s) % (TWO_PI);
  rotate((float)newAng);
  ang = newAng;
}
