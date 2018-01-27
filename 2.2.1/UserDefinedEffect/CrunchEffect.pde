
class CrunchEffect implements AudioEffect
{
  
  float wet = 1;
  float gain = 2; // in dB
  
//  int bits = 16;
//  //the number of bits this crunch effect outputs. At 1 bit, there will only be 2 states - completely on (floats holding a "1") or completely off (floats holding a "0")
//  //At 2 bits, there are 4 states (0, 
//  //At 3 bits, there are 8 states
//  //etc. etc. etc.
//  //floats have about 6 digits of precision, or 10^6 total states. That translates into log2(10^6)=6log2(10), or about 6*3.1 = 19 bits. In reality we won't hear a difference until (idk yet)

  int states = 4; //this does not include the "0" state.
  
  void process(float[] samp)
  {
    for(int i = 0; i < samp.length; i++) {
      float gained = pow(10, (gain/10))*samp[i];
      float crunched = (float)floor(states*gained+.5f)/states;
      if(i == 0) {
//        println(states+" states: signal is at "+states*gained+", the "+floor(states*gained)+" state!crunched "+gained+" to "+crunched+"! ("+1f/states+")");
      }
      samp[i] = wet*crunched + (1-wet)*samp[i];
    }
//    arraycopy(samp, lastSamp);
  }
  
  void process(float[] left, float[] right)
  {
    process(left);
    process(right);
  }
}

