import java.util.*;

List<Cell> cells = new ArrayList();
Cell avg;

int[] counts;

void setup() {
  size(1200, 800);
  counts = new int[width*height];
  for(int i = 0; i < 500; i++) {
    cells.add(new Cell());
  }
  background(0);
}

void draw() {
  for( int z = 0; z < 100; z++) {
    avg = computeAverageCell();
    
    for( Cell c : cells ) {
      c.run();
    }
    for( Cell c : cells ) {
      c.update(.5);
      counts[c.getCurrentPositionIndex()] += 1;
  //    c.draw();
    }
  }
  float maxCount = max(counts);
  loadPixels();
  for( int i = 0; i < pixels.length; i++) {
    pixels[i] = color(255 * sqrt(counts[i] / maxCount));
  }
  updatePixels();
  println(frameRate);
}

Cell computeAverageCell() {
  Cell avg = new Cell();
  for( Cell c : cells ) {
    avg.x += c.x;
    avg.y += c.y;
    avg.dx += c.dx;
    avg.dy += c.dy;
    avg.radius += c.radius;
  }
  avg.x /= cells.size();
  avg.y /= cells.size();
  avg.dx /= cells.size();
  avg.dy /= cells.size();
  avg.radius /= cells.size();
  
  return avg;
}

class Cell {
  float x, y, dx, dy;
  float radius;
  
  float forceX = 0, forceY = 0;
  
  Cell() {
    this.x = random(width);
    this.y = random(height);
    dx = dy = 0;
    radius = random(5, 25);
  }
  
  int getCurrentPositionIndex() {
    return (int)y * width + (int)x;
  }
  
  void run() {
    // compute forceX and forceY
    // F = distance offset factor
    float F = 0.025;
    forceX += -(x - avg.x) * F;
    forceY += -(y - avg.y) * F;
    
    // G = velocity offset factor
    float G = 0.0;
    forceX += -(dx - avg.dx) * G;
    forceY += -(dy - avg.dy) * G;
    
    // pick a random cell and repel from it
    Cell otherCell = cells.get((int)random(cells.size()));
    if ( otherCell != this ) {
      float offsetX = (x - otherCell.x),
            offsetY = (y - otherCell.y),
            dist2 = offsetX * offsetX + offsetY * offsetY,
            dist = sqrt(dist2);
      float ax = offsetX / dist2 * 20;
      float ay = offsetY / dist2 * 20;
      forceX += ax;
      forceY += ay;
      
      otherCell.forceX -= ax;
      otherCell.forceY -= ay; 
    }
  }
  
  void update(float dt) {
    forceX /= radius;
    forceY /= radius;
    
    dx += forceX * dt;
    dy += forceY * dt;
    x += dx * dt;
    y += dy * dt;
    
    x = ((x % width) + width) % width;
    y = ((y % height) + height) % height;
   
    forceX = 0;
    forceY = 0; 
  }
  
  void draw() {
    noStroke();
    fill(255, 0, 0, 1);
    ellipse(x, y, radius, radius);
//    ellipse(x + width, y, radius, radius);
//    ellipse(x + width, y + height, radius, radius);
//    ellipse(x, y + height, radius, radius);
  }
}

//void wrappedEllipse(float x, float y, float radiusX, float radiusY) {
//  float newX = ((x % width) + width) % Width;
//  float newY = ((y % height) + height) % height;
//  ellipse(newX, newY, radiusX, radiusY);
//}
