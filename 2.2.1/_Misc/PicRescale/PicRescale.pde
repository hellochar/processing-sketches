File[] pics;

void setup() {
  size(900, 600);
  File dir = new File("C:\\Users\\hellochar\\Documents\\dev\\Processing\\sketches\\PicRescale\\data");
  pics = dir.listFiles();
}

int num = 1;

void draw() {
  Runtime.getRuntime().gc();
  PImage before = loadImage(pics[num].getName());
  println("loaded "+pics[num].getName()+", size: "+before.width+", "+before.height);
  PImage after = process(before);
  background(204);
  image(after, 0, 0);
  save("resized\\"+pics[num].getName());
  println("saved as "+"resized\\"+pics[num].getName());
  num++;
  if(num >= pics.length) exit();
}

//void keyPressed() {
//  if(keyCode == LEFT) num--;
//  else if(keyCode == RIGHT) num++;
//  num = num % pre.length;
//  if(key == ' ') {
//  }
//}

final static int LANDSCAPE = 1, PORTRAIT = 2, SQUARE = 3;

PImage process(PImage pre) {
  int type = 0;
  if(pre.width > pre.height * 1.2) type = LANDSCAPE;
  else if(pre.height > pre.width * 1.2) type = PORTRAIT;
  else type = SQUARE;
  PImage post = null;
  switch(type) {
    case LANDSCAPE:
      post = createImage(900, 600, RGB);
      post.copy(pre, 0, 0, pre.width, pre.height, 0, 0, post.width, post.height);
      break;
    case PORTRAIT:
    case SQUARE:
    PGraphics postG = createGraphics(900, 600, JAVA2D);
    post = postG;
    postG.beginDraw();
    postG.background(0);
    postG.imageMode(CENTER);
      PImage mid = createImage(pre.width, pre.height, RGB);
      mid.copy(pre, 0, 0, pre.width, pre.height, 0, 0, mid.width, mid.height);
      mid.resize(0, 600);
      postG.image(mid, postG.width/2, postG.height/2);
      postG.endDraw();
      break;
  }
  return post;
}
