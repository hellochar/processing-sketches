float xMin,
xMax,
xCamDif,
xIncr;
int xDecPrec;

float yMin,
yMax,
yCamDif,
yIncr;
int yDecPrec;

float sizeRatio;

PGraphics render;
PFont f;

boolean grid = true, running = false;
float hSize = 4;

float iCam = 15;

void setup() {
  size(900, 600);
  sizeRatio = (float)width/height;
  render = createGraphics(width, height, JAVA2D);
  f = loadFont("AbadiMT-Condensed-48.vlw");
  textFont(f, 15);
//  setCamBoundaries(-iCam, iCam, -iCam, iCam);
  setCamBoundaries(0, 200, 0, 255);
}

void draw() {
  if(running) {
    time+=timeIncr;
    render();
  }
  image(render, 0, 0);
  fill(color(0));
  textAlign(LEFT, BOTTOM);
  text(time, 0, 12);
  fill(color(0, 0, 255));
  int xAlign = RIGHT, yAlign = BOTTOM;
  if(mouseX < width / 2) {
    xAlign = LEFT;
  }
  if(mouseY < height / 2) {
    yAlign = TOP;
  }
  textAlign(xAlign, yAlign);
  text(round(xCoord(mouseX), 4)+", "+round(yCoord(mouseY), 4), mouseX, mouseY);
  println(frameRate);
}

float round(float val, int digit) {
  return floor(val * pow(10, digit) + .5)/pow(10, digit);
}

void setCam(float xmi, float xma, float ymi, float yma) {
  if(xma-xmi <= 0 | yma-ymi <= 0) return;
  float dif = (xma-xmi)/sizeRatio/2;
  float midY = (yma+ymi)/2;
  setCamBoundaries(xmi, xma, midY - dif, midY + dif);
}

void setCamBoundaries(float xmi, float xma, float ymi, float yma) {
  setCamBoundaries(xmi, xma, ymi, yma, true);
}

void setCamBoundaries(float xmi, float xma, float ymi, float yma, boolean autoRender) {
  xMin = xmi;
  xMax = xma;
  xCamDif = (xMax-xMin);
  xIncr = xCamDif/width;
  xDecPrec = (int)log10(1 / xCamDif ) + 2;

  yMin = ymi;
  yMax = yma;
  yCamDif = (yMax-yMin);
  yIncr = yCamDif/height;
  yDecPrec = (int)log10( 1 / yCamDif ) + 2;

  if(autoRender)
    render();
}

float precision = 1;
float rotations = 1;
float time = 1, timeIncr = .01;

void render() {
  render.beginDraw();
  render.background(color(250));
  if(grid) drawAxes(1, .5);
  render.noFill();
  //render.smooth();
  drawWhich();
  render.endDraw();
}

void beginLine() {
  render.beginShape();
}

void endLine() {
  render.endShape();
}

float ly;
void vertex(float x, float y) {
  if(abs(y - ly) > 5000) {
    endLine();
    beginLine();
  }
  render.vertex(xNot(x), yNot(y));
  ly = y;
}

void drawAxes(float xInc, float yInc) {
  render.stroke(color(0));
  render.noSmooth();
  render.strokeWeight(1);
  //draw x axes
  line(xMin, 0, xMax, 0);
  for(float x = 0; x <= xMax; x += xInc) {
    line(x, -.1, x, .1);
  }
  for(float x = 0; x >= xMin; x -= xInc) {
    line(x, -.1, x, .1);
  }

  //draw y axes
  line(0, yMin, 0, yMax);
  for(float y = 0; y <= yMax; y += xInc) {
    line(-.1, y, .1, y);
  }
  for(float y = 0; y >= yMin; y -= xInc) {
    line(-.1, y, .1, y);
  }
}

void line(float x1, float y1, float x2, float y2) {
  render.line(xNot(x1), yNot(y1), xNot(x2), yNot(y2));
}

float log10 (float x) {
  return (log(x) / log(10));
}

float xNot(float modelX) {
  return constrain((modelX-xMin)/xIncr, -9999, 9999);
}

float yNot(float modelY) {
  return constrain((yMax-modelY)/yIncr, -9999, 9999);
}

float xCoord(float camX) {
  return camX*xIncr+xMin;
}

float yCoord(float camY) {
  return yMax-camY*yIncr;
}

void mouseDragged() {
  float dx = (mouseX-pmouseX)*xIncr, dy = (mouseY-pmouseY)*yIncr;
  setCam(xMin - dx, xMax - dx, yMin + dy, yMax + dy);
}

void mouseClicked() {
  float mx = xCoord(mouseX), my = yCoord(mouseY);
  setCam(mx - xCamDif / 2.0, mx + xCamDif / 2.0, my - yCamDif / 2.0, my + yCamDif / 2.0);
}

boolean ctrlPressed = false;

void keyPressed() {
  float xDif, yDif;
  switch(key) {
  case '=':
    xDif = xCamDif / 4.0;
    yDif = yCamDif / 4.0;
    setCamBoundaries(xMin + xDif, xMax - xDif, yMin + yDif, yMax - yDif);
    break;
  case '-':
    xDif = xCamDif / 2.0;
    yDif = yCamDif / 2.0;
    setCamBoundaries(xMin - xDif, xMax + xDif, yMin - yDif, yMax + yDif);
    break;
  case 'g':
    grid = !grid;
    break;
  case ' ':
    if(!running) {
      if(ctrlPressed) {
        time = 0;
      }
      else running = true;
    }
    else running = false;
    break;
  case CODED:
    if(keyCode == CONTROL)
      ctrlPressed = true;
    else if(keyCode == LEFT) {
      time -= timeIncr*10;
    }
    else if(keyCode == RIGHT) {
      time += timeIncr*10;
    }
  }
  render();
}

void keyReleased() {
  if(key == CODED & keyCode == CONTROL) {
    ctrlPressed = false;
  }
}
