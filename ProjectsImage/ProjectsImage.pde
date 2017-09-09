import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;

PGraphics img;
PFont myFont;

void setup() {
  size(1024, 200);
  myFont = loadFont("Arial-Black-120.vlw");
  
  img = createGraphics(width, height, JAVA2D);
  PGraphics buffer = createGraphics(width, height, JAVA2D);
  buffer.beginDraw();
  buffer.textFont(myFont);
  buffer.textSize(180);
  buffer.textAlign(CENTER, CENTER);
  buffer.text("Projects", width/2, height/4);
  buffer.endDraw();
  
  img.beginDraw();
  img.background(0, 0);
  img.smooth();
  img.noStroke();
  img.fill(255, 255, 0);
  float sep = 20;
  for(float x = 0; x <= width+sep; x += sep) {
    for(float y = 0; y <= height+sep; y+= sep) {
      float bright = brightness(buffer.get((int)x, (int)y));
      float rad = map(bright, 0, 255, 5, sep);
      img.ellipse(x, y, rad, rad);
    }
  }
  img.endDraw();
  image(img, 0, 0);
  img.save("projects.png");
//  image(buffer, 0, 0);
}
