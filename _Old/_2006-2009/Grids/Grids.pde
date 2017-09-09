PGraphics first, second, third, fourth;
boolean[][] cellsFirst;
boolean[][] cellsSecond;
boolean[][] cellsThird;
boolean[][] cellsFourth;
void setup() {
  size(600, 150);
  first = createGraphics(150, 150, JAVA2D);
  second = createGraphics(150, 150, JAVA2D);
  third = createGraphics(150, 150, JAVA2D);
  fourth = createGraphics(150, 150, JAVA2D);
  cellsFirst = new boolean[3][3];
  cellsSecond = new boolean[3][3];
  cellsThird = new boolean[3][3];
  cellsFourth = new boolean[3][3];
}

void draw() {
  first.beginDraw();
  first.stroke(0);
  first.background(0);  
  for(int x = 0; x < 3; x++) {
    for(int y = 0; y < 3; y++) {
      if(cellsFirst[x][y]) {
        first.fill(#FFFFFF);
        first.rect(x*50, y*50, 50, 50);
      }
    }
  }
  first.endDraw();
  second.beginDraw();
  second.stroke(0);
  second.background(0);  
  for(int x = 0; x < 3; x++) {
    for(int y = 0; y < 3; y++) {
      if(cellsSecond[x][y]) {
        second.fill(#FF0000);
        second.rect(x*50, y*50, 50, 50);
      }
    }
  }
  second.endDraw();
  third.beginDraw();
  third.stroke(0);
  third.background(0);  
  for(int x = 0; x < 3; x++) {
    for(int y = 0; y < 3; y++) {
      if(cellsThird[x][y]) {
        third.fill(#00FF00);
        third.rect(x*50, y*50, 50, 50);
      }
    }
  }
  third.endDraw();
  fourth.beginDraw();
  fourth.stroke(0);
  fourth.background(0);  
  for(int x = 0; x < 3; x++) {
    for(int y = 0; y < 3; y++) {
      if(cellsFourth[x][y]) {
        fourth.fill(#0000FF);
        fourth.rect(x*50, y*50, 50, 50);
      }
    }
  }
  fourth.endDraw();
  image(first, 0, 0);
  image(second, 150, 0); 
  image(third, 300, 0);
  image(fourth, 450, 0);
  stroke(#0000FF);
  line(150, 0, 150, 150);
  line(300, 0, 300, 150);
  line(450, 0, 450, 150);
}

void mousePressed() {
    int row = (mouseX%150)/50;
    int col = mouseY/50;
    if(mouseX > 450)
      cellsFourth[row][col] = !cellsFourth[row][col];
    else if(mouseX > 300)
      cellsThird[row][col] = !cellsThird[row][col];      
    else if(mouseX > 150)
      cellsSecond[row][col] = !cellsSecond[row][col];
    else if(mouseX <= 150) {
      cellsFirst[row][col] = !cellsFirst[row][col];
    }
   
}
