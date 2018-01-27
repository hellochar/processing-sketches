import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioOutput out;
SquareWave square;
SineWave sine;
TriangleWave tri;

float freq;
String time = "23:25";
int minute = Integer.parseInt(time.substring(time.indexOf(':')+1));
int hour = Integer.parseInt(time.substring(0, time.indexOf(':')));
public static final float TRITONE = sqrt(2),
                          HALFSTEP = pow(2, 1.0/12);

float amp = .02;

void setup() {
  size(512, 200);
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  square = new SquareWave(1, amp, out.sampleRate());
  sine = new SineWave(1, amp, out.sampleRate());
  tri = new TriangleWave(1, amp, out.sampleRate());
  setFreq(1000);
  textFont(createFont("Arial", 25));
  textAlign(LEFT, TOP);
}

void setFreq(float freq) {
  this.freq = freq;
  square.setFreq(freq);
  sine.setFreq(freq * TRITONE);
  tri.setFreq(freq * TRITONE * sqrt(TRITONE));
}

boolean k = false;

int lastSec = 0;

void draw() {
  background(0);
  stroke(255);
  fill(255);
  if(!k && (hour() == hour) && (minute() == minute) ) {
    k = true;
    out.addSignal(square);
//    out.addSignal(sine);
//    out.addSignal(tri);
  }
  if(k && second() != lastSec ) {
    lastSec = second();
    setFreq(freq * HALFSTEP);
//      setFreq(map(sin(millis() * TWO_PI / 1000 / 45), -1, 1, 50, 10000));
    }
}

void stop() {
  out.close();
  minim.stop();
  super.stop();
}
