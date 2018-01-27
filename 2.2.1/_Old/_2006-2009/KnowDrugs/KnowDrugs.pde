PImage img;

void setup() {
  float s = 8.5, l = 11;
  float ws = 22, wl = 28;
  float sRatio = ws/s, lRatio = wl/l;
  size(ceil(1024*sRatio), ceil(768 * lRatio));
  textFont(loadFont("AbadiMT-CondensedExtraBold-200.vlw"), 150);
  smooth();
  textAlign(LEFT, TOP);
  img = loadImage("pic.PNG");
//  float ratio = (float)width/temp.width;
  //float r2 = (float)temp.height / temp.width;
//  img = createImage(width, int(width*r2), RGB);
  //img.copy(temp, 0, 0, temp.width, temp.height, 0, 0, img.width, img.height);
  runOnce();
  noLoop();
}

void runOnce() {
  img.loadPixels();
  println(img.pixels.length+"... "+img.width+" x "+img.height);
  for(int x = 0; x < img.width; x++) {
    for(int y = 0; y < img.height; y++) {
      try{
        img.pixels[y*img.height+x] = lerpColor(img.pixels[y*img.height+x], color(20), (float) y / img.height);
      }catch(Exception e) {
        println(e+": "+x+", "+y+" - "+(y*img.height+x));
        e.printStackTrace();
    }
  }
  }
  img.updatePixels();
}

String[] things = {"", "you", "body", "mind", "health", "life", "family", "friends", "future", "personality", "thoughts", "concentration", "expectations", "more"};

void draw() {
  image(img, -100, -60, width * 2, height * 2);
//  image(img, 0, 0);
  float k = textDescent()+textAscent();
  for(int a = 0; a < things.length; a++) {
    textOn(things[a], (float)a / (things.length), 20+a*k);
  }
  save("this.JPG");
}

void textOn(String s, float g, float y) {
  g = 1-g;
  color c = lerpColor(color(0, 0), color(255, 255), g);
  if(s.compareTo("") == 0) {
  fill(color(255));
  text("Do you know what drugs do?", 0, y);
  }
  else if(s.compareTo("you")==0) {
    fill(c);
    text("Do you k", 0, y);
    float l = textWidth("Do you k");
    fill(color(255));
    text("no", l, y);
    l += textWidth("no");
    fill(c);
    text("w what ", l, y);
    l += textWidth("w what ");
    fill(color(255));
    text("drugs", l, y);
    l += textWidth("drugs");
    fill(c);
    text(" do to you?", l, y);
  }
  else if(s.compareTo("more")==0) {
    fill(color(255));
    float l = textWidth("Do you ");
    text("know", l, y);
    l += textWidth("know what ");
    text("more", l, y);
  }
  else {
    fill(c);
    text("Do you k", 0, y);
    float l = textWidth("Do you k");
    fill(color(255));
    text("no", l, y);
    l += textWidth("no");
    fill(c);
    text("w what ", l, y);
    l += textWidth("w what ");
    fill(color(255));
    text( "drugs", l, y);
    l += textWidth("drugs");
    fill(c);
    text( " do to your "+s+"?", l, y);
  }

}
