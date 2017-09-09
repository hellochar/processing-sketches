float func(int x, int y, float amt) {
  float newAmt = amt;
  for(int i = -1; i < 2; i++) {
    for(int j = -1; j < 2; j++) {
      newAmt += (amt - getAmt(x+i, y+j));
    }
  }
  float k = newAmt / div - amt * mult;
  return k;
//  return sqrt(amt+7);
}

float getAmt(int x, int y) {
  return now[wrap(x, now.length)][wrap(y, now[0].length)];
}

public static float wrap(float x, float wrap) {
  if (x >= 0)
    return x % wrap;
  else
    return x % wrap + wrap;
}

public static int wrap(int x, int wrap) {
  if (x >= 0)
    return x % wrap;
  else
    return x % wrap + wrap;
}

