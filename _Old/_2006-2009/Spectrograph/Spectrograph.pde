import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

float val;

Minim m;
AudioInput in;
AudioRecorder recorder;
FFT fft;

void setup() {
  size(800, 600);
  m = new Minim(this);
  in = m.getLineIn(Minim.STEREO, 1024);
  recorder = m.createRecorder(in, "temp.wav", true);
  fft = new FFT(1024, 44100);
//  fft.logAverages(11, 12);
//  println(fft.specSize());
  stroke(255);
  fill(255);
  background(0);
}

//int size = 15;

int x = 0;

int colorFor(float val) {
  float r = 255-val,
      g = val-25,
      b = val-475;
      return color(r, g, b);
}

boolean a = true;
float[] buffReal = new float[1024], buffImag = new float[1024];

//the logarithmic spectrograph will span 10 octaves
void draw() {
//   fft.window(FourierTransform.HAMMING);
   fft.forward(buffReal, buffImag);
   for(int i = 0 ; i < buffReal.length; i++) {
     in.mix[i] = dist(0, 0, buffReal[i], buffImag[i]);
   }
   for (int i = 1; i < height; i++)
   {
     float freq = freqFor(height-i);
     if(a) println(freq);
     stroke(color(colorFor(fft.getFreq(freq)*50)));
     point(x, i);
   }
   a = false;
   x = (x+1)%width;
   stroke(0);
   line(x, 0, x, height);
}

float freqFor(float coord) {
  float mult = 22100.0/1024;
  float input = coord/height*10;
  float out = pow(2, input)*mult;
  return out;
}

float change(float[] array) {
  float change = 0;
  for(int a = 1; a < array.length; a++) {
    change += abs(array[a]-array[a-1]);
  }
  return change;
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  m.stop();
//  recorder.close();
  super.stop();
}
