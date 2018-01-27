color bgColor = 0xff182026; // dark-gray1
color vermillion3 = 0xffD13913;
color vermillion2 = 0xffB83211;
color turquoise5 = 0xff2EE6D6;
color turquoise4 = 0xff14CCBD;

float hvnOffsetX = 10;
float hvnOffsetY = 10;

void setup() {
  size(960, 960);
//  println(PFont.list());

//  textFont(createFont("Bahnschrift Light", 320));
//  textFont(createFont("Century Gothic Regular", 320));
  textFont(createFont("Segoe UI Light", 320));
  textAlign(CENTER, CENTER);
  println(textWidth("HVN"));
  
  background(bgColor);

  for(float x = 0; x < width; x += textWidth("HVN")) {
    for (float y = 0; y < height; y += 224) { // exactly lines up the text
  //    fill(128, 50 - 0.15 * y);
//      fill(128, 10);
      fill(28, 36, 42);
      text("HVN", width/2 - hvnOffsetX + x, height/2 - hvnOffsetY + y);
      text("HVN", width/2 - hvnOffsetX + x, height/2 - hvnOffsetY - y);
      
      text("HVN", width/2 - hvnOffsetX - x, height/2 - hvnOffsetY + y);
      text("HVN", width/2 - hvnOffsetX - x, height/2 - hvnOffsetY - y);
    }
  }
  
  translate(0, -50);
  renderHVN(0, -200, vermillion3, turquoise5);
  renderHVN(0, 150, vermillion3, turquoise5);
 
}

void renderHVN(int offsetX, int offsetY, color hvnBackColor, color hvnFrontColor) {
  fill(hvnBackColor);
  text("HVN", width/2 - hvnOffsetX + offsetX, height/2 - hvnOffsetY + offsetY);
  fill(hvnFrontColor);
  text("HVN", width/2 + hvnOffsetX + offsetX, height/2 + hvnOffsetY + offsetY);
}

void mousePressed() {
  saveFrame("hvnhvn.png");
}

void draw() {
}
