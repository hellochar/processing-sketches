import zhang.*;
//import jboxrenderer.*;

import traer.physics.*;

import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim m;
ParticleSystem ps;
AudioOutput out;
World w;
Camera c;

void setup() {
  size(500, 500);
  m = new Minim(this);
  out = m.getLineOut();
  ps = new ParticleSystem(0, 0);
  w = new World();
  for(int a = 0; 3; a++) {
    w.add(new Shaper((int)random(1, 5), random(width), random(height)));
  }
  c = new Camera(this, 10, 0, 0);
  c.registerScroll(true, 1.05);
}

void close() {
  c.unregisterScroll();
  out.close();
  m.stop();
}

void keyPressed() {
  if(key == 'm') {
    if(out.isSounding()) {
      out.noSound();
    }else {
      out.sound();
    }
  }
  if(key == 'f') {
    println(c.scale);
  }
}

void draw() {
  background(204);
  noFill();
  c.scroll(15);
  ps.tick();
  c.apply();
  w.run();
  w.update();
  w.draw();
  line(0, 0, 0, height);
//  println(frameRate);
}

void mousePressed() {
  for(int a = 0; a < w.size(); a++) {
    Vec2 wm = c.world(new Vec2(mouseX, mouseY));
    Shaper s = (Shaper)w.get(a);
    if(dist(wm.x, wm.y, s.x, s.y) < c.worldDist(1)) {
      if(out.isEnabled(s.o)) {
        out.disableSignal(s.o);
      }
      else {
        out.enableSignal(s.o);
      }
    }
  }
}

float freqFor(float x) {
  return map(x, 0, width, 100, 3000);
}

float ampFor(float y) {
  return .05;
//  return map(y, 0, height, 0, .2);
}
