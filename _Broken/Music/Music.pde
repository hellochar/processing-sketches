import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

float semi = pow(2.0, 1.0/12);
int MAJOR = 1, MINOR = 2;
int mode = MAJOR;
int[] scaleOffset = new int[] {0, 2, 4, 5, 7, 9, 11};

Minim minim;
AudioOutput out;


void setup() {
  size(500, 500);
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO, 2048);
}

void mousePressed() {
  if(A4.playing) { A4.stop(); } 
  else A4.play();
}

void draw() {
  A4.update();
//  println("frameRate: "+frameRate);
}

void stop() {
  out.close();
  
  minim.stop();
  super.stop();
}
