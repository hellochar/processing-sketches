
final float[][][] buffers = new float[2][400][400];

float mX, mY;

void setup() {
  now = buffers[0];
//  size(400, 400);
  size(now.length, now[0].length);
  //  println(now == buffers[0]);

  mX = (float)width / now.length;
  mY = (float)height / now[0].length;

  for(int i = 0; i < now.length; i++) {
    for(int j = 0; j < now[0].length; j++) {
      now[i][j] = noise(i*.01, j*.01);
    }
  }
  //  noLoop();
}
float divMin = 6, divMax = 6.5,
multMin = 1, multMax = 1.5;

void mousePressed() {
  redraw();
}

float min, max, div, mult;
float[][] now, next;
void draw() {
  background(255);
  now = buffers[(frameCount+1)%2];
  next = buffers[frameCount%2];
  //  println(now == buffers[0]);
  min = Float.MAX_VALUE; 
  max = 0;

  div = map(mouseX, 0, width, divMin, divMax);
  mult = map(mouseY, 0, height, multMin, multMax);
  println("div: "+div+", mult: "+mult);

  for(int i = 0; i < now.length; i++) {
    for(int j = 0; j < now[0].length; j++) {
      float amt = now[i][j],
      newAmt = func(i, j, amt);
      //act do stuff

      newAmt = wrap(newAmt, 255);
      if(newAmt < min) min = newAmt; 
      if(newAmt > max) max = newAmt;
      next[i][j] = newAmt;
    }
  }

  //and right here, a "blip" occurs

//  for(int i = 0; i < buffers.length; i++) {
//    for(int j = 0; j < buffers[0].length; j++) {
//      stroke(colorFor(next[i][j]));
//      point(i*mX, i*mY, -next[i][j]);
//    }
//  }
  loadPixels();
  for(int i = 0; i < width; i++) {
    for(int j = 0; j < height; j++) {
//      println(i+", "+j+", "+next.length+", "+next[0].length);
      pixels[j*width+i] = colorFor(next[i][j]);
    }
  }
  updatePixels();
  println("Frame count: "+frameCount+", min: "+min+", max: "+max+", frameRate: "+frameRate);
}

int colorFor(float amt) {
  colorMode(HSB);
  return color(amt, 255, 255);
  //  return color(map(amt, min, max, 0, 255), 255, 255);
}

