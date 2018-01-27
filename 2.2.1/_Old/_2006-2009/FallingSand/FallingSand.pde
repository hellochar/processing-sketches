PImage nextBuffer;
//boolean[] changed;

void setup() {
  size(500, 500);
  nextBuffer = createImage(width, height, RGB);
//  changed = new boolean[width*height];
  background(black);
  loadPixels();
  arraycopy(pixels, nextBuffer.pixels);
  updatePixels();
}

int black = #000000, //black = blank
brick = #BFBEB1, //brick = brick
fire = #FF0000, //fire = fire
water = #0000FF, //water = water
plant = #22FF33, //plant = plant
steam = #95EAEA, //steam = steam
fodder = #866213, //fodder = fodder
sand = #FFFF00, //sand = sand
glass = #D3CBCB, //glass = glass
ice = #FFFFFF, //ice = ice
uber = #8B27AA, //uber = uber
torch = #71130E, //torch = torch
waterfall = #5572E3, //waterfall = waterfall
mud = #996633, //mud = mud
dirt = #CC9900; //dirt = dirt

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


int x, y;
int val;
int mx, my;
int dx, dy;
int counter, counter2;
int newForm;
int enumVal;
int g;
void draw() {
  loadPixels();
  arraycopy(pixels, nextBuffer.pixels);
/*  for(int a = 0; a < pixels.length; a++) {
    if(pixels[a] != nextBuffer.pixels[a]) {
      nextBuffer.pixels[a] = pixels[a];
      changed[a] = true;
    }
  }*/
  g = 0;
  for(x = 0; x < width; x++) {
    for(y = 0; y < height; y++) {
//      if(changed[y*width+x]) {
      val = getAt(x, y);
      if(val != black) { //if there is something there, then prepare everything
//        g++;
        dy = counter = counter2 = 0;
        dx = (int)random(-2, 2);
        newForm = val;
        if(val == brick) { //brick
          dx = 0;
          //we do nothing!
        }//end of brick
        else if(val == fire) { //fire
          dy = (int)random(-5, 0); //fire wants to move up by nature
          for(mx = -1; mx < 2; mx++) {
            for(my = -1; my < 2; my++) {
              if(mx != 0 | my != 0) { //make sure it doesn't check itself
                enumVal = getAt(x+mx, y+my);
                if(enumVal != black) { //if the nearby guy isn't blank, then run away from it
                  if(enumVal == fire | enumVal == torch) {
                    counter--;
                    dx -= mx*2;
                    dy -= my*2;
                  }//end of enumVal == fire
                  else {
                    counter2--;
                    if(enumVal == water) { // if the nearby guy is water, 
                      counter++; //add one to the counter
                    }//end of enumVal == water
                  }//end of enumVal != fire
                }//end of enumVal != black
                counter2--;
              }
            }//end of moore x
          }//end of moore y
          if(counter > 0 | random(1) < .1 & (counter2 <= -8 | counter >= 5)) newForm = black;
        }//end of fire
        else if(val == water) {//water
          dy = (int)random(1, 3); //water wants to move down by nature
          for(mx = -1; mx < 2; mx++) {
            for(my = -1; my < 2; my++) {
              if(mx != 0 | my != 0) { //make sure it doesn't check itself
                enumVal = getAt(x+mx, y+my);
                if(enumVal != black) { //if there is a nearby guy and it isn't water, then run from it
                  if(enumVal == fire) { //if the nearby guy is a fire, then subtract one from the counter
                    counter++;
                    counter2++;
                  }//end of enumVal == fire
                  else if(enumVal == water) { // if the nearby guy is water, 
                    counter--; //add one to the counter
                  }//end of enumVal == water
                  else if(enumVal == plant) { //if the nearby is plant, then turn into a plant
                    newForm = plant;
                  }
                  else if(enumVal == ice && random(1) < .2) { //if the nearby is ice, then turn into ice as well
                    counter2--;
                  }
                  dx -= mx;
                  dy -= my;
                }//end of enumVal != black
              }
            }//end of moore x
          }//end of moore y
          if(newForm == plant) dx = dy = counter = counter2 = 0;
          if(counter > 0) newForm = steam;
          if(counter2 < 0) { newForm = ice; dx = dy = 0; }
        }//end of water
        else if(val == steam) {//steam
          dy = (int)random(-2); //steam wants to move up by nature
          for(mx = -1; mx < 2; mx++) {
            for(my = -1; my < 2; my++) {
              if(mx != 0 | my != 0) { //make sure it doesn't check itself
                enumVal = getAt(x+mx, y+my);
                if(enumVal != black) { //if there's something, then add one to the counter
                  counter2++; //add one to the counter for each thing nearby
                  if(enumVal == plant) counter2++;
                  if(enumVal == steam | enumVal == ice | enumVal == waterfall) {
                    counter++;
                    dy -= my;
                  }//end of enumVal == steam/ice
                  else if(enumVal == water) {
                    counter--;
                  }
                }//end of enumVal != black
              }
            }//end of moore x
          }//end of moore y
          if(random(1) < .04 & (counter2 >= 7 | counter == 8) | random(1) < .0001) //if the weight is equal to or more than 10, turn into water
            newForm = water;
        }//end of steam
        else if(val == plant) {//plant
          dx = 0; //plant stays in place
          for(mx = -1; mx < 2; mx++) {
            for(my = -1; my < 2; my++) {
              if(mx != 0 | my != 0) { //make sure it doesn't check itself
                enumVal = getAt(x+mx, y+my);
                if(enumVal == fire) { //if the nearby thing is fire, then make make myself a fire as well
                  newForm = fire;
                }//end of enumVal == fire
                else if(enumVal == plant | enumVal == fodder) {
                  counter++;
                }
                else if(enumVal == water) {
                  counter--;
                }
              }
            }//end of moore x
          }//end of moore y
          if((counter >= 5 & random(1) < .04) | random(1) < .01 & newForm != fire) newForm = fodder;
        }//end of plant
        else if(val == fodder) { //fodder
          dx = 0;
          for(mx = -1; mx < 2; mx++) {
            for(my = -1; my < 2; my++) {
              if(mx != 0 | my != 0) { //make sure it doesn't check itself
                enumVal = getAt(x+mx, y+my);
                if(enumVal == fire | enumVal == torch) { //if the nearby thing is fire, then make make myself a fire as well
                  newForm = fire;
                }//end of enumVal == fire
                else if(enumVal == water) {
                  counter++;
                }
              }
            }//end of moore x
          }//end of moore y
          if(counter >= 5 & newForm != fire | random(1) < .000002*counter) newForm = plant;
        }//end of fodder
        else if(val == sand) { //sand
          g++;
          dy = (int)random(2, 5); //sand is affected by gravity - moves down
          for(mx = -1; mx < 2; mx++) {
            for(my = -1; my < 2; my++) {
              if(mx != 0 | my != 0) { //make sure it doesn't check itself
                enumVal = getAt(x+mx, y+my);
                if(enumVal == sand) { //run away from fellow sands
                  dx -= mx;
                }//end of enumVal == sand
                else if(enumVal == fire) { //if the nearby thing is fire, then add one to the counter
                  counter++;
                }//end of enumVal == fire
              }
            }//end of moore x
          }//end of moore y
          if(counter >= 8) newForm = glass; //if there are 8 or more fires nearby, then turn into glass
        }//end of sand
        else if(val == ice) { //ice
          dx = 0;
          dy = (int)random(1, 3);
          for(mx = -1; mx < 2; mx++) {
            for(my = -1; my < 2; my++) {
              if(mx != 0 | my != 0) { //make sure it doesn't check itself
                enumVal = getAt(x+mx, y+my);
                if(enumVal != black) {
                  if(enumVal == ice) {
                    counter+=2;
                    counter2++;
                  }//end of enumVal == ice
                  else{
                    counter--;
                    dx -= mx;
                    if(enumVal == water) { //water is especially effective
                      counter--;
                    }//end of enumVal == water
                    else if(enumVal == fire) { //if the nearby thing is fire, turn into steam
                      newForm = steam;
                    }//end of enumVal == fire
                  }//end of enumVal != ice
                }//end of enumVal != black
                else counter--;
              }
            }//end of moore x
          }//end of moore y
          if(counter < -2) newForm = water;
        }//end of ice
        else if(val == uber) { //uber
//          g++;
          dy = -1;
          setAt(x, y, uber);
          setAt(x, y-1, uber);
          if(random(1) < .1) newForm = black;
        }//end of uber
        else if(val == glass) { //glass
          dx = 0;
          //glass does nothing
        }//end of glass
        else if(val == torch) { //torch
          dx = 0;
          for(mx = -1; mx < 2; mx++) {
            for(my = -1; my < 2; my++) {
              if(mx != 0 | my != 0) { //make sure it doesn't override itself
                enumVal = getAt(x+mx, y+my);
                if(enumVal == torch)
                  counter++;
                else {
                  setAt(x+mx, y+my, fire);
                }//end of enumVal != torch
              }
            }//end of moore x
          }//end of moore y
          if(random(1) < .008) newForm = fire;
        }//end of torch
        else if(val == waterfall) { //waterfall
          dx = 0;
          setAt(x-1, y, water);
          setAt(x, y+1, water);
          setAt(x+1, y, water);
        }//end of waterfall
        else if(val == mud) { //mud
          dx = 0;
          dy = 2;
          int counter3 = 0;
          for(mx = -1; mx < 2; mx++) {
            for(my = -1; my < 2; my++) {
              if(mx != 0 | my != 0) { //make sure it doesn't check itself
                enumVal = getAt(x+mx, y+my);
                counter2 = 1;
                if(enumVal != black) {
                  if(enumVal == mud) { //mud stays together
                    dx += mx;
                    dy += my;
                  } //end of enumVal == mud
                  else if(enumVal == fire) {
                    counter++;
                    counter2++;
                  }//end of enumVal == fire
                  else if(enumVal == torch) {
                    newForm = torch;
                  }//end of enumVal == torch
                  else if(enumVal == water) {
                    dx += random(-1, 1);
                  }//end of enumVal == water
                  else if(enumVal == plant) {
                    counter3++;
                  }
                }
                else counter2++;
              }
            }//end of moore x
          }//end of moore y
          if(counter > 1 | random(1) < .001*counter2)
            newForm = dirt;
          if(random(1) < .01*counter3) {
            newForm = plant;
            dx = dy = 0;
          }
        }//end of mud
        else if(val == dirt) { //dirt
          dy = (int)random(1, 4);
          for(mx = -1; mx < 2; mx++) {
            for(my = -1; my < 2; my++) {
              if(mx != 0 | my != 0) { //make sure it doesn't check itself
                enumVal = getAt(x+mx, y+my);
                if(enumVal == water) { //
                  counter += 2;
                }//end of enumVal == water
                else if(enumVal == mud) {
                  counter++;
                } //end of enumVal == mud
                else if(enumVal == fire) {
                  counter--;
                }//end of enumVal == fire
                else if(enumVal == plant) {
                  counter2++;
                }//end of enumVal == plant
              }
            }//end of moore x
          }//end of moore y
          if(counter > 2)
            dy *= .5;
          if(counter > 4)
            newForm = mud;
          if(random(1) < .008*counter2) {
            newForm = plant;
            dx = dy = 0;
          }
          if(random(1) < .0001) {
            newForm = torch;
          }
        }//end of dirt
        setAt(x+dx, y+dy, x, y, newForm);
      }//end of checking when something is there
//      }//end of changed
    }//end of y loop
  }//end of x loop
  arraycopy(nextBuffer.pixels, pixels);
/*  for(int a = 0; a < pixels.length; a++) {
    pixels[a] = nextBuffer.pixels[a];
//    changed[a] = nextChanged[a];
  //  nextChanged[a] = false;
    changed[a] = false;
  }
/*  for(int a = 0; a < changed.length; a++) {
    if(changed[a]) pixels[a] = #231698;
    else pixels[a] = black;
  }*/
  updatePixels();
  if(mousePressed) {
    fill(col);
    noStroke();
    ellipse(mouseX, mouseY, penSize, penSize);
/*    loadPixels();
    arraycopy(pixels, nextBuffer.pixels);
    updatePixels();*/
  }
//  println(frameRate+", "+g);
}//end of draw


