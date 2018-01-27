String[] wlist;

void setup() {
  size(500, 500);
  wlist = loadStrings("./wlist.txt");
  if(wlist == null) {
    println("lvl 2");
    wlist = loadStrings("wlist.txt");
    if(wlist == null) {
      println("lvl 3");
      wlist = loadStrings(param("wlist-url"));
    }
  }
}

void draw() {
  if(wlist == null) {
    background(0);
    textSize(80);
    text("wlist is null! Searched in \n"+dataPath("./wlist.txt")+"\n"+dataPath("wlist.txt")+"\n and "+param("wlist-url"), width/2, height/2);
  }
  else {
    text(wlist[0], 20, 30);
  }
}
