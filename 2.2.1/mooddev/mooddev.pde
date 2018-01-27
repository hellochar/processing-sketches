import java.util.*;

/* 
 * 1) Press 'w' to save the image.
 * 2) Open the file location where this sketch is located. You should find an SVG file.
 * 3) Open that SVG file using Inkscape.
 * 4) Go to File, Export Bitmap, and select your desired width, height, and DPI.
 * 5) Hit "Export". An "export in progress" window will appear. Wait for it to finish.
 * 6) Go back to the file location. There will now be a rendered PNG file.
 */

float CIRCLE_NUM = .5;

import java.util.ArrayList;
ArrayList<Ball> list;
float r, g, b, variance = 2;
float size = 1;
float sizeNorm = 1;
//PGraphics graphics;
void setup() {
  size(1920, 1080);
  //colorMode(HSB, 360, 100, 100, 255);
  background(255);
  r = random(255);
  g = random(255);
  b = random(255);
  list = new ArrayList();
  noStroke();
  for (int a = 0; a < 40; a++) {     
    list.add(new Ball(a, a*9, 0, 0, r, g, b, variance / 1));
    r += random(-variance, variance);
    g += random(-variance, variance);
    b += random(-variance, variance);
  }  
//  graphics = createGraphics(width, height, JAVA2D);
//  graphics.smooth();
  //  mouseX = width/2;
  //  mouseY = height/2;
  out.begin();
}

int k;
int m = 1;

SVGOut out = new SVGOut();

void draw() {
  list.add(new Ball(width/2, height/2, 0, 0, r, g, b, variance / 4));
  r += random(-variance, variance);
  g += random(-variance, variance);
  b += random(-variance, variance);
  if (mousePressed) {    
    if (mouseButton == LEFT) sizeNorm += 2;
    else sizeNorm = max(sizeNorm-1, 0);
  }     
  m = 1;
  if (keyPressed) {     
    if (key == ' ') {
      m = -1;
    }
  }   
  k = (int)random(list.size());
//  graphics.beginDraw();

//  if(frameCount > 100) {
////    graphics.beginRecord(out);
//    beginRecord(out);
//    out.begin();
//  }
  beginRecord(out);
  
//  noStroke(); fill(0, .2);
//  rect(0, 0, width, height);

//  graphics.background(0, .2);
//  background(0, .2);
  for (int a = 8; a < list.size(); a++) {     
    Ball b = (Ball) list.get(a);
    b.run();
  }
  Ball b = (Ball) list.get(k);
  size = min(sizeNorm/dist(b.x, b.y, mouseX, mouseY), 50);
  if (keyPressed & key == 'f') {     
    size = 1;
  }   
  for (int a = 0; a < list.size(); a++) {
    b = (Ball) list.get(a);
    b.show();
  }
  endRecord();
  if(keyPressed && key == 'w')
    write();
//  graphics.endDraw();
//  image(graphics, 0, 0);
}

void write() {
  out.begin();
  for(Ball b : list) {
    out.doc.append(b.pathString());
  }
  String s = out.current();
  try {
    String f = sketchPath("out-"+frameCount+".svg");
    PrintWriter stream = new PrintWriter(f);
    stream.write(s);
    stream.flush();
    stream.close();
  }catch(Exception e) {e.printStackTrace();}
}



