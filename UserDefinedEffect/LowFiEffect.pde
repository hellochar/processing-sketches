//A sample rate reduction effect.

class LowFiEffect implements AudioEffect
{

  float wet = 1;
  int newRate = 10000; //number of samples to send per second.
  float microsecondsElapsed = 0,
        nextMicroseconds = 0;
  private float signal = 0;
  
  void process(float[] samp)
  {
    float microsecondsPerOldSample = 1e6 / groove.sampleRate(); //at 44.1 kHz, this value is about 22.676
//    float microsecondsElapsed = 0;
    for(int i = 0; i < samp.length; i++) {
      if(microsecondsElapsed >= nextMicroseconds) {
        signal = samp[i];
        nextMicroseconds += microsecondsPerNewSample();
      }
      microsecondsElapsed += microsecondsPerOldSample;
      
      samp[i] = wet*signal + (1-wet)*samp[i];
    }
  }
  
  float maxFreq() {
    return newRate / 2f;
  }
  
  float microsecondsPerNewSample() {
    return (float)1e6 / newRate;
  }
  
  void process(float[] left, float[] right)
  {
    process(left);
    process(right);
  }
}

