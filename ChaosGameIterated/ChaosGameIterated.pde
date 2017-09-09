PVector[] attractors;

void setup() {
  size(500, 500);
  attractors = new PVector[] { new PVector(0,0), new PVector(width, 0), new PVector(width * cos(PI/3), width * sin(PI/3)) };
  background(0); 
}

void draw() {
  
  for(int i = 0; i < 10; i++) {
  }
}
