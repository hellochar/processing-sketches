import zhang.*;

List<int[]> aggregate;
Camera cam;

void setup() {
  size(1200, 700, P2D);
  aggregate = readFromCsv(".\\data\\test1.csv");
  cam = new Camera(this);
}

void draw() {
  background(0); noFill(); stroke(255);
  rect(0, 0, width, height);
//  int index = frameCount%aggregate.size();
//  displayDecomp(aggregate.get(index), width, height);
  PVector mm = cam.model(cam.mouseVec());
  int corner = (int)constrain(map(mm.y, 0, height, 0, 4), 0, 3);
  println(corner);
//  float[] rgb = 
  drawRGBs(aggregate, width, height);
}
