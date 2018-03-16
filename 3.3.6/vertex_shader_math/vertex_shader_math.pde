PShader particlePositions;
PShader pointShader;

void setup() {
  size(256, 256, P3D);
  particlePositions = loadShader("particleFrag.glsl", "particleVert.glsl");
  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");  stroke(255);
  strokeWeight(100);
  
  background(0);
}

void draw() {
  background(0);
  shader(pointShader, POINTS);
  if (mousePressed) {
    point(mouseX, mouseY);
  }
  println((mouseX - width/2), (mouseY - height/2), 
          red(get(mouseX, mouseY)) / 255f, green(get(mouseX, mouseY)) / 255f, blue(get(mouseX, mouseY)) / 255f);

  //background(frameCount % 255);
  //shader(particlePositions, POINTS);
  //stroke(255, 0, 255);
  //strokeWeight(5);
  //point(10, 10);
  //point(20, 20);
  //point(30, 30);
  //point(mouseX/2, mouseY/2);
  
  //beginShape();
  //vertex(10, 10);
  //vertex(20, 20);
  //vertex(30, 30);
  //vertex(mouseX/2, mouseY/2);
  //endShape();
}



// pixelColor = 60
// 60 / 255 = clip.w / 1000
// 60 / 255 * 1000 = clip.w
// clip.w = 235