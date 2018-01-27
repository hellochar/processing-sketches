/////////////////////////////////////////////////
//                                             //
//    The Secret Life of Turing Patterns       //
//                                             //
/////////////////////////////////////////////////
 
// Inspired by the work of Jonathan McCabe
// (c) Martin Schneider 2010
 
 
int scl = 4, dirs = 9, rdrop = 8, lim = 128;
int res = 2, palette = 2, pattern = 2, soft = 0;
int dx, dy, w, h, s;
boolean border, invert;
float[] pat;
PImage img;
  
void setup() {
  size(300, 300);
  colorMode(HSB);
  reset();
}
 
void reset() {
  w = width/res;
  h = height/res;
  s = w*h;
  img = createImage(w, h, RGB);
  pat = new float[s];
  // random init
  for(int i=0; i<s; i++) 
    pat[i] = floor(random(256));
}
 
void draw() {
   
  // constrain the mouse position
  if(border) {
    mouseX = constrain(mouseX,0,width-1);
    mouseY = constrain(mouseY,0,height-1);
  }
     
  // add a circular drop of chemical
  if(mousePressed) {
      if(mouseButton != CENTER) {
      int x0 = mod((mouseX-dx)/res, w);
      int y0 = mod((mouseY-dy)/res, h);
      int r = rdrop * scl / res ;
      for(int y=y0-r; y<y0+r;y++)
        for(int x=x0-r; x<x0+r;x++) {
          int xwrap = mod(x,w), ywrap = mod(y,w);
          if(border && (x!=xwrap || y!=ywrap)) continue;         
          if(dist(x,y,x0,y0) < r)
            pat[xwrap+w*ywrap] = mouseButton == LEFT ? 255 : 0;
        }
    }
  }
 
  // calculate a single pattern step
  pattern();
   
  // draw chemicals to the canvas
  img.loadPixels();
  for(int x=0; x<w; x++)
    for(int y=0; y<h; y++) {
      int c = (x+dx/res)%w + ((y+dy/res)%h)*w;
      int i = x+y*w;
      float val = invert ? 255-pat[i]: pat[i];
      switch(palette) {
        case 0: img.pixels[c] = color(0, 0, val); break;
        case 1: img.pixels[c] = color(64+val/4, val, val); break;
        case 2: img.pixels[c] = color(val,val,255-val); break;
        case 3: img.pixels[c] = color(val,128,255); break;
      }
    }
  img.updatePixels();
   
  // display the canvas
  if(soft>0) smooth(); else noSmooth();
  image(img, 0, 0, res*w, res*h);
  if(soft==2) filter(BLUR);
   
  println(frameRate);
     
}
 
void keyPressed() {
  switch(key) {
    case 'r': reset(); break;
    case 'p': pattern = (pattern + 1) % 3; break;
    case 'c': palette = (palette + 1) % 4; break;
    case 'b': border = !border; dx=0; dy=0; break;
    case 'i': invert = !invert; break;
    case 's': soft = (soft + 1) % 3; break;
    case '+': lim = min(lim+8, 255); break;
    case '-': lim = max(lim-8, 0); break;
    case ' ': saveFrame("coloredturing-####.png"); break;
    case CODED:
      switch(keyCode) {
        case LEFT: scl = max(scl-1, 2); break;
        case RIGHT:scl = min(scl+1, 26); break;
        case UP:   res = min(res+1, 5); reset(); break;
        case DOWN: res = max(res-1, 1); reset(); break;
      }
      break;
  }
}
 
// moving the canvas
void mouseDragged() {
  if(mouseButton == CENTER && !border) {
    dx = mod(dx + mouseX - pmouseX, width);
    dy = mod(dy + mouseY - pmouseY, height);
  }
}
 
// floor modulo
final int mod(int a, int n) {
  return a>=0 ? a%n : (n-1)-(-a-1)%n;
}
// this is where the magic happens ...
 
void pattern() {
   
  // random angular offset
  float R = random(TWO_PI);
 
  // copy chemicals
  float[] pnew = new float[s];
  for(int i=0; i<s; i++) pnew[i] = pat[i];
 
  // create matrices
  float[][] pmedian = new float[s][scl];
  float[][] prange = new float[s][scl];
  float[][] pvar = new float[s][scl];
 
  // iterate over increasing distances
  for(int i=0; i<scl; i++) {
    float d = (2<<i) ;
     
    // update median matrix
    for(int j=0; j<dirs; j++) {
      float dir = j*TWO_PI/dirs + R;
      int dx = int (d * cos(dir));
      int dy = int (d * sin(dir));
      for(int l=0; l<s; l++) { 
        // coordinates of the connected cell
        int x1 = l%w + dx, y1 = l/w + dy;
        // skip if the cell is beyond the border or wrap around
        if(x1<0) if(border) continue; else x1 = w-1-(-x1-1)% w; else if(x1>=w) if(border) continue; else x1 = x1%w;
        if(y1<0) if(border) continue; else y1 = h-1-(-y1-1)% h; else if(y1>=h) if(border) continue; else y1 = y1%h;
        // update median
        pmedian[l][i] += pat[x1+y1*w] / dirs;
         
      }
    }
     
    // update range and variance matrix
    for(int j=0; j<dirs; j++) {
      float dir = j*TWO_PI/dirs + R;
      int dx = int (d * cos(dir));
      int dy = int (d * sin(dir));
      for(int l=0; l<s; l++) { 
        // coordinates of the connected cell
        int x1 = l%w + dx, y1 = l/w + dy;
        // skip if the cell is beyond the border or wrap around
        if(x1<0) if(border) continue; else x1 = w-1-(-x1-1)% w; else if(x1>=w) if(border) continue; else x1 = x1%w;
        if(y1<0) if(border) continue; else y1 = h-1-(-y1-1)% h; else if(y1>=h) if(border) continue; else y1 = y1%h;
        // update variance
        pvar[l][i] += abs( pat[x1+y1*w]  - pmedian[l][i] ) / dirs;
        // update range
         
        prange[l][i] += pat[x1+y1*w] > (lim + i*10) ? +1 : -1;   
    
      }
    }    
  }
 
  for(int l=0; l<s; l++) { 
     
    // find min and max variation
    int imin=0, imax=scl;
    float vmin = MAX_FLOAT;
    float vmax = -MAX_FLOAT;
    for(int i=0; i<scl; i+=1) {
      if (pvar[l][i] <= vmin) { vmin = pvar[l][i]; imin = i; }
      if (pvar[l][i] >= vmax) { vmax = pvar[l][i]; imax = i; }
    }
     
    // turing pattern variants
    switch(pattern) {
      case 0: for(int i=0; i<=imin; i++)    pnew[l] += prange[l][i]; break;
      case 1: for(int i=imin; i<=imax; i++) pnew[l] += prange[l][i]; break;
      case 2: for(int i=imin; i<=imax; i++) pnew[l] += prange[l][i] + pvar[l][i]/2; break;
    }
       
  }
 
  // rescale values
  float vmin = MAX_FLOAT;
  float vmax = -MAX_FLOAT;
  for(int i=0; i<s; i++)  {
    vmin = min(vmin, pnew[i]);
    vmax = max(vmax, pnew[i]);
  }      
  float dv = vmax - vmin;
  for(int i=0; i<s; i++)
    pat[i] = (pnew[i] - vmin) * 255 / dv;
    
}

