import java.awt.*;
import java.awt.geom.*;
import zhang.Camera;

class BGScroller {
  PImage img;
  float scrollScale;
  boolean wrap;
  
  public BGScroller(PImage i, float s, boolean w) {
    img = i;
    scrollScale = s;
    wrap = w;
  }
  
  void draw() {
    Graphics2D g2 = ((PGraphicsJava2D)g).g2;
    AffineTransform tx = g2.getTransform();
    
    float dx = (float)tx.getTranslateX(),
          dy = (float)tx.getTranslateY(),
          sx = (float)tx.getScaleX(),
          sy = (float)tx.getScaleY();
          
    float startX = -dx+dx*scrollScale,
          startY = -dy+dy*scrollScale; //these are model coordinates
    if(!wrap) {
      image(img, startX, startY);
    }
    else {
      //tile the viewport with images. Each image will have model dimensions [img.width, img.height]. 
//      float scaledWidth = img.width * sx,
//            scaledHeight = img.height * sy; //these are screen dimensions
      float scaledWidth = img.width,
            scaledHeight = img.height; //these are model dimensions

      //Iterate through the screen using model coordinates. Start behind the (0, 0) 
      for( float iterX = startX - scaledWidth; iterX < width * sx + dx; iterX += scaledWidth) {
        for( float iterY = startY - scaledHeight; iterY < height * sy + dy; iterY += scaledHeight) {
          image(img, iterX, iterY);
        }
      }
    }
    //todo: wrap
  }
}

BGScroller bgs;
Camera cam;

void setup() {
  size(500, 500);
  PGraphics test = createGraphics(250, 250, JAVA2D);
  test.beginDraw();
  test.rect(0, 0, test.width, test.height);
  stroke(0xFF9922);
  test.ellipse(25, 25, 50, 60); fill(251, 196, 210);
  test.triangle(0, 0, 100, 100, 210, 64);
  test.endDraw();
  bgs = new BGScroller(test, .025f, true);
  cam = new Camera(this);
}

void draw() {
  background(204);
  bgs.draw(); noFill(); stroke(0);
  rect(0, 0, width, height);
  ellipse(width/2, height/2, 150, 150);
}
