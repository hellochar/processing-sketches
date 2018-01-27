
import ddf.minim.*;
import ddf.minim.signals.*;

int string, fret;
static final float halfStep = pow(2, 1.0/12);
static final float baseFreq = 164.81375/2  ; //Frequency for E1
String[] names = {"E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B", "C", "C#/Db", "D", "D#/Eb"};
String strName;
boolean next = false;
AudioOutput out;
Oscillator sine;
int timer = 0;

void setup() {
  size(500, 500);
  textFont(createFont("Arial", 20, true));
  generateQuestion();
  textAlign(LEFT, TOP);
  background(0);
  Minim.start(this);
  out = Minim.getLineOut(Minim.STEREO, 512);
  sine = new TriangleWave(0, .5, 44100);
  out.addSignal(sine);
  out.noSound();
}

void stop()
{
  out.close();
  super.stop();
}

void generateQuestion() {
  string = (int)random(1, 3);
  if(string == 1) {
    strName = "E";
  }
  else {
    strName = "A";
  }
  fret = (int)random(0, 12);
}

void draw() {
    text(strName+", "+fret, 0, 0);
    if(next) {
      timer = (timer+1)%60;
      sine.setAmp(map(timer, 0, 60, 1, -1));
      text(sine.frequency(), 140, 0);
    }
}

void mousePressed() {
  if(!next) {
  int z = 0;
  float freq = baseFreq;
  for(int a = 0; a < 12; a++) {
    if(names[a].equals(strName)) {
      z = a;
      break;
    }
  }
  int k = z+fret;
  freq *= pow(halfStep, k);
  text(names[k%12], 80, 0);
  next = true;
  sine.setFreq(freq);
  out.sound();
  timer = 0;
  }else {
    out.noSound();
    background(0);
    next = false;
    generateQuestion();
  }
}
