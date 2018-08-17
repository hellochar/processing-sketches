PShader rays;

void setup() {
  size(1280, 800, P3D);
  smooth(8);
  rays = loadShader("rays.glsl");
}

void draw() {
  background(6, 6, 7);
  rectMode(CENTER);
  PVector p = new PVector(-(mouseX - width/2), -(mouseY - height/2), (width + height) / 2);
  p.setMag(width / 2);
  camera(p.x, p.y, p.z, 0, 0, 0, 0, 1, 0);
  stroke(255, 0, 0);
  line(0, 0, 0, 100, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 100, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 100);
  
  fill(0);
  stroke(255);
  strokeWeight(2);
  rect(0, 0, 100, 100, 7);
  rays.set("time", millis() / 1000f);
  filter(rays);
}