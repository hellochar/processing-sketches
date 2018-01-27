/*
  Use the phase information collected from the phase unwrapping
  and propagate it across the boundaries.
*/

LinkedList toProcess;

void propagatePhases() {
  int startX = inputWidth / 2;
  int startY = inputHeight / 2;

  toProcess = new LinkedList();
  toProcess.add(new int[]{startX, startY});
  _process[startX][startY] = false;

  while (!toProcess.isEmpty()) {
    int[] xy = (int[]) toProcess.remove();
    int x = xy[0];
    int y = xy[1];
    float r = _wrapphase[y][x];
    
    // propagate in each direction, so long as
    // it isn't masked and it hasn't already been processed
    if (y > 0 && !_mask[y-1][x] && _process[y-1][x])
      unwrap(r, x, y-1);
    if (y < inputHeight-1 && !_mask[y+1][x] && _process[y+1][x])
      unwrap(r, x, y+1);
    if (x > 0 && !_mask[y][x-1] && _process[y][x-1])
      unwrap(r, x-1, y);
    if (x < inputWidth-1 && !_mask[y][x+1] && _process[y][x+1])
      unwrap(r, x+1, y);
  }
}

void unwrap(float r, int x, int y) {
  float frac = r - floor(r);
  float myr = _wrapphase[y][x] - frac;
  if (myr > .5)
    myr--;
  if (myr < -.5)
    myr++;

  _wrapphase[y][x] = myr + r;
  _process[y][x] = false;
  toProcess.add(new int[]{x, y});
}
