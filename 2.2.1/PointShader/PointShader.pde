PShader pointShader;

void setup() {
  size(640, 360, P3D);
  
  pointShader = loadShader("pointFrag.glsl");
  
  stroke(255);
  strokeWeight(50);
  
  background(0);
}

void draw() {
  stroke(color(random(255)));
  fill(color(random(255), 0, 0));
  shader(pointShader, POINTS);
  if (mousePressed) {   
    point(mouseX, mouseY);
  }  
}

