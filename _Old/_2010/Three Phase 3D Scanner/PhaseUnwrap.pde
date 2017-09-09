/*
  Takes the amplitudes of three out of phase sine waves
  and determines the unique angle determined by those amplitudes.
*/

float phaseUnwrap(float phase1, float phase2, float phase3) {
  boolean flip;
  int off;
  float maxPhase, medPhase, minPhase;
  if(phase1 >= phase3 && phase3 >= phase2) {
    flip = false;
    off = 0;
    maxPhase = phase1;
    medPhase = phase3;
    minPhase = phase2;
  } else if(phase3 >= phase1 && phase1 >= phase2) {
    flip = true;
    off = 2;
    maxPhase = phase3;
    medPhase = phase1;
    minPhase = phase2;
  } else if(phase3 >= phase2 && phase2 >= phase1) {
    flip = false;
    off = 2;
    maxPhase = phase3;
    medPhase = phase2;
    minPhase = phase1;
  } else if(phase2 >= phase3 && phase3 >= phase1) {
    flip = true;
    off = 4;
    maxPhase = phase2;
    medPhase = phase3;
    minPhase = phase1;
  } else if(phase2 >= phase1 && phase1 >= phase3) {
    flip = false;
    off = 4;
    maxPhase = phase2;
    medPhase = phase1;
    minPhase = phase3;
  } else {
    flip = true;
    off = 6;
    maxPhase = phase1;
    medPhase = phase2;
    minPhase = phase3;
  }
  float theta = 0;
  if(maxPhase != minPhase)
    theta = (medPhase-minPhase) / (maxPhase-minPhase);
  if (flip)
    theta = -theta;
  theta += off;
  return theta / 6;
}
