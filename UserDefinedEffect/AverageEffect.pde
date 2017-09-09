
class AverageEffect implements AudioEffect
{
  
  float decay = .5;
  float[] lastSamp = new float[groove.bufferSize()];
  
  void process(float[] samp)
  {
    for(int i = 1; i < samp.length; i++) {
//      samp[i] = constrain((1-decay)*samp[i] + decay*samp[i-1], -1, 1);
      float k = samp[i];
      samp[i] += lastSamp[i];
      lastSamp[i] = k;
    }
//    arraycopy(samp, lastSamp);
  }
  
  void process(float[] left, float[] right)
  {
    process(left);
    process(right);
  }
}
  
