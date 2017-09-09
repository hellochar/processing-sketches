import java.util.Stack;
import java.math.BigDecimal;


BigDecimal xMin,
xMax,
xCamDif,
xIncr;
int xDecPrec;

BigDecimal yMin,
yMax,
yCamDif,
yIncr;
int yDecPrec;

PFont f;
PImage render;
int[] tempPixelHolder;
int[] colorBands;
int scale = 20;

Stack xMinStack, xMaxStack, yMinStack, yMaxStack, renderStack;

BigDecimal bdWidth, bdHeight;

void setup() {
  size(400, 400);
  render = createImage(width, height, RGB);
  bdWidth = bd(width);
  bdHeight = bd(height);
  tempPixelHolder = new int[width*height];
  xMinStack = new Stack();
  xMaxStack = new Stack();
  yMinStack = new Stack();
  yMaxStack = new Stack();
  renderStack = new Stack();
//  f = loadFont("AbadiMT-CondensedExtraBold-20.vlw");
  //textMode(SCREEN);
  colorBands = new int[maxIter];
  for(int a = 0; a < maxIter; a++) {
    colorBands[a] = color(32+(a%255)*(1-64/255), 32+(a%128*2)*(1-164/255), 32);
  }
  resetCam();
}

String setVal = "-0.5638307426454855, -0.563830742645481: -0.6434807756946107, -0.6434807756946063";
double xs = Double.parseDouble(setVal.substring(0, setVal.indexOf(",")));
double xL = Double.parseDouble(setVal.substring(setVal.indexOf(",")+2, setVal.indexOf(":")));
double ys = Double.parseDouble(setVal.substring(setVal.indexOf(":")+2, setVal.indexOf(",", setVal.indexOf(":"))));
double yL = Double.parseDouble(setVal.substring(setVal.lastIndexOf(",")+2));

void resetCam() {
  setCam(bd(xs), bd(xL), bd(ys), bd(yL));
}

void setCam(BigDecimal xmi, BigDecimal xma, BigDecimal ymi, BigDecimal yma) {
  println("\n"+xmi+", "+xma+" x "+ymi+", "+yma);  
  xMinStack.push(xMin);
  xMaxStack.push(xMax);
  yMinStack.push(yMin);
  yMaxStack.push(yMax);
  PImage temp = createImage(width, height, RGB);
  temp.copy(render, 0, 0, width, height, 0, 0, width, height);
  renderStack.push(temp);
  setCamBoundaries(xmi, xma, ymi, yma);
}

void setCamBoundaries(BigDecimal xmi, BigDecimal xma, BigDecimal ymi, BigDecimal yma) {
  setCamBoundaries(xmi, xma, ymi, yma, true);
}

void setCamBoundaries(BigDecimal xmi, BigDecimal xma, BigDecimal ymi, BigDecimal yma, boolean autoRender) {
  xMin = zero().add(xmi);
  xMax = zero().add(xma);
  xCamDif = xMax.subtract(xMin);
  xIncr = xCamDif.divide(bdWidth, BigDecimal.ROUND_HALF_EVEN);

  yMin = zero().add(ymi);
  yMax = zero().add(yma);
  yCamDif = yMax.subtract(yMin);
  yIncr = yCamDif.divide(bdHeight, BigDecimal.ROUND_HALF_EVEN);
  

  if(autoRender)
    render();
}

BigDecimal x, y;

BigDecimal bd(double val) {
  return new BigDecimal(val).setScale(scale, BigDecimal.ROUND_HALF_EVEN);
}

void render() {
//  x = zero().add(xMin);
  //println(x.add(xIncr));
  int c = 0;
  for(x = zero().add(xMin); x.compareTo(xMax) < 0; ) {
    for(y = zero().add(yMin); y.compareTo(yMax) < 0; ) {
//      println("X: "+x+"!");
      solveFor(x, y);
//      println("Solved "+x+", "+y+"!");
//      print("Currently: "+x+" : "+xMax+" ("+x.compareTo(xMax));
  //    println(") added:"+xIncr);
      y = y.add(yIncr);
    }
    println("BigDecimaler: next row: "+c++);
    x = x.add(xIncr);
  }
  println("ymin: "+yMin+" -- yIncr:"+yIncr+" -- yMax:"+yMax);
  render.loadPixels();
  arraycopy(tempPixelHolder, render.pixels);
  render.updatePixels();
}


