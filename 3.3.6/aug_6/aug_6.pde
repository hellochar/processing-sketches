import java.util.*;

PShader f;
color[] colorTheme = new color[] {#011A27, #063852, #F0810F, #E6DF44}; // polyphone
// color[] colorTheme = new color[] {#021C1E, #004445, #2C7873, #6FB98F};
// color[] colorTheme = new color[] {#80BD9E, #89DA59, #F98866, #FF420E}; polyphone2
// color[] colorTheme = new color[] {#50312F, #E4EA8C, #CB0000, #3F6C45};
// color[] colorTheme = new color[] {#1E1F26, #283655, #486824, #4897D8}; // polyphone 3

float t = 0;
float noisePower;

Set<Character> keys = new HashSet();

class Thing {
  PVector position;
  color fill;
  float rx, ry, rz;
  Thing(color f) {
    position = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    position.mult(0.1);
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

  void update(float dt) {
    PVector velHere = velocity(position, dt);
    PVector firstGuess = position.copy().add(velHere);
    PVector vel = velocity(firstGuess, dt).add(velHere).mult(0.5);
    position.add(vel);
    //rx = atan2(vel.y, vel.z);
    //ry = atan2(vel.z, vel.x);
  }
  
  PVector velocity(PVector l, float dt) {
    float x = l.x;
    float y = l.y;
    float z = l.z;
    float r2 = x*x+y*y + 0.001;
    float d2 = r2 + z*z;
    float r = sqrt(r2);
    float dx = 0; 
    float dy = 0;
    float dz = 0;
    
    float noiseFreq = 2;
    // start with arbitrary perlin noise
    dx += (noise(t, y*noiseFreq, z*noiseFreq) - 0.5) * noisePower;
    dy += (noise(x*noiseFreq, t, z*noiseFreq) - 0.5) * noisePower;
    dz += (noise(x*noiseFreq, y*noiseFreq, t) - 0.5) * noisePower;
    
    // on all - shrink towards 0 with order |r|^3
    dx -= x * d2 * 0.0002;
    dy -= y * d2 * 0.0002;
    dz -= z * d2 * 0.0002;
    
    // on xy - shrink towards 0 with order 1/|z|^2
    dx -= x / r * 1 / (0.1 + z*z);
    dy -= y / r * 1 / (0.1 + z*z);
    
    if (!keys.contains('1')) {
      // on xy - expand outward with order |r|^2*|z|. That is, when sufficiently tall, start expanding outwards
      dx += x / r2 * z * 0.1;
      dy += y / r2 * z * 0.1;
    }
    
    if (!keys.contains('2')) {
      // on z - go up with order 1/|r|^2. When shrunken, go up.
      dz += 1 / (1 + r2) * 1;
    }
    
    if (!keys.contains('3')) {
      // on z - go down with order |z|*|r|^2. When expanded and tall, go down.
      dz -= r2*z * 0.01;
    }
    
    // things are going down too fast.
    dx *= dt * 30;
    dy *= dt * 30;
    dz *= dt * 30;
    return new PVector(dx, dy, dz);
  }
}
Thing[] things = new Thing[3000];
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
  noLoop();
}

void mousePressed() {
  loop();
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
  float dt;
  if (t < 0.5) {
    dt = lerp(1 / 2000f, 16 / 2000f, t / 0.5);
  } else {
    dt = 16 / 2000f;
  }
  println(t);
  t += dt;
  noisePower = pow(5, pow(sin(t / 2.5), 10));
  for (Thing t : things) {
    t.update(dt);
    p.add(t.position);
  }
  p.mult(1f / things.length);
  float camDist = width * 0.3;
  camera(camDist * cos(t / 3), camDist * sin(t / 3), (map(sin(t / 3), -1, 1, 0, width) - width/2)*2, p.x * 100, p.y * 100, p.z * 100, 0, 0, -1);
  for (Thing t : things) {
    t.draw();
  }
  f.set("time", t);
  filter(f);
}

void keyPressed() {
  keys.add(key);
}

void keyReleased() {
  keys.remove(key);
}