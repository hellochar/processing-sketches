int x, y;
int val;
int mx, my;
int dx, dy;
int counter, counter2;
int newForm;
int enumVal;
int g;
void step() {
//  loadPixels();
  arraycopy(pixels, nextBuffer);
/*  for(int a = 0; a < pixels.length; a++) {
    if(pixels[a] != nextBuffer[a]) {
      nextBuffer[a] = pixels[a];
      changed[a] = true;
    }
  }*/
  g = 0;
  for(x = 0; x < width; x++) {
    for(y = 0; y < height; y++) {
//      if(changed[y*width+x]) {
      val = getAt(x, y);
      int elInd = findIndexOfElement(val);
      if(elInd != -1) { //if there is something there, then prepare everything
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
  arraycopy(nextBuffer, pixels);
/*  for(int a = 0; a < pixels.length; a++) {
    pixels[a] = nextBuffer[a];
//    changed[a] = nextChanged[a];
  //  nextChanged[a] = false;
    changed[a] = false;
  }
/*  for(int a = 0; a < changed.length; a++) {
    if(changed[a]) pixels[a] = #231698;
    else pixels[a] = black;
  }*/
//  updatePixels();
  if(mousePressed) {
    fill(col);
    noStroke();
    ellipse(mouseX, mouseY, penSize, penSize);
/*    loadPixels();
    arraycopy(pixels, nextBuffer);
    updatePixels();*/
  }
//  println(frameRate+", "+g);
}//end of draw

