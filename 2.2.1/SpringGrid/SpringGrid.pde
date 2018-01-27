import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import java.util.*;

Grid grid;
ColorMapper defaultMapper = new TwoColorMapper(),
            zeroMapper = new ZeroMapper(),
            mapper = defaultMapper;

//Simulation of the molecules in a 2D object; each molecule is bound with a spring to each adjacent molecule.
//Conservation of energy is the solution. Let the total energy of the system = constant. Each molecule has KE 1/2mv^2 and PE 1/2kx^2. 
//Each molecule will pull its neighboring molecules with a strength of kNeighborValue; force pairs will be implemented so as to keep energy constant.
//I think the existence of force pairs is the only thing required to create energy conservation.

//todo:  Should implement trapezoidal method later, or maybe a range-kutta method.

//right now: left click = put droplet, left drag = droplet drag
//new version: left double click = make new emitter, left drag = move emitter, right drag = toggle wall.
FlatColorMap twoD;
PlanarMap threeD;
DrawMethod dm;
Emitter e;
boolean paused = false;
void setup() {
  size(600, 600, P3D);
  grid = new Grid(150, 150, method1, midpoint);
  dm = twoD = new FlatColorMap();
  // threeD = new PlanarMap();
  e = new Emitter(grid.w/2, grid.h/2);
  e.amp = 200;
  grid.addEmitter(e);
  textFont(createFont("Lucidia Sans", 16));
}

void draw() {
  if(!paused) {
    //for(int i = 0; i < 7; i++)
      grid.step();
//      for(logger l : loggers) l.run();
  }
  dm.draw(grid);
  dm.drawEmitters(grid);
//  for(logger l : loggers) l.draw();

//  Cell c = grid.cellAt(mouseX/grid.multX, mouseY/grid.multY);
////  println("Cell's pos, vel: "+c.pos+", "+c.vel);
  if(keyPressed) {
    if(keyCode == LEFT) {
      e.setFreq(e.freq*.98);
    }
    else if(keyCode == RIGHT) {
      e.setFreq(e.freq/.98);
    }
  }
  if(mousePressed && mouseButton == LEFT) {
    smoothDrag();
  }
}

void smoothDrag() {
  float dx = mouseX - pmouseX,
  dy = mouseY - pmouseY;
  int dir,pCoord,
        coord,
        poCoord;
  float slope;
        
  boolean xIter;
  if(abs(dx) > abs(dy)) {
    dir = round(Math.signum(dx));
    slope = dy / dx;
    pCoord = pmouseX; coord = mouseX; poCoord = pmouseY;
    xIter = true;
  }
  else {
    dir = round(Math.signum(dy));
    slope = dx / dy;
    pCoord = pmouseY; coord = mouseY; poCoord = pmouseX;
    xIter = false;
  }
  for(int i = pCoord; i != coord; i += dir) {
    float o = poCoord + slope * (i-pCoord);
    if(xIter) {
      dm.draggedAction(i, round(o));
    }
    else {
      dm.draggedAction(round(o), i);
    }
  }
}


void mousePressed() { dm.mousePressed(); }
public void mouseReleased() { dm.mouseReleased(); }
public void mouseClicked() { dm.mouseClicked(); }
public void mouseDragged() { dm.mouseDragged(); }
public void mouseMoved() { dm.mouseMoved(); }

public void keyPressed() { dm.keyPressed(); }
public void keyReleased() { dm.keyReleased(); }
public void keyTyped() { dm.keyTyped(); }