int iter;
int maxIter = 1000;
BigDecimal nx, ny;
BigDecimal xtemp, ytemp;
void solveFor(BigDecimal x, BigDecimal y) {
  iter = 0;
  nx = xIncr.divide(bd(2), BigDecimal.ROUND_HALF_EVEN).add(x);
  ny = yIncr.divide(bd(2), BigDecimal.ROUND_HALF_EVEN).add(y);
  BigDecimal nx2 = multiply(nx, nx);
  BigDecimal ny2 = multiply(ny, ny);
  while(nx2.add(ny2).doubleValue() < 4 & iter++ < maxIter) {
    xtemp = nx2.subtract(ny2).add(x);
    ytemp = multiply(multiply(nx, bd(2)), ny).add(y);
    nx = zero().add(xtemp);
    ny = zero().add(ytemp);
    nx2 = multiply(nx, nx);
    ny2 = multiply(ny, ny);
  }
  if(iter >= maxIter) {
    setPixAt(x, y, #000000);
  }
  else {
    setPixAt(x, y, colorBands[iter%colorBands.length]);
  }
}

BigDecimal multiply(BigDecimal first, BigDecimal second) {
  return first.multiply(second).setScale(scale, BigDecimal.ROUND_HALF_EVEN);
}



//strangeness
/*
BigDecimal cap = 5.0;
BigDecimal div = 7;
BigDecimal top = .4;
BigDecimal mult = 10;
BigDecimal xDif, yDif, current, dif;
void solveFor(BigDecimal x, BigDecimal y) {
  xDif = x*x/top-y*x;
  yDif = y*y/top-x*y;
  current = 0;
  dif = xDif-yDif;
  do {
    current += dif;
    if(current/div%1 < top) {
      break;
    }
  }
  while(current < cap);
  setPixAt(x, y, color(current/cap*255));
}
*/

int ox, oy;
void setPixAt(BigDecimal x, BigDecimal y, int c) {  
  if(x.compareTo(xMin) <= 0 | x.compareTo(xMax) >= 0 | y.compareTo(yMin) <= 0 | y.compareTo(yMax) >= 0) return;
  try {
    ox = xNot(x);
    oy = yNot(y);
    if(oy >= height) oy = height-1;
    if(ox >= width) ox = width-1;
    tempPixelHolder[oy*width+ox] = c;
  }
  catch(ArrayIndexOutOfBoundsException e) {
    println("Error: "+x+", "+y+" ("+ox+", "+oy+")");
    e.printStackTrace();
  }
}

void setPixCoordAt(int x, int y, int c) {
  tempPixelHolder[y*width+x] = c;
}

int getPixCoordAt(int x, int y) {
  if(x < 0 | x > width | y < 0 | y > height) return #000000;
  return tempPixelHolder[y*width+x];
}

int getPixCoordAt(BigDecimal x, BigDecimal y) {
  return getPixCoordAt(x.intValue(), y.intValue());
}

void draw() {
  image(render, 0, 0);
  fill(color(196, 96, 20));
//  textFont(f);
  if(dragged) {
//    text(round(xIncr*(mouseX-xPressed), xDecPrec)+", "+round(yIncr*(mouseY-yPressed), yDecPrec)+" ("+(int)(mouseX-xPressed)+", "+(int)(mouseY-yPressed)+")", mouseX, mouseY);
    rectMode(CORNERS);
    noFill();
    stroke(color(175, 200, 75));
    rect(xPressed, yPressed, mouseX, mouseY);
  }
  else {
//    text(round(xCoord(mouseX), xDecPrec)+", "+round(yCoord(mouseY), yDecPrec), mouseX, mouseY);
  }
}

/*
BigDecimal round(BigDecimal val, int digit) {
  return floor(val * pow(10, digit) + .5)/pow(10, digit);
}

BigDecimal log10 (BigDecimal x) {
  return (log(x) / log(10));
}*/

int xPressed, yPressed;
boolean dragged;

void mousePressed() {
  if(mouseButton == LEFT) {
    xPressed = mouseX;
    yPressed = mouseY;
    dragged = true;
  }
  else if(mouseButton == RIGHT) {
    if(xMinStack.size() > 1) {
      setCamBoundaries((BigDecimal)xMinStack.pop(), (BigDecimal)xMaxStack.pop(), (BigDecimal)yMinStack.pop(), (BigDecimal)yMaxStack.pop(), false);
      render = (PImage)renderStack.pop();
    }
  }
}

void mouseClicked() {
  if(mouseButton == LEFT) {
    dragged = false;
//    println(bd(.05));
//    println("x: "+multiply(xCoord(mouseX).subtract(xCamDif), bd(.05))+", "+multiply(xCoord(mouseX).add(xCamDif), bd(.05)));
  //  println("y: "+multiply(yCoord(mouseY).subtract(yCamDif), bd(.05))+", "+multiply(yCoord(mouseY).add(yCamDif), bd(.05)));
    println("clicked!");
    setCam(multiply(xCoord(mouseX).subtract(xCamDif), bd(.05)), multiply(xCoord(mouseX).add(xCamDif), bd(.05)), multiply(yCoord(mouseY).subtract(yCamDif), bd(.05)), multiply(yCoord(mouseY).add(yCamDif), bd(.05)));
  }
}

void mouseReleased() {
  if(dragged) {
    dragged = false;
    println("Dragged!");
    setCam(xCoord(min(mouseX, xPressed)), xCoord(max(mouseX, xPressed)), yCoord(min(mouseY, yPressed)), yCoord(max(mouseY, yPressed)));
  }
}

BigDecimal zero() {
  return bd(0);
}

BigDecimal mouseXBD() {
  return bd(mouseX);
}

BigDecimal mouseYBD() {
  return bd(mouseY);
}

//returns the screen drawing coordinates, given the plot coordinates
int xNot(BigDecimal x) {
  return x.subtract(xMin).divide(xIncr, BigDecimal.ROUND_HALF_EVEN).intValue();
}

int yNot(BigDecimal y) {
  return y.subtract(yMin).divide(yIncr, BigDecimal.ROUND_HALF_EVEN).intValue();
}

//returns the plot coordinates, given the screen drawing coordinates
BigDecimal xCoord(int x) {
  return multiply(bd(x), xIncr).add(xMin);
}

BigDecimal yCoord(int y) {
  return multiply(bd(y), yIncr).add(yMin);
}

/*
void keyPressed() {
  switch(keyCode) {
  case UP:
    div++;
    render();
    break;
  case DOWN:
    if(div > 1) {
      div--;
      render();
    }
    break;
  case LEFT:
    if(top > .01) {
      top -= .01;
      render();
    }
    break;
  case RIGHT:
    if(top < .99) {
      top += .01;
      render();
    }
    break;
  }
  if(key == '=') {
    mult++;
    render();
  }
  else if(key == '-') {
    mult--;
    render();
  }
}*/
