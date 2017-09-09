import java.awt.event.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.collision.*;
import org.jbox2d.util.blob.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.*;

AABB worldBounds;
Vec2 grav;
World world;

float timeStep = 1/60.0;
int iterations = 10;

BodyDef defaultBoxDef = new BodyDef();
PolygonDef defaultSquareDef = new PolygonDef();

float scale = 1;
Vec2 camera;

HashSet keys;

void setup() {
  size(500, 500, P2D);
  camera = new Vec2(width/2, height/2);
  updateScale(50);
  keys = new HashSet();
  
  //set up the world
  worldBounds = new AABB(new Vec2(-width, -height), new Vec2(width, height));
  grav = new Vec2(0, 9.8);
  world = new World(worldBounds, grav, true);
  
  //create static rectangles
  BodyDef groundBodyDef = new BodyDef();
  PolygonDef groundShapeDef = new PolygonDef();
  groundShapeDef.setAsBox(width /2 /scale, 10 /scale);
  for(int a = 1; a < 10; a++) {
    for(float b = -a/2.0; b < a/2.0; b++) {
      groundBodyDef.position.set(2*(b+.5)*width/scale, (height-10)*a/scale);
      Body groundBody = world.createBody(groundBodyDef);
      groundBody.createShape(groundShapeDef);
    }
  }
  
  BodyDef originDef = new BodyDef();
  originDef.position.set(0, 0);
  Body originBody = world.createBody(originDef);
  PolygonDef originShapeDef = new PolygonDef();
  originShapeDef.setAsBox(10 /scale, 10 /scale);
  originBody.createShape(originShapeDef);
  
  
  //create default definitions
  defaultBoxDef.position.set(0 /scale, 25 /scale);
  
  defaultSquareDef.setAsBox(15 /scale, 15 /scale);
  defaultSquareDef.density = 1;
  defaultSquareDef.friction = .3;
  defaultSquareDef.restitution = .3;
  
  //create a dynamic square
  Body body = world.createBody(defaultBoxDef);
  body.createShape(defaultSquareDef);
  body.setMassFromShapes();
  
  noFill();
  
  addMouseWheelListener(new MouseWheelListener() {
    public void mouseWheelMoved(MouseWheelEvent e) {
      updateScale(1-e.getWheelRotation()/10.0);
    }
  });
}

void updateScale(float s) {
  camera.addLocal(new Vec2(width/(2*scale)*(1/s-1), height/(2*scale)*(1/s-1)));
  scale *= s;
}

int px, py;
boolean dragged;
void mousePressed() {
  if(mouseButton == LEFT) {
    dragged = true;
    px = mouseX;
    py = mouseY;
  }
}

void mouseReleased() {
  if(mouseButton == LEFT) {
    dragged = false;
    BodyDef def = new BodyDef();
    float w = (mouseX-px)/2 /scale, h = (mouseY-py)/2 /scale;
    def.position.set( world(new Vec2(mouseX, mouseY)).sub(new Vec2(w, h)) );
  //  println("created body at "+mouseX/scale+" - "+cameraX+" - "+w+", "+(mouseY)/scale+" - "+cameraY+" - "+h );
    Body b = world.createBody(def);
    PolygonDef square = new PolygonDef();
    square.setAsBox(abs(w), abs(h));
    square.density = 1;
    square.friction = .3;
    square.restitution = .3;
    b.createShape(square);
    b.setMassFromShapes();
  }
}

Vec2 world(Vec2 screen) {
  return screen.mul(1/scale).sub(camera);
}

Vec2 screen(Vec2 world) {
  return world.add(camera).mul(scale);
}

void close() {
  for(Body b = world.getBodyList(); b != null; b = b.getNext()) {
    world.destroyBody(b);
  }
}

void keyPressed() {
  if(key == CODED)
    keys.add(new Integer(keyCode));
  else
    keys.add(new Integer(key));
}

void keyReleased() {
  if(key == CODED)
    keys.remove(new Integer(keyCode));
  else
    keys.remove(new Integer(key));
}

boolean keyPressed(int k) {
  return keys.contains(new Integer(k));
}

float speed = 15;

void draw() {
  if(mousePressed && mouseButton == RIGHT) {
    defaultBoxDef.position.set(world(new Vec2(mouseX, mouseY)));
    Body body = world.createBody(defaultBoxDef);
    body.createShape(defaultSquareDef);
    body.setMassFromShapes();
  }
  if(keyPressed(UP) | keyPressed('w') | keyPressed('q') | keyPressed('e')) {
     camera.y += speed/scale;
  }
  if(keyPressed(LEFT) | keyPressed('a') | keyPressed('q')) {
     camera.x += speed/scale;
  }
  if(keyPressed(DOWN) | keyPressed('s')) {
     camera.y -= speed/scale;
  }
  if(keyPressed(RIGHT) | keyPressed('d') | keyPressed('e')) {
     camera.x -= speed/scale;
  }
  if(keyPressed('-'))
    updateScale(.98);
    
  if(keyPressed('='))
    updateScale(1.02);
    
  if(keyPressed('k')) {
    defaultBoxDef.position.set(new Vec2(width/2, height/2));
    Body body = world.createBody(defaultBoxDef);
    body.createShape(defaultSquareDef);
    body.setMassFromShapes();
  }
  background(0);
  world.step(timeStep, iterations);
  
  if(dragged) {
    rectMode(CORNERS);
    rect(px, py, mouseX, mouseY);
  }
  
  scale(scale);
  translate(camera.x, camera.y);
  for(Body b = world.getBodyList(); b != null; b = b.getNext()) {
    drawBody(b);
  }
//  println(frameRate);
}

void drawBody(Body b) {
  if(b.getShapeList() == null) return;
  
  //choosing stroke color
  if(b.isDynamic()) 
    stroke(color(255, 255, 255));
  if(b.isSleeping())
    stroke(color(0, 0, 255));
  if(b.isFrozen())
    stroke(color(255, 255, 0));
  if(b.isStatic())
    stroke(color(0, 0, 255));
    
  pushMatrix();
  translate(b.getPosition().x, b.getPosition().y);
  rotate(b.getAngle());
  for(org.jbox2d.collision.Shape s = b.getShapeList(); s != null; s = s.getNext()) {
    drawShape(s);
  }
//  println("Drawing body "+b+" at "+b.getPosition()+"... ");
  popMatrix();
}

void drawShape(org.jbox2d.collision.Shape s) {
  if(s instanceof PolygonShape) {
    PolygonShape p = (PolygonShape) s;
    beginShape();
    for(int a = 0; a < p.getVertexCount(); a++) {
      Vec2 v = p.getVertices()[a];
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
  }
  else if(s instanceof CircleShape) {
    CircleShape c = (CircleShape) s;
    ellipse(0, 0, c.getRadius(), c.getRadius());
  }
}
