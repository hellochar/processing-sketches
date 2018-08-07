PShader f;
color[] colorTheme = new color[] {#011A27, #063852, #F0810F, #E6DF44}; // polyphone
// color[] colorTheme = new color[] {#021C1E, #004445, #2C7873, #6FB98F};
// color[] colorTheme = new color[] {#80BD9E, #89DA59, #F98866, #FF420E}; polyphone2
// color[] colorTheme = new color[] {#50312F, #E4EA8C, #CB0000, #3F6C45};
// color[] colorTheme = new color[] {#1E1F26, #283655, #486824, #4897D8}; // polyphone 3

float t = 0;

class Thing {
  PVector position;
  color fill;
  float rx, ry, rz;
  Thing(color f) {
    position = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    //position.mult(10);
    fill = f;
    rx = random(PI);
    ry = random(PI);
    rz = random(PI);
  }

  void draw() {
    noStroke();
    fill(fill);
    pushMatrix();
    translate(position.x * 100, position.y * 100, position.z * 100);
    rotateX(rx);
    rotateY(ry);
    rotateZ(rz);
    box(5, 5, 5);
    //triangle(-20, 20, 20, 20, 0, 20 - 40 * sqrt(3) / 2);
    popMatrix();
  }

  void update() {
    PVector velHere = velocity(position);
    PVector firstGuess = position.copy().add(velHere);
    PVector vel = velocity(firstGuess).add(velHere).mult(0.5);
    position.add(vel);
    //position.x += dx;
    //position.y += dy;
    //position.z += dz;
    //x *= 0.95;
    //y *= 0.95;
    //z *= 0.95;
    rx = atan2(vel.y, vel.z);
    ry = atan2(vel.z, vel.x);
    //float pullAmount = map(pow(sin(millis() / 4000f), 3), -1, 1, 0.92, 1 / 0.95);
    //x *= pullAmount;
    //y *= pullAmount;
    //z *= pullAmount;
  }
  
  PVector velocity(PVector l) {
    float x = l.x;
    float y = l.y;
    float z = l.z;
    float r2 = x*x+y*y;
    float d2 = r2 + z*z;
    float r = sqrt(r2);
    float d = sqrt(d2);
    float dx = 0; 
    float dy = 0;
    float dz = 0;
    
    // start with arbitrary perlin noise
    dx += (noise(t, y, z) - 0.5) * 1;
    dy += (noise(x, t, z) - 0.5) * 1;
    dz += (noise(x, y, t) - 0.5) * 1;
    
    float p = pow(5, pow(sin(millis() / 10000f), 10));
    dx *= p;
    dx *= p;
    dx *= p;
    
    // on all - shrink towards 0 with order |r|^3
    dx -= x / d * d2 * d * 0.0002;
    dy -= y / d * d2 * d * 0.0002;
    dz -= z / d * d2 * d * 0.0002;
    
    // on xy - shrink towards 0 with order 1/|z|^2
    dx -= x / r * 1 / (0.1 + z*z);
    dy -= y / r * 1 / (0.1 + z*z);
    
    // on xy - expand outward with order |r|*|z|. That is, when sufficiently tall, start expanding outwards
    dx += x / r * r * z * 0.01;
    dy += y / r * r * z * 0.01;
    
    //// on z - go up with order 1/|r|^2. When shrunken, go up.
    dz += 1 / (1 + r2) * 10;
    
    // on z - go down with order |z|*|r|^2. When expanded and tall, go down.
    dz -= r2*z * 0.01;
    
    // things are going down too fast.
    
    dx *= 0.1;
    dy *= 0.1;
    dz *= 0.1;
    return new PVector(dx, dy, dz);
  }
}
Thing[] things = new Thing[5000];
PGraphics bg;

void setup() {
  size(1280, 800, P3D);
  smooth(8);
  f = loadShader("post.glsl");

  bg = createGraphics(width, height);
  bg.beginDraw();
  float rMax = dist(width/2, height/2, 0, 0);
  for (float r = rMax; r > 0; r--) {
    bg.noStroke();
    bg.fill(lerpColor(colorTheme[0], colorTheme[1], 1 - r / rMax));
    bg.ellipse(width/2, height/2, r*2, r*2);
  }
  bg.endDraw();
  for (int i = 0; i < things.length; i++) {
    if (i < things.length/2) {
      things[i] = new Thing(color(colorTheme[2], 128));
    } else {
      things[i] = new Thing(color(colorTheme[3], 128));
    }
  }
  //  saveFrame("polyphone2.png");
}

void draw() {
  println(frameRate);
  background(bg);
  //stroke(255, 0, 0);
  //line(0, 0, 0, 100, 0, 0);
  //stroke(0, 255, 0);
  //line(0, 0, 0, 0, 100, 0);
  //stroke(0, 0, 255);
  //line(0, 0, 0, 0, 0, 100);
  PVector p = new PVector();
  t = millis() / 2000f;
  for (Thing t : things) {
    t.update();
    p.add(t.position);
  }
  p.mult(1f / things.length);
  camera(width/2, height/2, (mouseX - width/2)*10, p.x * 100, p.y * 100, p.z * 100, 0, 0, -1);
  for (Thing t : things) {
    t.draw();
  }
  f.set("time", millis() / 1000f);
  filter(f);
}