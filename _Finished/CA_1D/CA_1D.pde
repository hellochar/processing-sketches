//rule 110 - 01101110, where MSB = all on and LSB = all off.
int[] rule = {0, 1, 1, 0, 1, 1, 1, 0};
int black = color(0),
    white = color(255);
int row = 0;
int scale = 2;
PGraphics img;

void setup() {
  size(500, 500);
  img = createGraphics(width/scale, height/scale, P2D);
  render();
}

void mousePressed() {
  render();
}

void reset() {
  img.beginDraw();
  img.background(black);
  for(int x = 0; x < width; x++) {
    if(random(1) < .5) img.set(x, 0, white);
  }
//  set(width/2, 0, white);
  img.endDraw();
}

void draw() {
  image(img, 0, 0, width, height);
}

void render() {
  reset();
  for(row = 0; row < img.height; row++) {
    calculateRow();
    println(row*100f/img.height+"%");
  }
}

void calculateRow() {
  img.beginDraw();
  println("calc row "+row);
  for(int x = 0; x < width; x++) {
    int left = has(imgget(x-1, row)),
        mid =  has(imgget(x, row)),
        right = has(imgget(x+1, row));
    int val = 7 - (left << 2 | mid << 1 | right);
//    println(x+": "+left+", "+mid+", "+right+" -- "+val);
    img.set(x, row+1, invHas(rule[val]));
  }
  println("...done");
  img.endDraw();
//  row++;
}

int has(int val) {
  if(val == white) return 1;
  else return 0;
}

int invHas(int has) {
  if(has == 1) return white;
  else return black;
}

int imgget(int x, int y) {
  if(x < 0 || x >= width || y < 0 || y >= height) return black;
  return img.get(x, y);
}
