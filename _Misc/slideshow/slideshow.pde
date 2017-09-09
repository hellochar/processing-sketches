

PImage[] pics;
String[] quotes = new String[0];
PFont f;

public static long MILLIS_BETWEEN_PICS = 7000,
                   MILLIS_TRANSITION = 200;
public static float MAX_X_OR_Y_SPEED_PER_SECOND = 50,
                    QUOTE_MAX_WIDTH = 600;

//PGraphics textBlur;

void setup() {
  size(screen.width, screen.height);
  f = loadFont("ArialNarrow-BoldItalic-30.vlw");  
//  textBlur = createGraphics(width, height, JAVA2D);
//  textBlur.beginDraw();
//  textBlur.textFont(f);
//  textBlur.textAlign(LEFT, TOP);
  textFont(f);
  textAlign(LEFT, TOP);
//  textBlur.endDraw();
//  textFont(f);
//  textAlign(LEFT, TOP);
try{
  BufferedReader in = new BufferedReader(new InputStreamReader(createInput("quotes.txt")));
  try{
  String s = "";
  while((s = in.readLine()) != null) {
    if(s.length() > 0)
      quotes = append(quotes, s);
  }
    println("Loaded "+quotes.length+" quotes!");
  }catch(Exception e) {println("Could not load quotes: "+e);}
  
  File f = new File(dataPath(""));
  File[] files = f.listFiles();
  background(0);
//  pics = new PImage[files.length];
//  pics = new PImage[5];
  pics = new PImage[0];
  for(int i = 0; i < 30; i++) {
    String s = files[i].getName();
    String ext = s.substring(s.lastIndexOf('.')).toLowerCase();  
    if(ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png")) {
//      pics[i] = loadImage(s);
//      PImage img = loadImage(s);
      PImage img = requestImage(s);
      pics = (PImage[]) append(pics, img);
      text("Loaded "+pics.length+" of about "+files.length+" pictures... ("+img.width+", "+img.height+")", 0, i*30);
    }
    else {
      println("Skipped "+s+" with ext "+ext);
    }
//    println(files[i].getPath()+", "+files[i].getName()+", "+files[i].isHidden());
//    if(files[i]
  }
//  println(f);
//  PImage i = loadImage(
  randomizeQuotes();
  randomize();
}catch(Exception e) {
  noLoop();
  background(0);
  e.printStackTrace();
  text("Error: "+e.toString(), width/2, height/2);
}
}

void randomize() {
  //not the best randomize but it works
  for(int i = 0; i < pics.length; i++) {
    PImage t = pics[i];
    int r = (int)random(pics.length);
    pics[i] = pics[r];
    pics[r] = t;
  }
  curIndex = 0;
}

void randomizeQuotes() {
  //not the best randomize but it works
  for(int i = 0; i < quotes.length; i++) {
      String t = quotes[i];
    int r = (int)random(quotes.length);
    quotes[i] = quotes[r];
    quotes[r] = t;
  }
  curQuoteIndex = 0;
  newQuote();
}

void newQuote() {
//    textBlur.beginDraw();
//    textBlur.background(255);
//    textBlur.fill(0);
    String s = quotes[curQuoteIndex];
    qX = random(0, width-QUOTE_MAX_WIDTH);
    qY = random(0, height- 30 * (1+(int)(textWidth(s)/QUOTE_MAX_WIDTH)));
////    println(textBlur.textWidth(s));
//    textBlur.text(s, qX, qY, QUOTE_MAX_WIDTH, height);
//    textBlur.filter(BLUR, 5);
//    textBlur.filter(THRESHOLD, .2);
//    textBlur.fill(255);
//    textBlur.text(s, qX, qY, QUOTE_MAX_WIDTH, height);
//    textBlur.endDraw();
//    println("new!");
}

int curQuoteIndex = 0;

void changePics() {
//    last = pics[curIndex];
    if(++curQuoteIndex >= quotes.length) {
      randomizeQuotes();
    }
    if(++curIndex == pics.length) {
      randomize();
    }
    PImage curPic = pics[curIndex];
    while(curPic.width == 0) {
      if(++curIndex == pics.length) {
        randomize();
      }
      curPic = pics[curIndex];
    }
    dx = random(-MAX_X_OR_Y_SPEED_PER_SECOND, MAX_X_OR_Y_SPEED_PER_SECOND);
    if(abs(dx*10) > curPic.width-width) dx = abs(dx)/(curPic.width-width);
//    dx = (random(1)<.5?1:-1) * .1 * (curPic.width-width);
    if(dx < 0) { //moving left
      x = random(-dx*10, curPic.width-width);
    }
    else {
      x = random(0, curPic.width-width - dx*10);
    }
    
    dy = random(-MAX_X_OR_Y_SPEED_PER_SECOND, MAX_X_OR_Y_SPEED_PER_SECOND);
    if(abs(dy*10) > curPic.height-height) dy = abs(dy)/(curPic.height-height);
    if(dy < 0) { //moving left
      y = random(-dy*10, curPic.height-height);
    }
    else {
      y = random(0, curPic.height-height - dy*10);
    }
    
    millisRemaining = MILLIS_BETWEEN_PICS;
}

long millisRemaining, lastMillis;
//PImage last;
int curIndex;
float x, y, dx, dy;
float qX, qY;

void draw() {
  try{
  background(0);
  if(millisRemaining <= 0) {
    changePics();
  }
  PImage p = pics[curIndex];
  float alphaForCurIndex = constrain(map(millisRemaining, MILLIS_BETWEEN_PICS, MILLIS_BETWEEN_PICS-MILLIS_TRANSITION, 0, 255), 0, 255);
  tint(color(255), alphaForCurIndex);
//  tint(color(255), 1);
//  translate(x += dx, y += dy);
  image(p, -x, -y);
//  if(alphaForCurIndex < 255 && last != null) {
//    tint(color(255), 255-alphaForCurIndex);
//    image(last, -x, -y);
//  }
  long timeElapsed = millis() - lastMillis;
  lastMillis = millis();
  x += dx/1000*timeElapsed;
  y += dy/1000*timeElapsed;
  millisRemaining -= timeElapsed;
  
  String s = quotes[curQuoteIndex];
//  fill(0);
//  text(s, qX-2, qY-2, QUOTE_MAX_WIDTH, width);
  fill(255);
  text(s, qX, qY, QUOTE_MAX_WIDTH, width);

//  image(textBlur, 0, 0);

//  println(30+", "+textWidth(s));
//  println(x+", "+y+"("+p.width+", "+p.height+")");
//  println(millisRemaining+": "+p.width+", "+p.height+" ("+curIndex+") -- "+last.width+", "+last.height+" ("+(curIndex+pics.length-1)%pics.length+"). "+alphaForCurIndex);
  }catch(Exception e) {
    e.printStackTrace();
    background(0);
    text(e.toString(), 0, 0);
    changePics();
  }
  
}
