import java.util.*;

PGraphics cgi;
PImage bg, defaultBg;
Frame cgiFrame, bgFrame;
PGraphics gui;
int guiHOffset;

Pen curPen;

Button[] allButtons;
static PenButton circles, rects, lines;

String bgName = "test.jpg";

void setup() {
  bg = loadImage(bgName);
  defaultBg = createImage(bg.width, bg.height, RGB);
  copyImage(bg, defaultBg);
  cgi = createGraphics(bg.width, bg.height, JAVA2D);
  size((bg.width + 20) * 2, bg.height + 100 + 20);
  guiHOffset = height - 100;
  allButtons = new Button[0];
  
  cgiFrame = new Frame(0, 0, width / 2, guiHOffset, 10, 10, cgi);
  cgiFrame.setInsetColor(color(255));
  
  bgFrame = new Frame(width / 2 + 1, 0, width / 2, guiHOffset, 10, 10, bg);
  bgFrame.setInsetColor(color(0));
  
  gui = createGraphics(width, 100, JAVA2D);
//  initFinals();
  drawGui();
  rects.action();
  cgi.beginDraw();
  cgi.background(255);
}

void draw() {  
  if(mousePressed & mouseX == pmouseX & mouseY == pmouseY)
    curPen.function(mouseX, mouseY, pmouseX, pmouseY);
  cgi.endDraw();
  cgiFrame.update();
  bgFrame.update();
  cgiFrame.draw();
  bgFrame.draw();
  drawGui();
  stroke(color(0));
  line(width / 2, 0, width / 2, guiHOffset);
  line(0, guiHOffset, width , guiHOffset);
//  println(frameRate);
  cgi.beginDraw();
}

public void drawGui() {
  gui.beginDraw();
  gui.background(204);
  gui.smooth();
  for(int a = 0; a < allButtons.length; a++) {
    allButtons[a].run();
  }
  gui.endDraw();
  image(gui, 0, guiHOffset);
}


void curves(int c, float thick, float tight, int num) {
  cgi.noFill();
  cgi.smooth();
  cgi.stroke(c);
  cgi.curveTightness(tight);
  cgi.strokeWeight(thick);
  for(int a = 0; a < num; a++) {
    cgi.curve(random(width), random(height), random(width), random(height), random(width), random(height), random(width), random(height));
  }
}

void mouseDragged() {
  curPen.function(mouseX, mouseY, pmouseX, pmouseY);
}

void keyPressed() {
  if(key == 's') {
    println(save());
  }
  else if(key == 'b') {
    bg.blend(cgi, 0, 0, bg.width, bg.height, 0, 0, bg.width, bg.height, ADD);
  }
  else if(key == 'r') {
    copyImage(defaultBg, bg);
  }
  else if(key == 'c') {
    cgiFrame.update();
    curves(color(0, 100), 2.5, 18.5, 20);
  }
}

PImage copyImage(PImage p1, PImage p2) {
  p2.copy(p1, 0, 0, p1.width, p1.height, 0, 0, p2.width, p2.height);
  return p2;
}



String save() {
  background(color(204));
  image(bg, 0, 0);
  String s = bgName.substring(0, bgName.length() - 4)+"-";
  GregorianCalendar gc = new GregorianCalendar(Locale.US);
  int m = gc.get(gc.MONTH)+1;
  if(m < 10) s += "0";
  s += String.valueOf(m);
  
  int d = gc.get(gc.DAY_OF_MONTH);
  if(d < 10) s += "0";
  s += String.valueOf(d)+String.valueOf(gc.get(gc.YEAR))+".jpg";
  save(s);
  return s;
}
