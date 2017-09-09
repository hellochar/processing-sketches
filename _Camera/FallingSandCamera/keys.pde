
int col = black;
int penSize = 16;

void keyPressed() {
  if(key >= '1' & key <= '9') {
    penSize = (int)pow(2, key-'1')+1;
  }
  switch(key) {
  case 'b':
    col = brick;
    break;
  case 'z':
    col = black;
    break;
  case 'f':
    col = fire;
    break;
  case 'w':
    col = water;
    break;
  case 'p':
    col = plant;
    break;
  case 's':
    col = steam;
    break;
  case 'r':
    col = fodder;
    break;
  case 'n':
    col = sand;
    break;
  case 'g':
    col = glass;
    break;
  case 'i':
    col = ice;
    break;
  case 'u':
    col = uber;
    break;
  case 't':
    col = torch;
    break;
  case 'a':
    col = waterfall;
    break;
  case 'm':
    col = mud;
    break;
  case 'd':
    col = dirt;
    break;
  default:
    break;
  }
}

