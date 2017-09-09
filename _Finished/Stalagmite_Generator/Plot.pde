public void plot(int x, int y) {
  //The plane grapher works by taking (x, y, (x-1, y, (x-1, y-1) and (x, y-1).
  //If the point's coordinates are less than zero, then it's out of range.
  //Then, one only need to graph when both x and y are above 0.
  if (x-incr >= 0 && y-incr >= 0) {
    float[][] vertices = new float[4][3]; //four points, three coordinates to each point
    int[] colors = new int[4]; //1 color for each point
    vertices[0] = new float[] {x,    y,     getValue(x, y)};                   colors[0] = cdata[x][y];
    vertices[1] = new float[] {x-incr,  y,     getValue(x-incr, y)};           colors[1] = cdata[x-incr][y];
    vertices[2] = new float[] {x-incr,  y-incr,   getValue(x-incr, y-incr)};   colors[2] = cdata[x-incr][y-incr];
    vertices[3] = new float[] {x,    y-incr,   getValue(x, y-incr)};           colors[3] = cdata[x][y-incr];
    //check to make sure the points are all within the viewing window
//    for (float[] fs : vertices) { //this might actually be slower
//        float screenX = g.screenX(fs[0], fs[1], fs[2]),
//              screenY = g.screenY(fs[0], fs[1], fs[2]);
//        if(!zhang.Methods.isInWindow(screenX, screenY, g.width, g.height)) return; //terminate
//    }
    //if they all are, then vertex them
    beginShape();
    for(int i = 0; i < 4; i++) {
      float[] fs = vertices[i];
      fill(colors[i]);
      vertex(fs[0], fs[1], fs[2]);
    }
    endShape();
  }
}

public int getValue(int xNot, int yNot) {
  return cave[xNot][yNot];
}
