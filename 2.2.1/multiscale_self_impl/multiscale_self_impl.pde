import java.util.*;

World world;

void setup() {
  size(500, 500, JAVA2D);
  world = new World(width, height);
}

void draw() {
  world.step();
  
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      pixels[y*width+x] = color(map(world.getAmount(x, y), -1, 1, 0, 255));
    }
  }
  updatePixels();
  
  println(frameRate);
}

