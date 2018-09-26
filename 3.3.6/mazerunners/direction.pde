
enum Direction { LEFT, RIGHT, UP, DOWN };
Direction[] DIRECTIONS = Direction.values();

void drawDirection(Direction d) {
  pushMatrix();
  switch (d) {
    case LEFT:
      break;
    case RIGHT:
      rotate(PI);
      break;
    case UP:
      rotate(-PI / 2);
      break;
    case DOWN:
      rotate(PI / 2);
      break;
  }
  line(-5, 0, 5, 0);
  line(5, 0, 2, 3);
  line(5, 0, 2, -3);
  popMatrix();
}

Direction randomDirection() {
  return DIRECTIONS[(int)random(0, DIRECTIONS.length)];
}

Direction[] randomPath() {
  Direction[] path = new Direction[GEN_LIFETIME];
  for (int i = 0; i < GEN_LIFETIME; i++) { 
    path[i] = randomDirection();
  }
  return path;
}