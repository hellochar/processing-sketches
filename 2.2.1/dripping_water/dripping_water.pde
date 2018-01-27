cell[][] all;

void setup() {
  size(500, 500);
  all = new cell[100][100];
  cell_width = width / all.length;
  cell_height = height / all[0].length;
  
  for(int x = 0; x < all.length; x++) {
    for(int y = 0; y < all[0].length; y++) {
      all[x][y] = new cell(x, y);
    }
  }
}

void draw() {
  background(255);
  if(mousePressed) {
    try{
      cell c = cellAt((int)(mouseX/cell_width), (int)(mouseY/cell_height));
      c.setAmt(c.getAmt() + (1 - c.getAmt()) * .5);
      println("set "+c+"!");
    }catch(ArrayIndexOutOfBoundsException e) {
    }
  }
  for(cell[] cl : all) {
    for(cell c : cl) {
      c.run();
    }
  }
  
  for(cell[] cl : all) {
    for(cell c : cl) {
      c.update();
    }
  }
  
  for(cell[] cl : all) {
    for(cell c : cl) {
      c.draw();
    }
  }
  println(frameRate);
}

public cell cellAt(int x, int y) throws ArrayIndexOutOfBoundsException {
  return all[x][y];
}
