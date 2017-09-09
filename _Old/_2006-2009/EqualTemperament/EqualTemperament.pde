import ddf.minim.*;
import ddf.minim.signals.*;

AudioOutput out;
Oscillator s;

float freq = 220;

char[] offset = {'q', 'a', 'w', 's', 'e', 'd', 'r', 'f', 't', 'g', 'y', 'h', 'u', 'j', 'i', 'k', 'o', 'l', 'p', ';', '[', '\'', ']'};
int middle = offset.length/2;

void setup() {
  size(500, 500);
  
  Minim.start(this);
  
  out = Minim.getLineOut(Minim.STEREO);
  s = new SineWave(freq, .5, 44100);
  s.portamento(120);
  out.addSignal(s);
  out.mute();
}

int next = 40;

void draw()
{
  background(0);
  stroke(255);
  println(frameRate);
}

void keyPressed() {
  for(int a = 0; a < offset.length; a++) {
    if(key == offset[a]) {
      s.setFreq(freq*pow(2, (a-middle)/12f));
    }
  }
  if(key == 'z') {
    freq /= 2;
  }
  else if(key == 'x') {
    freq *= 2;
  }
}

void stop()
{
  out.close();
  super.stop();
}
