public final Note A4 = new Note(440);
public final Map<String, Integer> pitchClassMap = new HashMap();
{
  pitchClassMap.put("C", 0);
  pitchClassMap.put("D", 2);
  pitchClassMap.put("E", 4);
  pitchClassMap.put("F", 5);
  pitchClassMap.put("G", 7);
  pitchClassMap.put("A", 9);
  pitchClassMap.put("B", 11);
}

//todo: there is a bug. getoffsetfroma4(A4) returns an nthkey of 57. http://en.wikipedia.org/wiki/Piano_key_frequencies
int getOffsetFromA4(String name) {
   //eg C#4 or something
  //A4 is 440 hertz (the 49th piano key), interpolate from there
  int nthKey;
  nthKey = Integer.valueOf(""+name.charAt(name.length()-1))*12; //a C4 is middle C
  String pitchClass = name.substring(0, 1).toUpperCase();
  nthKey += pitchClassMap.get(pitchClass);
  println("nthKey: "+nthKey+", pitch class: "+pitchClass);
  if(pitchClass.contains("#"))
    nthKey++;
  else if(pitchClass.contains("b"))
    nthKey--;
  return nthKey-49;
}
  
  Note n = new Note("A4");
  
class Note {
  final float freq;
  DecayOscillator osc;
  float startAmp = 1f,
        dbPercentPerSec = .1;
  long timeStarted;
  boolean playing = false;
  
  Note(float freq) {
    this.freq = freq;
  }
  
  Note(Note parent, int semitones) {
    this(parent.freq * pow(2, semitones / 12f));
  }
  
  Note(String name) {
    this(A4, getOffsetFromA4(name));
    println("Offset: "+getOffsetFromA4(name));
    println(name+": "+freq); 
  }
  
  void play() {
    if(osc == null) {
      osc = new DecayOscillator(this);
    }
    if(!playing) {
      timeStarted = millis();
      out.addSignal(osc);
      playing = true;
    }
  }
  
  void stop() {
    if(playing) {
      out.removeSignal(osc);
      playing = false;
    }
  }
  
  float log10 (float x) {
    return (log(x) / log(10));
  }

  void update() {
    if(playing) {
      //SPL (dB) is defined as a logarithmic measure of the sound intensity, in comparison to a reference level.
      //L1 = 10 * log_10 (I_1 / I_0) dB, where
      //I_1 and I_0 are the intensities. I_0 is usually the standard reference sound intensity 10^-12 W/m. 
      //Sound intensities are directly proportional to the amplitude of the oscillator. A change of sound intensity from 1 W/m to .1 W/m (that is, 1 amp to .1 amp) corresonds to
      //an SPL change from 120 dB to 110.
      //In this case, I'm taking I_0 as the amplitude 10^-12 -> dB = 10 * log_10(amplitude*10^12) -> dB = 120 + 10*log_10(amplitude). An amplitude of 1 is a dB of 120. .1 amp = 110 dB.
      //then, amp = 10 ^ ((dB - 120) / 10)
      float elapsed = (millis() - timeStarted) / 1000f;
      float startDB = 120 + 10 * log10(startAmp);
      float curDB = startDB * pow(1 - dbPercentPerSec, elapsed);
      float amp = pow(10, (curDB - 120) / 10);
      osc.setAmp(amp);
      println("elapsed: "+elapsed+", start: "+startDB+", Set DB to "+curDB+" and amp to "+amp+"!");
    }
  }
  
  void setDecay(float decay) {
    dbPercentPerSec = decay;
  }
}