class Ball {   
  float x, y, dx, dy;
  float ox, oy;
  int r, g, b;
  LinkedList<Float> locX = new LinkedList();
  LinkedList<Float> locY = new LinkedList();
  LinkedList<float[]> bigs = new LinkedList();
//  float variance;
  Ball(float x, float y, float dx, float dy, float r, float g, float b, float v) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.r = int(constrain(r, 0, 255));
    this.g = int(constrain(g, 0, 255));
    this.b = int(constrain(b, 0, 255));
//    variance = v;
  }
  void run() {     
    ox = x;
    oy = y;
    //    x += dx;
    //    y += dy;
    dx += (mouseX-x)/20;
    dy += (mouseY-y)/20;
    float ang = atan2(mouseY-y, mouseX-x);
    float dist = dist(x, y, mouseX, mouseY);
    if (dist == 0) return;
    x += 55*cos(ang)/sqrt(dist)*m;
    y += 55*sin(ang)/sqrt(dist)*m;
    size = 5/dist;
  }   
  void show() {
//    r += random(-variance, variance);
//    g += random(-variance, variance);
//    b += random(-variance, variance);
//    graphics.strokeWeight(size);
//    graphics.stroke(color(r, g, b, 50));
//    graphics.line(x, y, ox, oy);
  float ssize = (random(1) < CIRCLE_NUM) ? size : 1;
    strokeWeight(ssize);
    stroke(color(r, g, b, 50));
    line(x, y, ox, oy);
    if(ssize > 2) {
      float[] arr = {x, y, ox, oy, ssize};
      bigs.add(arr);
    }
    locX.add(x);
    locY.add(y);
  }
  
  StringBuilder pathString() {
    StringBuilder b = new StringBuilder(locX.size()*13 + 100);
    for(float[] arr : bigs) {
      b.append("<line stroke=\"#");
      b.append(strokeColor(r, g, this.b));
      b.append("\" stroke-width=\"");
      b.append(tc(arr[4]));
      b.append("\" x1=\"");
      b.append(tc(arr[0]));
      b.append("\" y1=\"");
      b.append(tc(arr[1]));
      b.append("\" x2=\"");
      b.append(tc(arr[2]));
      b.append("\" y2=\"");
      b.append(tc(arr[3]));
      b.append("\" />\n");
    }
    b.append("<path stroke=\"#");
    b.append(strokeColor(r, g, this.b));
    b.append("\" d=\"M");
    b.append(tc(locX.getFirst()));
    b.append(' ');
    b.append(tc(locY.getFirst()));
    b.append(' ');
    Iterator<Float> itx = locX.listIterator(1),
                    ity = locY.listIterator(1);
    while(itx.hasNext()) {
      float x = itx.next();
      float y = ity.next();
      b.append('L');
      b.append(tc(x));
      b.append(' ');
      b.append(tc(y));
    }
    b.append("\" />\n");
    return b;
  }
}

  String lpad(String s, char c, int wantLen) {
    return makeStr(c, wantLen - s.length()) + s;
  }
  
  String makeStr(char c, int len) {
      StringBuilder b = new StringBuilder(len);
      for (int i = 0; i < len; i++) {
          b.append(c);
      }
      return b.toString();
  }
  
String lp(String s) {
  return s.length() < 2 ? '0' + s : s;
}

String strokeColor(int strokeRi, int strokeGi, int strokeBi) {
  return lp(Integer.toHexString(strokeRi)) + 
         lp(Integer.toHexString(strokeGi)) + 
         lp(Integer.toHexString(strokeBi));
}

String tc(float val) {
  String s = String.valueOf(val);
  return s.length() > 6 ? s.substring(0, 6) : s;
} 

























class SVGOut extends PGraphics {
  
  public SVGOut() {
    super();
  }

  StringBuilder doc = null; //Holds the XML data

  void begin() { //Call this method right before/after you call beginRecord(SVGOut)
    doc = new StringBuilder("<svg width=\"100%\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n" + 
      "<defs>\n"+
    "<style type=\"text/css\">\n"+
    "path { stroke-opacity:0.1961; fill:none; }\n"+
    "line { stroke-opacity:0.1961; stroke-linecap:round; }</style>\n"+
  "</defs>\n");
  }
  
//  void line(float p1, float p2, float p3, float p4) {
//    doc.append("<line x1=\"");
//    doc.append(tc(p1));
//    doc.append("\" y1=\"");
//    doc.append(tc(p2));
//    doc.append("\" x2=\"");
//    doc.append(tc(p3));
//    doc.append("\" y2=\"");
//    doc.append(tc(p4));
//    doc.append("\" style=\"stroke:#");
//    doc.append(strokeColor());
//    if(strokeWeight > 1) {
//      doc.append(";stroke-width:");
//      doc.append(max(1, strokeWeight));
//    }
//    doc.append("\" />\n");
//  }
  
  
  String strokeColor() {
    return lpad(Integer.toHexString(strokeRi), '0', 2) + 
           lpad(Integer.toHexString(strokeGi), '0', 2) + 
           lpad(Integer.toHexString(strokeBi), '0', 2);
  }
  
  String current() { //Call this method ribht before/after you call endRecord()
//      doc.append("</svg>");
    return doc.toString()+"</svg>";
  }
}