int bounds(int a, int l, int h) {
  return a > h ? h : a < l ? l : a;
}

int getAt(int x, int y) {
  if(y < 0 | y >= height | x < 0 | x >= width) return black;
  return pixels[y*width+x];
}

int neut = -27345;
int swap = -2454;
int[][] convTable =  {
//---------brick-------fire-------water-------plant-------steam-------fodder-------sand-------glass-------ice-------uber-------torch-------waterfall-------mud-------dirt
/*brick*/ {neut,       brick,     brick,      brick,      brick,      brick,       brick,     neut,       brick,    neut,      neut,       neut,           neut,     neut},
/*fire*/  {brick,      neut,      black,      fire,       black,      fire,       glass,     glass,      water,    neut,      neut,       neut,           dirt,     neut},
/*water*/ {brick,      steam,     neut,       plant,      neut,       neut,        sand,      neut,       neut,     water,     torch,      neut,           neut,     mud},
/*plant*/ {brick,      fire,      plant,      neut,       neut,       neut,        neut,      neut,       neut,     plant,     neut,       plant,          neut,     neut},
/*steam*/ {brick,      black,     neut,       neut,       neut,       neut,        neut,      neut,       water,    neut,      torch,      waterfall,      neut,     neut},
/*fodder*/{brick,      neut,      neut,       neut,       neut,       neut,        neut,      neut,       neut,     neut,      neut,       neut,           neut,     neut},
/*sand*/  {brick,      glass,     neut,       neut,       neut,       neut,        neut,      neut,       neut,     neut,      neut,       neut,           neut,     neut},
/*glass*/ {neut,       glass,     neut,       neut,       neut,       neut,        neut,      glass,      glass,    glass,     glass,      neut,           neut,     neut},
/*ice*/   {brick,      water,     neut,       neut,       water,      neut,        neut,      neut,       neut,     neut,      torch,      water,          waterfall,neut},
/*uber*/  {neut,       neut,      water,      plant,      neut,       neut,        neut,      neut,       neut,     neut,      neut,       neut,           neut,     neut},
/*torch*/ {neut,       neut,      fire,       neut,       torch,      neut,        torch,     torch,      torch,    neut,      torch,      neut,           dirt,     neut},
/*wfall*/ {neut,       neut,      neut,       plant,      waterfall,  neut,        waterfall, waterfall,  waterfall,neut,      waterfall,  neut,           waterfall,mud},
/*mud*/   {neut,       dirt,      neut,       neut,       neut,       neut,        neut,      neut,       waterfall,neut,      dirt,       waterfall,      neut,     neut},
/*dirt*/  {neut,       neut,      mud,        neut,       neut,       neut,        neut,      neut,       neut,     neut,      neut,       mud,            neut,     neut}
};

