/*
 * 1. Sketch created by Martyn McDermott - martyn@hm-marketing.com
 * 2. Sketch modified by supamanu - etabarly@gmail.com
 * multiplekeys taken from http://processinghacks.com/hacks:multiplekeys
 * @author Yonas Sandbæk http://seltar.wliia.org
 * 3. sketch modified by greg, gmtlangham@gmail.com
 * could not get font to load, so i took my best stab at it.
 * 4. Sketch modified by hellochar
 */

int DirX = 400;
int DirY = 300;

/* properties added by <supamanu> */
PFont font;
float mapH;
float mapS;
float mapB;
float rotAngle; // rotation of the flower
float hueComp;
float scaleFactor; // scale factor of the flower


/*Added by hellochar. img will hold the blurred image.*/
PImage img;

void setup() {
  size(800, 600);

  //<supamanu> load a font that dispalys flowers and center it
  // font = loadFont("saru's_Flower_Ding_(sRB)-36.vlw");
  //textFont(font);
  //textAlign(CENTER, CENTER);

  //<supamanu> set color mode to HSB and set ranges accordingly
  //greg- changed color mode
  //<hellochar> changed color mode to HSB again :) - note that the ranges are still between 0 - 255, even in HSB.
  colorMode(HSB);

  //<hellochar> get a copy of the current image
  img = g.get();

}

/* to enable diagonal movement, we wanted to check for keys pressed at the 
 same time. Rather than using keyPressed and keyReleased in the usual way, 
 these methods check to see which keys are being pressed and we use checkKey 
 to test which keys are held down.
 at the moment w=UP - s=DOWN - a=LEFT - d=RIGHT */

boolean[] keys = new boolean[526];
boolean checkKey(String k)
{
  for(int i = 0; i < keys.length; i++)
    if(KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) return keys[i];  
  return false;
}

void keyPressed()
{ 
  keys[keyCode] = true;
  println(KeyEvent.getKeyText(keyCode));
}

void keyReleased()
{ 
  keys[keyCode] = false; 
}


void draw() {

  //wipe the background
  // background(240);

  //<supamanu> make the Hue of the ellipse complementary to that of the flower
  if(mapH<=180) {
    hueComp = mapH + 180;
  } 
  else {
    hueComp = mapH - 180;
  }
  //<hellochar> changed from fill(hueComp, 50, 50, 100) to what it is now; stands out better
  fill(hueComp, 255, 255, 100);

  //draw the ellipse  
  strokeWeight(1);
  stroke(23);
  ellipseMode(CENTER);
  ellipse(DirX, DirY, 50, 50);


  // <supamanu> rotate the flower at every draw() by a small angle (rotAngle)
  // and do the necessary transformations so that it is displayed at the center of the ellipse
  rotAngle+=PI/64;
  translate(DirX, DirY);
  rotate(rotAngle);
  // change scale so that it alternates between -2 and 2
  // note: I divided rotAngle by 4 so that it doesn't "pulse" too fast
  scaleFactor=cos(rotAngle/4) + sin(rotAngle/4+PI/2);
  println(scaleFactor);
  scale(scaleFactor);
  // give the flower a hue and saturation based on it's (x,y) position
  // a brightness based on scale
  // and an alpha of 80  
  //<hellochar> - commented out, replaced with maps from 0 to 255
  //  mapH = map(DirX, 0, width, 0, 360); // map hue to width
  //  mapS = map(DirY, 0, height, 50, 100); // map saturation to height
  //  mapB = map(scaleFactor, -2, 2, 50, 100); // map brightess to scale
  //  fill(mapH, mapS, mapB, 80);

  //<hellochar>
  mapH = map(DirX, 0, width, 0, 255); // map hue to width
  mapS = map(DirY, 0, height, 0, 255); // map saturation to height
  mapB = map(scaleFactor, -2, 2, 0, 255); // map brightess to scale
  fill(mapH, mapS, mapB, 80);


  // display the flower on stage - represented by the letter "z"
  //  text("z", 0, 0);


  // change ellipse position based on the keys pressed
  //<supamanu> added the arrow keys for those of us on an azerty keyboard... ;P
  //greg - made random shit draw when you press keys, made their arcs sensitive to mouse
  if (checkKey("w") || checkKey("UP")){
    DirY = DirY - 5;
    stroke(255);
    rect(mapH/10-mouseX/mouseY, mapS/10, 10, 10);
  }
  if (checkKey("s")|| checkKey("DOWN")){
    DirY = DirY + 5;
    ellipse(mapH/mapB, mapS/mapB-mouseX/mouseY, mapB, 50);
  }
  if (checkKey("a")|| checkKey("LEFT")){
    DirX = DirX - 5;
    ellipse(mapH-mapS-mouseX+mouseY, mapS-mapH, mapB, 50);
  }
  if (checkKey("d")|| checkKey("RIGHT")){
    DirX = DirX + 5;
    line(DirX, DirY, DirY-DirX-mouseX, DirX-DirY-mouseY);
  }

  //<hellochar> do stuff
  {
    img = g.get(); //Get a copy of the current image
    fastSmallShittyBlur(g.get(), img); //blur the image and save it to "img"
    resetMatrix(); //move the image to where the circle is
    translate(DirX, DirY);
    rotate(rotAngle);
    scale(.086+(2+scaleFactor)/4); //.086 makes it so that img will always cover up the original red circle (it didn't really look good to me to have it sticking out every period)
    translate(-width/2, -height/2); //center the image
    image(img, 0, 0, width, height); //display it
  }
  println("frameRate: "+frameRate);
}

/* <hellochar> - copied from http://www.openprocessing.org/visuals/?visualID=5383.
 Fast: 40 times faster than filter(BLUR,1);
 Small: Available only in 1 pixel radius
 Shitty: Rounding errors make image dark soon
 What happens:
 11111100 11111100 11111100 11111100 = mask
 AAAAAAAA RRRRRRRR GGGGGGGG BBBBBBBB = PImage.pixel[i]
 AAAAAA00 RRRRRR00 GGGGGG00 BBBBBB00 = masked pixel
 AA AAAAAARR RRRRRRGG GGGGGGBB BBBBBB00 = sum of four masked pixel, alpha overflows, who cares
 00AAAAAA RRRRRRRR GGGGGGGG BBBBBBBB 00 = shift results to right -> broken alpha, good RGB (rounded down) averages
 */
void fastSmallShittyBlur(PImage a, PImage b){ //a=src, b=dest img
  int pa[]=a.pixels;
  int pb[]=b.pixels;
  int h=a.height;
  int w=a.width;
  final int mask=(0xFF&(0xFF<<2))*0x01010101;
  for(int y=1;y<h-1;y++){ //edge pixels ignored
    int rowStart=y*w  +1;
    int rowEnd  =y*w+w-1;
    for(int i=rowStart;i<rowEnd;i++){
      pb[i]=(
      ( (pa[i-w]&mask) // sum of neighbours only, center pixel ignored
      +(pa[i+w]&mask)
        +(pa[i-1]&mask)
        +(pa[i+1]&mask)
        )>>2)
        |0xFF000000 //alpha -> opaque
        ;
    }
  }
}


