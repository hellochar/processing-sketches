import JMyron.*;

int[] nextBuffer;
int[][] dif;
int q = 0, p = 1;

float lowB = 5, highB = 160;

JMyron myron;
void setup() {
  size(640, 480);
  myron = new JMyron();
  myron.start(width, height);
//  myron.sensitivity(2);
  myron.adaptivity(16);
  dif = new int[2][width*height];
  
  nextBuffer = new int[width*height];
  background(black);
  loadPixels();
  arraycopy(pixels, nextBuffer);
  updatePixels();
}

int[] pix;

void draw() {
  myron.update();
  if(frameCount < 50) 
    myron.adapt();
  loadPixels();
  dif[q] = myron.differenceImage();
  pix = myron.image();
  for(int i = 0; i < pixels.length; i++) {
    float b = brightness(dif[q][i]);
    if(b < highB) {
      if(b > lowB && brightness(dif[p][i]) < b) {
        int e = elementForBrightness(b);
        if(e != brick && e != uber && e != glass && e != sand)
          pixels[i] = e;
      }
      else if(findIndexOfElement(pixels[i]) == -1) pixels[i] = pix[i];
    }
    else {
      pixels[i] = pix[i];
    }
  }
  step();
  updatePixels();
  println(frameRate);
  if(q == 1) {
    q = 0; p = 1;
  }
  else {
    q = 1; p = 0;
  }
}

int elementForBrightness(float b) {
  int k = (int)map(b, lowB, highB, 0, elementsIndex.length);
  int el = elementsIndex[k];
  switch(el) {
    
    
    case fire:
      el = water;
      break;
    case water:
      el = mud;
      break;
    case mud:
      el = fire;
      break;
      
      
//    case water:
//      el = dirt;
//      break;
//    case dirt:
//      el = water;
//      break;
      
      
    case plant:
      el = sand;
      break;
    case sand:
      el = plant;
      break;
  }
  return el;
}