int[] elementsIndex = {  
  brick, fire, water, plant, steam, fodder, sand, glass, ice, uber, torch, waterfall, mud, dirt
};

int findIndexOfElement;
int elementsIndexLength = elementsIndex.length;
int findIndexOfElement(int e) {
  if(e == black) return -1;
  for(findIndexOfElement = 0; findIndexOfElement < elementsIndexLength; findIndexOfElement++) {
    if(e == elementsIndex[findIndexOfElement]) return findIndexOfElement;
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
  if(my < 0 | my >= height | mx < 0 | mx >= width | (mx==x && my==y)) {
    setBuf(x, y, newForm);
    return;
  }
  nbat = nextBuffer.pixels[my*width+mx];
  if(newForm == nbat) return;
  if(nbat == black) {
    setBuf(x, y, black);
    setBuf(mx, my, newForm);
    return;
  }
  if(ind < 0) return;
  conv = convTable[findIndexOfElement(newForm)][findIndexOfElement(nbat)];
  if(conv == swap) {
    setBuf(x, y, nbat);
    setBuf(mx, my, newForm);
  }
  else if(conv != neut) {
    setBuf(mx, my, conv);
  }
}

void setAt(int mx, int my, int newForm) {
  if(my < 0 | my >= height | mx < 0 | mx >= width)
    return;
  if(nextBuffer.pixels[my*width+mx] == black) {
    setBuf(mx, my, newForm);
    return;
  }
  conv = convTable[findIndexOfElement(newForm)][findIndexOfElement(nextBuffer.pixels[my*width+mx])];  
  if(conv != neut & conv != swap)
    setBuf(mx, my, conv);
}

void setAt(float mx, float my, float x, float y, int newForm) {
  setAt(int(mx), int(my), int(x), int(y), newForm);
}

void setAt(float mx, float my, int newForm) {
  setAt(int(mx), int(my), newForm);
}

int lx, ly;
void setBuf(int x, int y, int f) {
  nextBuffer.pixels[y*width+x] = f;
/*  for(lx = x-1; lx < x+2; lx++) {
    for(ly = y-1; ly < y+2; ly++) {
      if(ly*width+lx >= 0 & ly*width+lx < 400*400)
        nextChanged[ly*width+lx] = true;
    }
  }*/
}
