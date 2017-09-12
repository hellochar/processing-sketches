import zhang.*;

Walker w;
Camera camera;
boolean follow = true, paused = false, showSplatter = true, wasFollow;
ArrayList splatters;

void setup() {
  size(1000, 600);
  //  walkers = new ArrayList();
  w = new Walker(new PVector(width/2, height/2), random(0, TWO_PI), random(2, 4), 128*(int)random(3), 128*(int)random(3), 128*(int)random(3));
  splatters = new ArrayList();
  camera = new Camera(this);
  camera.registerScrollWheel(1.05);
  camera.ms(15);
}

void exit() {
  super.exit();
}

void keyPressed() {
  if(key == 'f') {
    follow = !follow;
  }
  if(key == ' ') {
    paused = !paused;
    if(paused) {
      if(wasFollow = follow) follow = false;
    }
    else {
      follow = wasFollow;
    }
  }
  if(key == 't') {
    showSplatter = !showSplatter;
  }
}

void mousePressed() {
  w.changeSpeed(1.5);
}

void draw() {
  background(0xff449966);
  //  if(frameCount % 12*60 == 0 & walkers.size() < 1) {
  //    walkers.add();
  //  }
  //  for(int a = 0; a < walkers.size(); a++) {
  //    Walker w = (Walker)walkers.get(a);
  if(follow)
    camera.setCenter(w.last().loc);
  else {
    camera.uiHandle();
  }
  camera.apply();
  if(!paused)
    w.run();
  w.show();
  if(showSplatter) {
    for(int a = 0; a < splatters.size(); a++) {
      Splatter s = (Splatter)splatters.get(a);
      s.show();
    }
  }
}

