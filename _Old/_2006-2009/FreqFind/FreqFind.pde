int note = 60;
float freq = 220; //A2
static final float noteJump = pow(2, 1.0/12);
int x;
PFont f;
String[] notes = new String[128];

void setup() {
  size(700, 300);
  x = width*note/notes.length;
  rectMode(RADIUS);
  smooth();
  f = loadFont("AbadiMT-Condensed-20.vlw");
  textFont(f, 25);
  textAlign(CENTER, BOTTOM);
  int octave = -4;
  String s = "A#BC#D#EF#G#";
  for(int a = 0; a < notes.length; a++) {
    String temp = s.substring(a%12, a%12+1);
    if(temp.equals("A")) octave++;
    else if(temp.equals("#")) {
      temp = s.substring(a%12-1, a%12)+temp;
    }
    notes[a] = temp+String.valueOf(octave);
  }
}

void mouseDragged() {
  int noteNew = (int)map(constrain(mouseX, 0, width), 0, width, 0, 127);
  x = mouseX;
  if(note < noteNew)
    while(note != noteNew) {
      freq *= noteJump;
      note++;
    }
  else
    while(note != noteNew) {
      freq /= noteJump;
      note--;
    }
}

void keyPressed() {
  if(key=='f' | key=='F')
    println(getNote()+": "+freq);
}

void draw() {
  background(color(0));
  stroke(color(255));
  fill(color(255));
  line(0, height/2, width, height/2);
  rect(x, height/2, 6, 11);
  text(getNote(), x, height/2-(int)(11+10));
  text(freq, x, height/2+(int)(11+29));
}

String getNote() {
  return notes[note];
}
