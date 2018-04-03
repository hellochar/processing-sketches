// modes:
// move middle of enemy and ally
// move towards ally
// move towards ally, avoid everyone
// move towards ally, avoid enemy
// move towards ally, really avoid enemy, avoid everyone

// picking ally - random or uniform
// pick enemy - random or uniform

enum Pick { Random, Uniform }

Pick pickAlly = Pick.Random;
Pick pickEnemy = Pick.Random;
 
boolean avoidEnemy = false;
boolean avoidEveryone = true;

boolean clampedWorld = false;

void keyPressed() {
  if (key == 'n') {
    avoidEnemy = !avoidEnemy;
  }
  if (key == 'v') {
    avoidEveryone = !avoidEveryone;
  }
  if (key == ' ') {
    repickAllyEnemy();
  }
}

class Particle {
  PVector pos;
  PVector nextPos;
  Particle enemy;
  Particle ally;
  float maxSpeed = 15;
  float spaceForAlly = 150;
  float avoidEnemyPow = 10;
  float avoidEveryonePow = 25;
  
  float chaseAllyMag;
  float avoidEnemyMag;
  
  void chaseAlly() {
    PVector wantedPos = enemy.pos.copy().add(ally.pos).add(pos).div(3);
    //PVector wantedPos = pos.copy().add(ally.pos).div(2);
    //PVector wantedPos = ally.pos;
    // give the ally a bit of distance
    PVector offsetFromAllyPos = PVector.sub(wantedPos, ally.pos);
    if (offsetFromAllyPos.mag() < spaceForAlly) {
      offsetFromAllyPos.setMag(spaceForAlly);
      wantedPos.set(ally.pos).add(offsetFromAllyPos);
    }

    float distToWantedPos = pos.dist(wantedPos);
    if (distToWantedPos < maxSpeed) {
      nextPos = wantedPos;
      chaseAllyMag = distToWantedPos;
    } else {
      float amount = maxSpeed / distToWantedPos;
      nextPos = PVector.lerp(pos, wantedPos, amount);
      chaseAllyMag = maxSpeed;
    }
  }

  void computeNextPos() {
    chaseAlly();
    avoidEnemyMag = 0;
    
    if (avoidEnemy) {
      PVector offset = enemy.pos.copy().sub(pos);
      float dist2 = offset.magSq();
      if (dist2 > 0) {
        PVector force = offset.copy().mult(-avoidEnemyPow / dist2);
        nextPos.add(force);
        avoidEnemyMag += force.mag();
      }
    }
    
    if (avoidEveryone) {
      for (Particle p : particles) {
        PVector offset = p.pos.copy().sub(pos);
        float dist2 = offset.magSq();
        if (dist2 > 0) {
          PVector force = offset.copy().mult(-avoidEveryonePow / dist2);
          nextPos.add(force);
        }
      }
    }
  }

  void update() {
    PVector vel = nextPos.copy().sub(pos);
    float dt = 0.4;
    vel.mult(dt);
    pos.add(vel);
    
    if (clampedWorld) {
      //pos.x = constrain(pos.x, random(5), width-random(5));
      //pos.y = constrain(pos.y, random(5), height-random(5));
      pos.x = ((pos.x % width) + width) % width;
      pos.y = ((pos.y % height) + height) % height;
    }
  }

  void draw() {
    //stroke(128, 255, 128, chaseAllyMag / maxSpeed * 255);
    //strokeWeight(chaseAllyMag / 3);
    //line(pos.x, pos.y, ally.pos.x, ally.pos.y);
    
    //stroke(255, 128, 128, avoidEnemyMag / maxSpeed * 255);
    //strokeWeight(avoidEnemyMag / 3);
    //line(pos.x, pos.y, enemy.pos.x, enemy.pos.y);
    
    noStroke();
    fill(12, 21, 134);
    ellipse(pos.x, pos.y, 10, 10);
  }
}

Particle[] particles = new Particle[16];

void setup() {
  size(800, 600, P3D);
  //randomSeed(0);
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
    // particles[i].pos = new PVector(random(-width, width), random(-height, height));
    particles[i].pos = new PVector(random(width), random(height));
  }
  repickAllyEnemy();
}

void mousePressed() {
  repickAllyEnemy();
}

void repickAllyEnemy() {
  for (int i = 0; i < particles.length; i++) {
    Particle p = particles[i];

    int enemyIndex, allyIndex;
    //allyIndex = pickIndex(i, enemyIndex);
    if (pickEnemy == Pick.Uniform) {
      enemyIndex = wrap(i - 1, particles.length);
    } else if(pickEnemy == Pick.Random) {
      enemyIndex = pickIndex(i, i);
    } else {
      throw new Error();
    }
    
    if (pickAlly == Pick.Uniform) {
      allyIndex = wrap(i + 1, particles.length);
    } else if(pickAlly == Pick.Random) {
      allyIndex = pickIndex(i, enemyIndex);
    } else {
      throw new Error();
    }
    
    p.enemy = particles[enemyIndex];
    p.ally = particles[allyIndex];
  }
}

int wrap(int x, int max) {
  return ((x % max) + max) % max;  
}

int pickIndex(int not, int not2) {
  int index;
  do {
     index = int(random(particles.length));
     //index = int(random(not + 1));
  } while (index == not || index == not2);
  return index;
}

void draw() {
  background(255);
  textAlign(LEFT, TOP);
  //text("avoidEnemy:" + avoidEnemy + "\navoidEveryone:" + avoidEveryone, 0, 0);
  PVector center = new PVector();
  for (int i = 0; i < 1; i++) {
    for (Particle p : particles) {
      p.computeNextPos();
      center.add(p.pos);
    }
    center.div(particles.length);
    for (Particle p : particles) {
      p.update();
    }
  }
  //scale(2);
  //rect(-50, -50, 100, 100);
  //translate(width/2/2, height/2/2);
  //translate(-center.x/2, -center.y/2);
  //println(modelX(mouseX, mouseY, 0), modelY(mouseX, mouseY, 0));
  if (!clampedWorld) {
    camera(center.x, center.y, 0.8 * (height/2.0) / tan(PI*30.0 / 180.0), center.x, center.y, 0, 0, 1, 0);
  }
  for (Particle p : particles) {
    p.draw();
  }
}