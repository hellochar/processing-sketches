PGraphics g;

void setup() {
  size(64, 64);
  g = createGraphics(width, height);
  g.colorMode(HSB, 255);
  g.fill(255, 5);
  g.background(255, 0);
  
  g.strokeWeight(1);
  for(int i = 0; i < 2; i++) {
    for(float hue = 0; hue < 255; hue += 255 / 60.0) {
      g.stroke(hue, 64, 255, 1);
      float pointAngleOffset = 0.5 * PI / 180;
      for (float radius = 0; radius < 0.9; radius += 0.9 / 1) {
        perturbedLine(width/2, height/2, 0, width / 2 * radius);
        perturbedLine(width, height/2, PI - pointAngleOffset, width / 2);
        perturbedLine(width, height/2, PI + pointAngleOffset, width / 2);
        
        perturbedLine(width/2, height/2, PI/2, width / 2 * radius);
        perturbedLine(width/2, height, 3*PI/2 - pointAngleOffset, width / 2);
        perturbedLine(width/2, height, 3*PI/2 + pointAngleOffset, width / 2);
        
        perturbedLine(width/2, height/2, PI, width / 2 * radius);
        perturbedLine(0, height/2, -pointAngleOffset, width / 2);
        perturbedLine(0, height/2, pointAngleOffset, width / 2);
        
        perturbedLine(width/2, height/2, 3*PI/2, width / 2 * radius);
        perturbedLine(width/2, 0, PI/2 - pointAngleOffset, width / 2);
        perturbedLine(width/2, 0, PI/2 + pointAngleOffset, width / 2);
      }
    }
  }
  
  int numLines = 600;
  for(int i = 0; i < numLines; i++) {
    float angle = map(i, 0, numLines, 0, TWO_PI * sqrt(100));
    float radius = map(i, 0, numLines, 0, width / 2 * 0.35);
    float dx = cos(angle);
    float dy = sin(angle);
    radius *= pow(abs(dx) + abs(dy), -1.6) * 1.5;
//    float angle = atan2(random(1) - 0.5, random(1) - 0.5);
    g.strokeWeight(1);
    for(float hue = 0; hue < 255; hue += 255 / 10.0) {
      g.stroke(hue, 64, 255, 7);
      perturbedLine(width/2, height/2, angle, radius);
    }
  }
  g.filter(BLUR, 1.0);
  g.save("star.png");
  background(0);
  image(g, 0,0);
}

void perturbedLine(float x, float y, float angle, float radius) {
  angle += random(-2.0, 2.0) * PI / 180;
  g.line(x, y, x + radius * cos(angle), y + radius*sin(angle));
}
