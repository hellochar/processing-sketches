import zhang.*;
import zhang.world.*;

import wiiremotej.*;
import wiiremotej.event.*;

import java.awt.event.KeyEvent.*;
import org.jbox2d.common.Vec2;

WiiRemote remote;
float x, y, s;
Camera c;
Vector map;
World w;

void setup() {
  size(800, 600);
  try{
    remote = WiiRemoteJ.findRemote();
    remote.addWiiRemoteListener(new Listener());
    remote.setIRSensorEnabled(true, WRIREvent.FULL, IRSensitivitySettings.WII_LEVEL_5);
    remote.setLEDIlluminated(0, true);
    map = remote.getButtonMaps();
    map.add(new ButtonKeyMap(WRButtonEvent.LEFT, LEFT));
    map.add(new ButtonKeyMap(WRButtonEvent.UP, UP));
    map.add(new ButtonKeyMap(WRButtonEvent.RIGHT, RIGHT));
    map.add(new ButtonKeyMap(WRButtonEvent.DOWN, DOWN));
    map.add(new ButtonKeyMap(WRButtonEvent.MINUS, KeyEvent.VK_MINUS));
    map.add(new ButtonKeyMap(WRButtonEvent.PLUS, KeyEvent.VK_EQUALS));
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  c = new Camera(this);
  c.registerScroll(false, 1.04);
  w = new World();
  for(int x = 0; x < 25; x++) {
    w.add(new Duck());
  }
  smooth();
  noFill();
  stroke(255);
}

void shoot() {
  Vec2 t = c.world(new Vec2(x, y));
  for(int a =0 ; a < w.size(); a++) {
    Duck d = (Duck) w.get(a);
    Vec2 dLoc = new Vec2(d.x, d.y);
    if(dist(t.x, t.y, dLoc.x, dLoc.y) < 5) {
      w.remove(d);
      break;
    }
  }
}

void draw() {
  background(color(0, 0, 32));
  ellipse(x, y, s, s);
  c.scroll(15);
  c.apply();
  w.step();
}

class Duck extends Unit {
  float dx, dy;
  
  public Duck() {
    super(random(-width, width), random(-height, height));
    dx = random(-3, 3);
    dy = random(-3, 3);
  }
  
  public void run() {
    x += dx;
    y += dy;
  }
  
  public void update() {
  }
  
  public void draw() {
    float ang = atan2(dy, dx);
    pushMatrix();
    translate(x, y);
    rotate(ang);
    pushStyle();
    rectMode(RADIUS);
    noStroke();
    fill(255);
    rect(0, 0, 10, 10);
    popStyle();
    popMatrix();
  }
  
}

class Listener extends WiiRemoteAdapter {
  public void IRInputReceived(WRIREvent evt) {
    IRLight l = evt.getIRLights()[0];
    if(l != null) {
      x = map((float)l.getX(), 0, 1, width, 0);
      y = map((float)l.getY(), 0, 1, 0, height);
      s = (float)l.getIntensity()*100;
    }
  }

  public void buttonInputReceived(WRButtonEvent evt) {
    if(!evt.wasPressed(WRButtonEvent.B) & evt.isPressed(WRButtonEvent.B)) {
      shoot();
    }
  }

  public void disconnected() {
    exit();
  }
}



