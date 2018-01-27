 
import traer.physics.*; 
import beads.*; 
 
 
AudioContext ac; 
ArrayList carrierFreqs; 
ArrayList modFreqRatios; 
ArrayList panners; 
 
Particle selectedParticle = null; 
 
boolean initialized = false; 
boolean frozen = false; 
 
int frameMousePressed =0; 
 
ParticleSystem ps = new ParticleSystem(); 
 
void setup() { 
  background(0); 
  ac = new AudioContext(); 
  size(400,400); 
  colorMode(HSB,100); 
  background(0); 
  smooth(); 
  frameRate(30); 
    strokeWeight(.5); 
    stroke(100);   
   
  carrierFreqs = new ArrayList(); 
  modFreqRatios = new ArrayList(); 
  panners = new ArrayList(); 
     
} 
 
void drawParticles() { 
  for(int i=0; i<ps.numberOfParticles(); i++) { 
    Particle p = ps.getParticle(i); 
    float mass = p.mass(); 
    noStroke(); 
    // HSB based on X,Y,Z 
    float br = map(sin(frameCount/mass + PI), -1, 1, 60, 95); 
    float ra = map(sin(frameCount/mass), -1, 1, mass, mass * 2); 
    fill( color( p.position().x(), p.position().y(), br ) , 15); 
    ellipse(width * (p.position().x() / 100),  height * (p.position().y() / 100), ra, ra); 
     
    if(p.isFixed()) { 
      fill(0,50); 
      ellipse(width * (p.position().x() / 100),  height * (p.position().y() / 100), 2,2); 
    } 
     
    Glide cf = (Glide)carrierFreqs.get(i); 
    Glide mfr = (Glide)modFreqRatios.get(i); 
    PanMonoToStereo pan = (PanMonoToStereo)panners.get(i); 
     
    /* update values */ 
    cf.setValue(map(width * (p.position().x()/100),0,width,30,600));//((float)p.position().x() / width * 500 + 50) % 20); 
    mfr.setValue(map(height * (p.position().y()/100),0,height,.1,2));//(1 - (float)p.position().y() / height) * 10 + 0.1); 
    pan.getPanEnvelope().setValue(map(p.position().x(),0,100,1,0)); 
  } 
 
} 
 
void drawSprings() { 
  stroke(25); 
  strokeWeight(.5); 
  for(int i=0; i<ps.numberOfSprings(); i++) { 
    Spring s = ps.getSpring(i); 
    Particle p1 = s.getOneEnd(); 
    Particle p2 = s.getTheOtherEnd(); 
    line(width * (p1.position().x() / 100), height * (p1.position().y() /100), 
         width * (p2.position().x() / 100), height * (p2.position().y() /100)); 
  } 
} 
 
void drawGas() { 
  scale(1.5); 
  fill(100,1); 
  beginShape(); 
  for(int i=0; i<ps.numberOfParticles()-1; i++) { 
    Particle p0 = ps.getParticle(i); 
    Particle p1 = ps.getParticle(i+1); 
    curveVertex(width*(p0.position().x()/100), height *( p0.position().y()/100)); 
  } 
  endShape(CLOSE); 
} 
 
void drawThread() { 
  int nop = ps.numberOfParticles(); 
  if(nop < 4) return; 
  for(int i=0; i<nop; i++) { 
 
    Particle p0 = ps.getParticle(i%nop); 
    Particle p1 = ps.getParticle((i+1)%nop); 
    Particle p2 = ps.getParticle((i+2)%nop); 
    Particle p3 = ps.getParticle((i+3)%nop); 
 
    color c0 = color( p1.position().x(), p1.position().y(), p1.position().z() ); 
    color c1 = color( p2.position().x(), p2.position().y(), p2.position().z() ); 
    color c2 = lerpColor(c0, c1, noise(frameCount)); // interpolate between the two colors 
    c2 = color(hue(c2), saturation(c2)/2, brightness(c2)); 
 
     
    strokeWeight(1); 
    stroke(c2, 50); 
    noFill(); 
    curve(width * (p0.position().x() /100), height * (p0.position().y()/100), 
          width * (p1.position().x() /100), height * (p1.position().y()/100), 
          width * (p2.position().x() /100), height * (p2.position().y()/100), 
          width * (p3.position().x() /100), height * (p3.position().y()/100)); 
  } 
    
} 
 
void draw() { 
  ///////// erase old 
  fill(0,.1); 
  noStroke(); 
  rect(0,0,width,height); 
  filter(BLUR, 1); 
   
//  drawSprings(); 
//  drawGas(); 
  drawThread(); 
  drawParticles(); 
 
  if(!frozen) ps.tick(); 
  //checkBounds(); 
  curveTightness( map ( noise(frameCount*.001), 0, 1, -5, 5)); 
 
} 
 
