//freq <-- 1-to-1 -> key index
//Name <-- many-to-1 --> key index and freq
public final static int BASE_KEY_INDEX = 13;
public final static float BASE_KEY_FREQ = 55;

//Get the frequency of a key index by jumping from a "base" note
float keyIndexToFreq(int keyIndex) {
  //key 13 is freq 55
  int offset = keyIndex - BASE_KEY_INDEX; //use the 13th note as the base; it's an A1 with a frequency of 55 Hz
  return BASE_KEY_FREQ * pow(2.0, offset / 12f);
}

float ln2 = log(2);
float freqToKeyIndex(float freq) {
  //slightly more tricky
  float index = BASE_KEY_INDEX + 12 * log(freq/BASE_KEY_FREQ)/ln2; //convert to base 2
  return index;
}

final String[] noteNames = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
String keyIndexToName(int keyIndex) { //Always picks sharps over flats. 
  //C2 = 16, C#2 = 17, D2 = 18, D#2 = 19, E2 = 20, F2 = 21, F#2 = 22, G2 = 23, G#2 = 24, A2 = 25, A#2 = 26, B2 = 27, C3 = 28

  int pci = (keyIndex + 8) % 12; //a KI of 16 (a C2) is a pitch class index (PCI) of 0. The same is true for any C.
  if(pci < 0) throw new RuntimeException("Uh oh, we've got a pci of "+pci+" for a KI of "+keyIndex+"!");
  
  //0 = "", 1 = "#",  2 = "",  3 = "#",  4 = "",  5 = "",  6 = "#",  7 = "",  8 = "#", 9 = "", 10 = "#", 11 = ""  <-- which PCI's should be sharped
  //1, 3, 6, 8, 10.
  
  //0th octave = -10 to 3, 1st octave = 4 to 4+1*12-1, 2nd octave = 4+1*12 to 4+2*12-1, 3rd octave = 4+2*12 to 4+3*12-1
  int octave = floor((keyIndex - 4) / 12f); //keyIndex + 8 will be 12 when KI = 4, and 23 when KI = 15.
  //todo: for some reason i have to say KI - 4 (it used to be KI + 8; at least, that's how I logiced it. Should probably run over it again.)
  
  String name = noteNames[pci]+""+octave;
  return name;
}

//the reverse of keyIndexToName.
int nameToKeyIndex(String name) {
  String pcName = name.substring(0, name.length()-1); //only get the pitch class part
  int octave = int(name.substring(name.length()-1)); //get the octave
  
  int pci = -1; //traverse the notenames to find the PCI
  for(int i = 0; i < noteNames.length; i++) {
    if(pcName.equals(noteNames[i])) { pci = i; break; }
  }
  if(pci < 0) throw new RuntimeException("Couldn't find a pitch class that equals "+pcName+" for name "+name+"!");
  
  return octave * 12 + pci;
}
