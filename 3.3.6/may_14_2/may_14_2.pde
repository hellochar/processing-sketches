void setup() {
  size(800, 600, P3D);
}

void draw() {
  background(0);
  //lights();
  //camera(mouseX - width/2, mouseY - height/2, 100, 0, 0, 0, 0, 1, 0);
  camera(0, 0, 100, 0, 0, 0, 0, 1, 0);
  rectMode(CENTER);
  float dz = frameCount % 100;
  //blendMode(ADD);
  fill(255);
  stroke(0);
  //pointLight(0, 0, 0, 255, 255, 255);
  //directionalLight(-1, 1, 1, 128, 128, 128);
  //ambientLight(32, 32, 34);
  //translate(0, 0, 1000);
  translate(0, 0, dz);
  for (float s = 1; s <= 1; s++) {
    for (int z = 0; z > -2000; z += -100) {
      for (int i = 0; i < 6; i++) {
        pushMatrix();
        float rotZ = map(i, 0, 6, 0, TWO_PI);
        float x = sin((z+dz) / 25.0) * 6.0;
        rotZ += 1 / ( 1.0 + exp(-x)) * (TWO_PI/6);
        scale(s, s, 1);
        rotateZ(rotZ);
        translate(-50, 0, z);
        //translate(0, 0, 50 * (i % 2));
        rotateY(-PI/2);
        rect(0, 0, 75, 30, 7);
        popMatrix();
      }
    }
  }
  saveFrame("frames/####.png");
  if (frameCount % 100 == 0) {
    exit();
  }
}