float wrap(float val, float mn, float mx) { 
  return max(mn, min(val, mx)); 
} 
 
void checkBounds() { 
  for(int i=0; i<ps.numberOfParticles(); i++) { 
    Particle p = ps.getParticle(i); 
    float x = p.position().x(); 
    float y = p.position().y(); 
    float z = p.position().z(); 
    //x = wrap(x, 0, 100); 
    //y = wrap(y, 0, 100); 
    x = max(0, min(x, 100)); 
    y = max(0, min(y, 100)); 
    z = max(0, min(z, 100)); 
    p.position().set(x,y,z); 
  } 
} 
 
/* only called on particle add, so using slow/naive method */ 
Particle findNearestParticle(float x, float y) { 
  float closestDistance = 1000000; 
  int closestIndex = 0; 
  for(int i=0; i < ps.numberOfParticles(); i++) { 
    Particle p = ps.getParticle(i); 
    float d = dist(width * (p.position().x()/100), height*(p.position().y()/100), x, y); 
    if(d < closestDistance) { 
      closestDistance = d; 
      closestIndex = i; 
    } 
  } 
  return ps.getParticle(closestIndex); 
} 
 
/* 
******************************************** 
* INTERACTIVE FUNCTIONS 
* 
*/ 
 
void mousePressed() { 
  frameMousePressed = frameCount; 
  if(key == CODED) { 
    if(keyCode == SHIFT) { 
      Particle p = findNearestParticle(mouseX, mouseY); 
      if(p.isFixed()) p.makeFree(); 
      else p.makeFixed(); 
    } 
    else if(keyCode == ALT) { 
      selectedParticle = findNearestParticle(mouseX, mouseY); 
    } 
  } 
} 
 
void mouseReleased() { 
  if(key == CODED) { 
     if(keyCode == SHIFT) return; // we were freezing a point, don't add a new one 
     else if(keyCode == ALT) { 
       if(selectedParticle != null) { 
          selectedParticle.position().set(((mouseX*1.0)/width)*100, ((mouseY*1.0)/height)*100, 70); 
       } 
     } 
  } 
  else {   
    addParticle(mouseX,mouseY,frameCount - frameMousePressed + 1); 
    createNoisemaker(mouseX,mouseY,frameCount - frameMousePressed + 1);   
  } 
} 
 
void addParticle(int x, int y, int sz) { 
  Particle p2=null; 
  if(ps.numberOfParticles() >= 1) { 
    p2 = findNearestParticle(((x*1.0)/width)*100, ((y*1.0)/height)*100); 
  } 
  Particle p0 = ps.makeParticle(sz, ((x*1.0)/width)*100, ((y*1.0)/height)*100, 70); 
 
   
  // adding repulsions to all other particles  
  for(int i=0; i<ps.numberOfParticles(); i++) { 
    Particle p1 = ps.getParticle(i); 
    if(p0 != p1) { 
      ps.makeAttraction(p0, p1, -3, 0); 
    } 
  } 
   
   
  if(ps.numberOfParticles() >= 2) { 
    // strength, dampening, rest length 
    ps.makeSpring(p2, p0, .1, .1, 25); 
  } 
   
} 
 
 
 
void createNoisemaker(float x, float y, float sz) { 
  sz = max(3, min(sz,100)); 
  Glide cf = new Glide(ac, 500); 
  carrierFreqs.add(cf);  // save a reference for later 
  Glide mfr = new Glide(ac, 1); 
  modFreqRatios.add(mfr); 
    
  Function modFreq = new Function(cf, mfr) { 
    public float calculate() { 
      return x[0] * x[1]; 
    } 
  }; 
  WavePlayer freqModulator = new WavePlayer(ac, modFreq, new SineBuffer().getDefault()); 
 
  Function carrierMod = new Function(freqModulator, cf) { 
    public float calculate() { 
      return x[0] * 300.0 + x[1];     
    } 
  }; 
   
  WavePlayer wp = new WavePlayer(ac, carrierMod, new SineBuffer().getDefault()); 
  Gain g = new Gain(ac, 1, map(sz,0,100,0,1)); // more massive particles are louder 
   
  PanMonoToStereo pan = new PanMonoToStereo(ac, new Envelope(ac, 0.5)); // not working? 
  panners.add(pan); 
   
  g.addInput(wp); 
  pan.addInput(g); 
   
  ac.out.addInput(pan); 
  if(! initialized) { 
    ac.start();  // only start it once 
    initialized = true; 
    println("started"); 
  } 
} 
 
 
void keyPressed() { 
  if(key == 'f') { 
    frozen = !frozen; 
  } 
} 
