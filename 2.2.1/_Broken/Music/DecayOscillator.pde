class DecayOscillator extends SineWave {
  Note parent;
  
  DecayOscillator(Note note) {
    super(note.freq, note.startAmp, out.sampleRate());
    parent = note;
  }
  
}
