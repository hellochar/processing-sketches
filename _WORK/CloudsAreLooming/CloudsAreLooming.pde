import peasy.*;
import toxi.geom.*;
 
Vec3D globalOffset, avg, cameraCenter;
public float neighborhood, viscosity, speed, turbulence, cameraRate, rebirthRadius, spread, independence, dofRatio;
public int n, rebirth;
public boolean averageRebirth, paused;
Vector<Particle> particles;
 
Plane focalPlane;
 
PeasyCam cam;
 
boolean recording;
 
void setup() {
  size(720, 480, P3D);
  cam = new PeasyCam(this, 1600);
   
  setParameters();
  makeControls();
   
  cameraCenter = new Vec3D();
  avg = new Vec3D();
  globalOffset = new Vec3D(0, 1. / 3, 2. / 3);
   
  particles = new Vector();
  for(int i = 0; i < n; i++)
    particles.add(new Particle());
}
 
void draw() { 
  avg = new Vec3D();
  for(int i = 0; i < particles.size(); i++) {
    Particle cur = ((Particle) particles.get(i));
    avg.addSelf(cur.position);
  }
  avg.scaleSelf(1. / particles.size());
   
  cameraCenter.scaleSelf(1 - cameraRate);
  cameraCenter.addSelf(avg.scale(cameraRate));
   
  translate(-cameraCenter.x, -cameraCenter.y, -cameraCenter.z);
   
  float[] camPosition = cam.getPosition();
  focalPlane = new Plane(avg, new Vec3D(camPosition[0], camPosition[1], camPosition[2]));
 
  background(0);
  noFill();
  hint(DISABLE_DEPTH_TEST);
  for(int i = 0; i < particles.size(); i++) {
    Particle cur = ((Particle) particles.get(i));
    if(!paused)
      cur.update();
    cur.draw();
  }
   
  for(int i = 0; i < rebirth; i++)
    randomParticle().resetPosition();
   
  if(particles.size() > n)
    particles.setSize(n);
  while(particles.size() < n)
    particles.add(new Particle());
     
  globalOffset.addSelf(
    turbulence / neighborhood,
    turbulence / neighborhood,
    turbulence / neighborhood);
    
}
 
Particle randomParticle() {
  return ((Particle) particles.get((int) random(particles.size())));
}
 
void keyPressed() {
  if(key == 'p')
    paused = !paused;
  if(key == ' ') {
    StringBuilder b = new StringBuilder(12*6*particles.size());
    for(Particle p : particles) {
      b.append(p.toString());
      b.append('\n');
    }
    saveBytes("flock-"+nf(frameCount, 4)+".csv", b.toString().getBytes());
  }
}

