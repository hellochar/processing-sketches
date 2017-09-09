float wave(float millis, float freq) {
  float time_in_seconds = millis/1000;
  float w = freq*TWO_PI;
  return sin(w*time_in_seconds); //period = 2*pi/w. w = 2pi*freq.
}

public final static float SAMPLE_RATE = 44100, //44100 samples a second.
                          MS_PER_SAMP = 1000 / SAMPLE_RATE;
float MY_FREQ = 440;`
//44.1 samples per ms
//1/44.1 ms per sample.
public final static int SAMPLE_SIZE = 2048;

float[] dft = new float[880]; //arbitrary 900; this array will hold the dft values for frequencies 0, 1, 2, ... 899. 

float millis = 0;

void setup() {
  size(dft.length, 200);
}

void draw() {
  background(0);
//  MY_FREQ = map(mouseX, 0, width, 0, 440);
  float[] samples = new float[SAMPLE_SIZE];
  for(int i = 0; i < SAMPLE_SIZE; i++) {
    float t = millis + i * MS_PER_SAMP;
    samples[i] = wave(t, MY_FREQ); //fill the sample.
    for(int freq = 0; freq < dft.length; freq++) {
      dft[freq] += samples[i]*wave(t, freq);
    }
  }
  noFill(); stroke(255, 0, 0);
  beginShape(); 
  for(int i = 0; i < SAMPLE_SIZE; i++) {
    vertex(i*width / SAMPLE_SIZE, map(samples[i], -1, 1, height, 0));
  }
  endShape();
  
  println(mouseX+", "+dft[mouseX]);
  stroke(255);
  for(int freq = 0; freq < width; freq++) {
    line(freq, height/2, freq, height/2 - dft[freq] * 1);
    dft[freq] = 0;
  }
  millis += SAMPLE_SIZE * MS_PER_SAMP;
}
