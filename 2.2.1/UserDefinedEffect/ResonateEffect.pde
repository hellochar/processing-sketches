

//todo: DO it!
class ResonateEffect implements AudioEffect
{
//  float wet = .5;
//  float feedback = .2;
  
  float millis = 20;
  float[] buffer = new float[(int)(groove.sampleRate() * millis / 1000)];

  float lowPass = 1000;
  
  FFT fft = new FFT(buffer.length, groove.sampleRate());
  
  void process(float[] samp)
  {
    fft.forward(buffer);
    
    for(int i = fft.freqToIndex(lowPass)+1; i < groove.bufferSize()/2; i++) {
      //todo: WTF?!
      throw new RuntimeException();
    }
    arraycopy(buffer, samp.length, buffer, 0, buffer.length-samp.length);
    arraycopy(samp, 0, buffer, buffer.length-samp.length, samp.length);
  }
  
  void process(float[] left, float[] right)
  {
    process(left);
    process(right);
  }
}

