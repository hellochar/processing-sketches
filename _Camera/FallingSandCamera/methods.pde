
int bounds(int a, int l, int h) {
  return a > h ? h : a < l ? l : a;
}

int getAt(int x, int y) {
  if(y < 0 || y >= height || x < 0 || x >= width) return black;
  return pixels[y*width+x];
}

int fie;
int findIndexOfElement(int e) {
  if(e == black) return -1;
  for(fie = 0; fie < elementsIndex.length; fie++) {
    if(e == elementsIndex[fie]) return fie;
  }
  return -1;
}

int at, nbat;
int conv;
int ind;
void setAt(int mx, int my, int x, int y, int newForm) {
  if(newForm == black) {
    setBuf(x, y, black);
    return;
  }
  if(mx==x && my==y) {
    setBuf(x, y, newForm);
    return;
  }
  else if(my < 0 || my >= height || mx < 0 || mx >= width) {
    nbat = black;
  }
  else {
    nbat = nextBuffer[my*width+mx];
  }
  int nk = findIndexOfElement(nbat);
  if(newForm == nbat) return;
  if(nk == -1) {
    setBuf(x, y, nbat);
    setBuf(mx, my, newForm);
    return;
  }
//  if(nk < 0 || ind < 0) return;
//  String s = "newForm: "+hex(newForm)+", nbat: "+hex(nbat);
//  println(s+", "+nk);
  conv = convTable[findIndexOfElement(newForm)][nk];
  if(conv == swap) {
    setBuf(x, y, nbat);
    setBuf(mx, my, newForm);
  }
  else if(conv != neut) {
    setBuf(mx, my, conv);
  }
}

void setAt(int mx, int my, int newForm) {
  if(my < 0 || my >= height || mx < 0 || mx >= width)
    return;
  if(nextBuffer[my*width+mx] == black) {
    setBuf(mx, my, newForm);
    return;
  }
  int ind = findIndexOfElement(nextBuffer[my*width+mx]);
  if(ind != -1) {
    conv = convTable[findIndexOfElement(newForm)][ind];
    if(conv != neut & conv != swap)
      setBuf(mx, my, conv);
  }
}

void setAt(float mx, float my, float x, float y, int newForm) {
  setAt(int(mx), int(my), int(x), int(y), newForm);
}

void setAt(float mx, float my, int newForm) {
  setAt(int(mx), int(my), newForm);
}

int lx, ly;
void setBuf(int x, int y, int f) {
  if(x < 0 || x >= width || y < 0 || y >= height) return;
  if(f == black) nextBuffer[y*width+x] = pix[y*width+x];
  else nextBuffer[y*width+x] = f;
/*  for(lx = x-1; lx < x+2; lx++) {
    for(ly = y-1; ly < y+2; ly++) {
      if(ly*width+lx >= 0 & ly*width+lx < 400*400)
        nextChanged[ly*width+lx] = true;
    }
  }*/
}
