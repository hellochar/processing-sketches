Date wantTime = new Date(2011 - 1900, 00, 16, 12+6, 0);

void setup() {
  size(500, 500);
  textFont(createFont("Arial", 36));
  println(levelsCorrected);
}

void draw() {
  background(0);
  stroke(255);
  smooth();
  textAlign(CENTER, CENTER);
  Date now = new Date();
  
//  Date remaining = new Date(wantTime.getTime() - now.getTime());
//  String s = app("", remaining.getDate());
//  s = app(s, remaining.getHours());
//  s = app(s, remaining.getMinutes());
//  s = app(s, remaining.getSeconds());
  
  long rem = wantTime.getTime() - now.getTime();
//  println("wantTime: "+wantTime+" ("+wantTime.getTime()+"), now: "+now+" ("+now.getTime()+")");
  String k = "";
  for(int i = 4; i != 0; i--) k = app(k, tiu(rem, i));
  text(k, width/2, height/2);
//  s = app(s, remaining.get
}

String app(String start, int num) {
  String numStr = String.valueOf(num);
  if(num < 10 && num >= 0) numStr = "0"+numStr; //pad to len 2.
  if(!start.equals("")) start += ":";
  return start + numStr;
}
