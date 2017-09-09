import java.awt.datatransfer.StringSelection;
  
import java.awt.*;
ByteArrayOutputStream out;

PImage img;

void setup() {
  size(500, 500);
  out = new ByteArrayOutputStream(4*100+5);
  System.setOut(new PrintStream(out));
  img = loadImage("image.jpg");
}

void draw() {
  background(210, 160, 0);
  long before = System.currentTimeMillis();
  for(int i = 0; i < 10000; i++) {
    image(img, random(width)-img.width/2, random(height)-img.height/2);
//    image(png, random(width), random(height));
//    ellipse(random(width), -random(height), 15, 15);
  }
  long after = System.currentTimeMillis();
  println(""+(after-before));
  System.err.println(""+(after-before));
  if(frameCount > 100) {
    StringSelection ss = new StringSelection(out.toString());
    Toolkit.getDefaultToolkit().getSystemClipboard().setContents(ss, null);
    exit();
  }
}
