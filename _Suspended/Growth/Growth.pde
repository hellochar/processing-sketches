import zhang.*;

Set<Plant> plants;
Set<Plant> toAdd;
Set<Plant> toRemove;

Camera cam;

void setup() {
  size(600, 480);
  plants = new HashSet();
  toAdd = new HashSet();
  toRemove = new HashSet();
  colorMode(HSB);
  cam = new Camera(this);
  for(int i = 0; i < 5; i++) {
    plants.add(new Plant(random(width), random(height), 1));
//    if(random(1) < .5)
//      plants.add(new Plant(random(width), round(random(1))*height, 1));
//    else
//      plants.add(new Plant(round(random(1))*width, random(height), 1));
  }
}

void draw() {
  background(0);
  noFill();
  stroke(255);
  rect(0, 0, width, height);
  for(Plant p : plants) {
    p.run();
  }
  for(Plant p : plants) {
    p.update();
  }
  for(Plant p : plants) {
    p.draw();
  }
  plants.addAll(toAdd);
  toAdd.clear();
  print("removing "+toRemove.size()+", ");
  plants.removeAll(toRemove);
  toRemove.clear();
  println(frameRate+", "+plants.size());
}

