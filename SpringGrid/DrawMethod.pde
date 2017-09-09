abstract class DrawMethod {
  final void draw(Grid g) {
    render(g);
    pushMatrix();  
    resetMatrix();
    fill(255);
    textAlign(RIGHT, TOP);
    text(e.freq, width, 0);
//    
//    textAlign(LEFT, TOP);
//    text(grid.timeElapsed, 0, 0);
//    println("("+frameRate+", "+c.x+", "+c.y);
    popMatrix();
  }
  
  abstract void render(Grid g);
  
  void drawEmitters(Grid g) {
    for(Emitter e : g.emitters) {
      e.draw();
    }
  }
  
  void mousePressed() {}
  public void mouseReleased() { }
  public void mouseClicked() { }
  public void mouseDragged() { }
  public void mouseMoved() { }
  
  public void keyPressed() {
    if(key == ' ') {
      grid.clear();
    }
    else if(key == 'c') { //change color mappers
      if(mapper == defaultMapper) mapper = zeroMapper;
      else mapper = defaultMapper;
    }
    else if(key == 'd') { //change dimensions
      if(dm == twoD) { dm = threeD; threeD.activate();
      }
      else{ threeD.deactivate(); dm = twoD;
      }
    }
    else if(key == 'p') {
      paused = !paused;
    }
    else if(key == 'q') {
      for(Cell c : grid) {
        if(abs(c.pos - .2) < .19) {
          c.wallify();
        }
      }
    }
  }
  public void keyReleased() { }
  public void keyTyped() { }
  
  public void draggedAction(int x, int y) {}
}

class FlatColorMap extends DrawMethod {

  Queue<Float> values = new LinkedList();
  
  FlatColorMap() {
  }

  void render(Grid g) {
    background(204);
    noStroke();
    for(int x = 0; x < g.w; x++) {
      for(int y = 0; y < g.h; y++) {
        fill(mapper.colorFor(g.cellAt(x, y)));
        rect(x*g.multX, y*g.multY, g.multX, g.multY);
      }
    }
  
//    Cell c = g.cellAt((int)mouseX/g.multX, mouseY/g.multY);
//    values.offer(c.pos);
//    if(values.size() > width) values.remove();
//    pushMatrix(); noStroke(); fill(255, 255, 255);
//    for(Float f : values) {
//      ellipse(0, width/2 + f, 5, 5);
//      translate(1, 0);
//    }
//    popMatrix();
  }
  
  void draggedAction(int x, int y) {
    grid.cellAt(x/grid.multX, y/grid.multY).wallify();
  }
  
  void mouseDragged() {
    if(mouseButton == RIGHT) {
      for(Emitter e : grid.emitters) {
        if(dist(pmouseX, pmouseY, e.x*grid.multX, e.y*grid.multY) < 10) {
          e.x = mouseX / grid.multX;
          e.y = mouseY / grid.multY;
          break;
        }
      }
    }
  }
  
  void mouseClicked() {
    grid.addEmitter(new Emitter(grid.s2gX(mouseX), grid.s2gY(mouseY)));
  }
}

class DotMap extends DrawMethod {
  
  PeasyCam cam;
  CameraState lastState;
  
  DotMap() {
    cam = new PeasyCam(SpringGrid.this, width/2, height/2, 0, 1000);
    cam.rotateX(-PI/4);
    deactivate();
  }

  void render(Grid g) {
    background(204);
    noFill(); stroke(0);
    for(int x = 0; x < g.w; x++) {
      for(int y = 0; y < g.h; y++) {
        fill(mapper.colorFor(g.cellAt(x, y)));
        point(x*g.multX, y*g.multY, g.cellAt(x, y).pos);
      }
    }
  }
  
  void activate() {
    cam.setActive(true);
    cam.setState(lastState, 200);
  }
  
  void deactivate() {
    cam.setActive(false);
    lastState = cam.getState();
    resetMatrix();
    camera();
  }
}

class PlanarMap extends DotMap {
  PlanarMap() {
    super();
  }
  
  protected void putVert(int x, int y, boolean fixed, Grid g) {
    Cell c = g.cellAt(x, y);
    if(c.fixed || fixed)
      g.vert(x, y, 0);
    else 
      g.vert(x, y, c.pos);
  }
  
  void render(Grid g) {
    lights();
    background(250); noStroke();
    for(int x = 0; x < g.w-1; x++) {
      for(int y = 0; y < g.h-1; y++) {
        Cell c = g.cellAt(x, y);
        fill(mapper.colorFor(c));
        beginShape();
        putVert(x, y, c.fixed, g);
        putVert(x+1, y, c.fixed, g);
        putVert(x+1, y+1, c.fixed, g);
        putVert(x, y+1, c.fixed, g);
        endShape(CLOSE);
      }
    }
  }
}

class ConnectedPlanarMap extends PlanarMap {
  ConnectedPlanarMap() {
    super();
  }
  
  float avgHeight(float mx, float my, Grid g) { //the coordinates are at the corner of 4 (some possibly null) cells. any fixed cells automatically make the height 0.
    float height = 0;
    for(float dx = -.5; dx < 1; dx++) {
      for(float dy = -.5; dy < 1; dy++) {
        Cell c = g.cellAt(round(mx + dx), round(my + dy));
        if(c != null) {
          height += c.pos;
          if(c.fixed) return 0;
        }
      }
    }
    return height / 4;
  }
  
  void render(Grid g) {
    background(204); noStroke();
    pushMatrix();
    translate(-g.multX/2, -g.multY/2);
    for(int x = 0; x < g.w; x++) {
      for(int y = 0; y < g.h; y++) {
        Cell c = g.cellAt(x, y);
        fill(mapper.colorFor(c));
        beginShape();
        for(float dx = -.5; dx < 1; dx++) {
          for(float dy = -.5; dy < 1; dy++) {
            float z = c.fixed ? 0 : avgHeight(x+dx, y+dy, g);
            g.vert(round(x+dx), round(y+dy), z);
          }
        }
        endShape(CLOSE);
      }
    }
    popMatrix();
  }
}
