import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

import JMyron.*;

JMyron myron;
Minim minim;
LinkedList particles;

void setup() {
  size(640, 480);
  myron = new JMyron();
  minim = new Minim(this);
  myron.start(width, height);
  particles = new LinkedList();
  myron.adaptivity(30);
  colorMode(HSB, 1);
//  myron.adapt();
  smooth();
}

void draw() {
  myron.update();
  int[] dif = myron.differenceImage();
  loadPixels();
  arraycopy(myron.image(), pixels);
//  arraycopy(dif, pixels);
  int granularity = 24;
  for(int x = 0; x < width-granularity; x += granularity) {
    for(int y = 0; y < height-granularity; y += granularity) {
      int c = dif[(y+(int)random(granularity))*width+(x+(int)random(granularity))];
      if(brightness(c) > .2) {
        particles.add(new Particle(x, y, hue(c)));
//        if(particles
      }
    }
  }
//  println("b: "+brightness(pixels[mouseY*width+mouseX]));
  updatePixels();
  println(particles.size());
//  if(particles.size() > 0) {
//    Iterator i = particles.iterator();
//    for(Particle p = (Particle) i.next(); i.hasNext(); ) {
//      p.run();
//      p.draw();
//    }
    for(int i = 0; i < particles.size(); i++) {
      Particle p = (Particle) particles.get(i);
      p.run(null);
      p.draw();
    }
//  }
}
