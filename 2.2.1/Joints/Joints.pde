import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import toxi.math.conversion.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh2d.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.geom.mesh.*;
import toxi.math.waves.*;
import toxi.util.*;
import toxi.math.noise.*;

Joint main;
PeasyCam cam;

void setup() {
  size(800, 600, P3D);
  main = new HalfSphere(100, 3);
  cam = new PeasyCam(this, 100);
  main.populate();
}

void draw() {
  background(225);
  main.draw(this);
  
}
