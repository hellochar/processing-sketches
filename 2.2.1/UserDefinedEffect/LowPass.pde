class LowPass implements AudioEffect {
  
  float freq = 2000;
  
  FFT fft = new FFT(groove.bufferSize(), groove.sampleRate());
  
  void process(float[] samp)
  {
    fft.forward(samp);
    for(int i = 0; i <= fft.freqToIndex(freq); i++) {
      fft.setBand(i, 0);
    }
    fft.inverse(samp);
//    arraycopy(samp, lastSamp);
  }
  
  void process(float[] left, float[] right)
  {
    process(left);
    process(right);
  }
}
