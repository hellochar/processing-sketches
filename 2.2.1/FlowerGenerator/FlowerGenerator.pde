import traer.physics.*;
 
ParticleSystem PS = new ParticleSystem(0.0, 0.5);
int pcount = 400;
int ring_radius = 135;
Particle[] Ring = new Particle[pcount];
Spring[] Innersprings = new Spring[pcount*2]; // two springs per particle
Spring[] Rim = new Spring[pcount];
float spokeStrength = 0.008;
float spokeDamping = 0.0;
float rimDamping = 0.01;
float rimStrength = 1.0;
float innerspring_length = ring_radius*2.5;
float z=0; // increment this as the shape draws
int h=0; // random hue value
 
void setup(){
  size(600,600);
  background(255);
  smooth();
  colorMode(HSB,255);
  h = int(random(255));
  buildParticles(PS);
}
 
void draw(){
  PS.tick();
  translate(height/2,width/2);
  strokeWeight(2);
  stroke((h+(z*0.03))%255,255-(z*0.1),z*0.15,40);
  fill(255);
  // draw the ring
  beginShape();
  for (int p=0; p<pcount; p++){
    vertex(Ring[p].position().x(),Ring[p].position().y());
  }
  endShape(CLOSE);
  // now shorten the springs
  for (int s=0; s<pcount; s++){
    int spr = int(random(pcount)); // note we only shorten half the springs (the first half)
    Innersprings[spr].setRestLength(Innersprings[spr].restLength() - random(0,1));
 }
  z++;
}
 
 
void buildParticles(ParticleSystem P){
  for (float i=0; i<pcount; i++){ // makes the particles
    Ring[int(i)] = P.makeParticle(1.0,sin(TWO_PI*(i/pcount))*ring_radius,cos(TWO_PI*(i/pcount))*ring_radius,0);
  }
  float segmentlength = (TWO_PI*ring_radius)/float(pcount); // segment length
   
  for (int i=0; i<pcount; i++){
    Innersprings[i] =  P.makeSpring(Ring[i], Ring[int(random(pcount))],spokeStrength, spokeDamping, innerspring_length); // 2 random springs
    Innersprings[i+pcount] =  P.makeSpring(Ring[i], Ring[(i+int(random(pcount)))%pcount], spokeStrength, spokeDamping, innerspring_length); // between each point and 2 others
    if (i < pcount-1) {
      Rim[i] = P.makeSpring(Ring[i],Ring[i+1],rimStrength, rimDamping,segmentlength);
    }
    else { // join the last rim particle back to the first
      Rim[i] = P.makeSpring(Ring[i],Ring[0],rimStrength, rimDamping, segmentlength);
    }
  }
}
 
void keyPressed(){
    buildParticles(PS);
    h = int(random(255));
    background(255);
    z = 0;
}

