import zhang.*;

Set nodes;
Camera c;

final Growth[] growths = new Growth[] {
  new GrassGrowth(), new GrowthPattern(), new FlowerGrowth(), new BranchGrowth(), new SimulGrowth() };

int lineMode = CURVE;
final static int NONE = 0,
LINE = 1,
CURVE = 2,
BEZIER = 3;
//                 ELLIPSE = 11,
//                 SQ = 12, //square
//                 TRIANGLE = 13;

GrowthPattern p;
MNode main;
Set leaves;

boolean displayPattern = true;
boolean dangerous = false;
boolean smooth = false;

public final static int DANGER_THRESH = 1500;
float lineHeight;
boolean first = true;

void setup() {
  //  Dimension d = Toolkit.getDefaultToolkit().getScreenSize();
  //  size(d.width, d.height);
  size(800, 600);
  c = new Camera(this);
  c.registerScroll(false, 1.09f);
  //        smooth();
  //        println(PFont.list());
  textFont(loadFont("EuphemiaCAS.vlw"));
  textAlign(LEFT, CENTER);
  fill(0);
  noStroke();
    text("wasd or arrows to move the screen\n"+
      "'-'/'=' to zoom in/out\n"+
      "' ' (space) to grow\n"+
      "'p' to toggle text display\n"+
      "'o' to toggle smooth\n"+
      "'r' to reset\n", width/2 - 100, height/2);
  lineHeight = textAscent() + textDescent();
  textAlign(LEFT, TOP);
  //create a growth pattern
  reset();

  //        Set set = p.grow(main);
  //        set = p.grow(set);
}

void reset() {
  nodes = new HashSet();
  do{ 
    p = (GrowthPattern) createRandomInstance(growths[1]);
    println(p.getGrowNum());
  }
  while(p.getGrowNum() > 4000);
  main = new MNode( width / 2, height * .9f - 32, 32, .09f, -PI/2, color(random(255), random(255), random(255)));
  leaves = new HashSet();
  leaves.add(main);
  dangerous = false;
  grow();
}

void grow() {
  if(leaves.size() * p.getGrowNum() > 100000) return;
  leaves = p.grow(leaves);
  if(leaves.size() * p.getGrowNum() > DANGER_THRESH) {
    dangerous = true;
  }
  //        println("Grew "+(leaves.size()-num + 1)+", a total of "+nodes.size()+" nodes!");
}

public void mousePressed() {
  first = false;
}

public void keyPressed() {
  first = false;
  if(key == 'p') {
    displayPattern = !displayPattern;
  }
  else if(key == 'o') {
    if(smooth) {
      smooth = false;
      noSmooth();
    }
    else {
      smooth = true;
      smooth();
    }
  }
  else if(key == ' ') {
    grow();
  }
  else if(key == 'r') {
    reset();
  }
}

void draw() {
  //        println(frameRate);
  if(first) {
    return;
  }
  background(204);
  if(displayPattern) {
    fill(0);
    p.show();
    resetMatrix();
  }
  if(dangerous) {
    fill(255, 0, 0);
    textAlign(RIGHT, TOP);
    text("!!!!!!!!\n" +
      "!!!!!!!!\n" +
      "!!!!!!!!\n" +
      "!!!!!!!!\n" +
      "!!!!!!!!\n" +
      "!!!!!!!!\n" +
      "!!!!!!!!\n" +
      "!!!!!!!!\n" +
      "!!!!!!!!", width-10, 0);
    textAlign(LEFT, TOP);
  }
  //        text(String.valueOf(frameRate), 0, 0);
  c.scroll(10);
  c.apply();
  Iterator i = nodes.iterator();
  while(i.hasNext()) {
    MNode n = (MNode) i.next();
    n.act();
  }
  i = nodes.iterator();
  while(i.hasNext()) {
    MNode n = (MNode) i.next();
    n.drawConnects();
  }
  i = nodes.iterator();
  while(i.hasNext()) {
    MNode n = (MNode) i.next();
    n.drawEllipses();
  }
  //  println(frameRate);
}


public Growth getRandomGrowth() {
  return createRandomInstance(growths[(int)random(growths.length)]);
}

public Growth createRandomInstance(Growth g) {
  //  println("Creating a random "+g.getClass().getSimpleName());
  return g.createRandom();
}


