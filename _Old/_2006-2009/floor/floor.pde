float[] vals;
float x, y, dx, dy, size;
PGraphics bg;

void setup() {
  size(500, 500);
  size = 6;
  vals = new float[width];
  bg = createGraphics(width, height, JAVA2D);
  bg.beginDraw();
  bg.background(204);
  //  float val = random(height/2);
  //float dx = 0;
  for(int a = 0; a < width; a++) {
    //velocity projection random
    //    val += dx += random(-.1, .1);
    //    vals[a] = val;

    //simple noise random   
    vals[a] = height*noise(a*.003);

    bg.stroke(color(vals[a]/height*255, 0, (1-vals[a]/height)*255));
    bg.line(a, height, a, height-vals[a]);
  }

  //plasma fractal

  /*
  int prec = 4;
   int l = (int)pow(2, prec)+1;
   float[] rawData = new float[l];
   rawData[0] = random(1);
   rawData[l-1] = random(1);
   int parse = l-1;
   for(int a = 0; a < prec; a++) {
   for(int x = 0; x < l-1; x += parse) {
   rawData[x+parse/2] = Math.max(0, Math.min(1, rawData[x]+rawData[x+parse])/2.0+random(-.05, .05));
   }
   parse /= 2;
   }
   float blockLength = (float)width/(l-1);
   float x = 0;
   for(int a = 1; a < l; a++) {
   float lval = rawData[a-1];
   float nval = rawData[a];
   for( ; x < blockLength*a; x++) {
   vals[round(x)] = height*lerp(lval, nval, 1-(blockLength*a-x)/blockLength);
   //      println("lerp of "+lval+" and "+nval+" at "+(1-(blockLength*a-x)/blockLength)+": "+vals[round(x)]);
   }
   }
   for(int a = 0; a < width; a++) {
   stroke(color(vals[a]/height*255, 0, (1-vals[a]/height)*255));
   line(a, height, a, height-vals[a]);
   }
   */  //end of plasma fractal
  bg.endDraw();
  angs = new float[50];
  x = width/2;
  y = 25;
}


float[] angs;
void draw() {
  background(bg);  
  dy += .06;
  
  x = Math.max(0, Math.min(x+dx, width));
  y = Math.max(0, Math.min(y+dy, height));
  if(x == 0 | x == width) dx *= -1;
  if(y == 0 | y == height) dy *= -1;
  
  int c = 0;
  for(int r = 0; r < 360; r += 20) {
    if(bg.get(round(x+size*cos(radians(r))), round(y+size*sin(radians(r)))) != color(204)) {
      angs[c++] = radians(r);
    }
  }
  float pow = 2;
  println(c);
  for( ; c >= 0; c--) {
    dx -= pow*sin(angs[c]);
    dy -= pow*cos(angs[c]);
  }
  
  noStroke();
  ellipse(x, y, size*2, size*2);
}

void keyPressed() {
  switch(keyCode) {
    case LEFT:
      dx--;
      break;
    case RIGHT:
      dx++;
      break;
  }
}
