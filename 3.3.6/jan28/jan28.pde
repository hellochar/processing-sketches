
PShader gammaCorrection;

void setup() {
  size(displayWidth, displayHeight, P2D);
  gammaCorrection = loadShader("gammaCorrection.glsl");
  colorMode(HSB);
  randomizeParametersAndRestart(); 
}

float
  midX, midY, // width/4 -> 3*width/4
  scale, // 1 -> 1.5
  d1XScale, d1YScale, // 100 - 500
  d2XScale, d2YScale, // 100 - 500
  zBase, // 0 -> TWO_PI
  iBase, // 0 -> TWO_PI
  jBase, // 0 -> TWO_PI
  numZ, // 2 -> 5
  numI, // 25 -> 75
  numJ, // 5 -> 100
  zInvertScalar,  // 2500 -> 100000
  baseHue, // 0 -> 255
  numIterations,
  name;

void randomizeParametersAndRestart() {
  background(0);
  midX = random(width/4, 3*width/4);
  midY = random(height/4, 3*height/4);
  scale = random(1, 2);
  d1XScale = random(100, 500);
  d1YScale = random(100, 500);
  d2XScale = random(100, 500);
  d2YScale = random(100, 500);
  zBase = random(TWO_PI);
  iBase = random(TWO_PI);
  jBase = random(TWO_PI);
  numZ = (int)random(2, 6);
  numI = (int)random(25, 76);
  numJ = (int)random(5, 101);
  zInvertScalar = 75000 * pow(2, randomGaussian());
  baseHue = random(255);
  numIterations = 0;
  name = random(1);
  println(String.valueOf(name).substring(2));
}

void keyPressed() {
  if (key == ' ') {
    randomizeParametersAndRestart();
  }
}

void draw() {
  blendMode(BLEND);
  resetMatrix();
  noStroke();
  fill(0, 18);
  rect(0, 0, width, height);
  
  blendMode(ADD);
  //shapeTotal.beginShape(LINES);
  //shapeTotal.stroke(frameCount*13 % 255, 255, 128);
  float dist1 = 0;
  float dist2 = 0;
  translate(midX, midY);
  scale(scale);
  for (int z = 0; z < numZ; z++) {
    float alpha = zBase + map(z, 0, numZ, 0, TWO_PI) + numIterations / 100;
    for (int i = 0; i < numI; i++) {
      float theta = iBase + map(i, 0, numI, 0, TWO_PI) + z / numZ + numIterations / 1;
      for (int j = 0; j < numJ; j++) {
        float gamma = jBase + map(j, 0, numJ, -PI, PI) + numIterations / 500;
        dist1 = d1XScale * cos(gamma) + d1YScale * sin(theta);
        dist2 = d2XScale * sin(gamma) - d2YScale * cos(theta);
        
        float x1 = cos(theta) * dist1;
        float y1 = sin(theta) * dist1;
        
        float x2 = cos(theta) * dist1 + sin(gamma) * dist2;
        float y2 = sin(theta) * dist1 + cos(gamma) * dist2;
        
        float x3 = cos(alpha) * (zInvertScalar / (dist1 + dist2));
        float y3 = sin(alpha) * (zInvertScalar / (dist1 + dist2));
        
        float hue = (baseHue + numIterations * 0.01 + map(theta + gamma + alpha, 0, TWO_PI*3, 0, 255)) % 255;
        stroke(hue, 255, 128, 4);
        line(x1, y1, x2, y2);
        stroke(hue, 255, 128, 2);
        line(x2, y2, x3, y3);
      }
    }
    print(map(z + 1, 0, numZ, 0, 100) + "%, ");
  }
  numIterations++;
  float b = 0;
  for (int i = 0; i < 1000; i++) {
    b += brightness(get((int)random(width), (int)random(height)));
  }
  b /= 1000;
  //if (b >= 80 || numIterations >= 20) {
  //  saveFrame("frames/" + String.valueOf(name).substring(2) + ".png");
  //  randomizeParametersAndRestart();
  //}
  println(b);
  
  //background(0, 20);
  //shapeTotal.endShape();
//  translate(mouseX - width/2, mouseY - height/2);
  //shape(shapeTotal);
}