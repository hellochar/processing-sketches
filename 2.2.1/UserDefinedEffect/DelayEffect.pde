
class DelayEffect implements AudioEffect
{
  float wet = .5;
  float feedback = .2;
  
  float millis = 200;
  float[] buffer = new float[(int)(groove.sampleRate() * millis / 1000)];
  int filledIndex = 0;
  
  void process(float[] samp)
  {
    for(int i = 0; i < samp.length; i++, filledIndex = (filledIndex + 1)%buffer.length) {
      float orig = (1-wet)*samp[i];
      float contrib = wet*buffer[filledIndex];
      samp[i] = contrib + orig;
      buffer[filledIndex] = orig+feedback*contrib;
    }
//    arraycopy(samp, lastSamp);
  }
  
  void process(float[] left, float[] right)
  {
    process(left);
    process(right);
  }
}

