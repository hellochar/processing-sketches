
public static String lpad(String s, char c, int wantLen) {
  return makeStr(c, wantLen - s.length()) + s;
}

public static String makeStr(char c, int len) {
  StringBuilder b = new StringBuilder(len);
  for (int i = 0; i < len; i++) {
    b.append(c);
  }
  return b.toString();
}
public static float wrap(float x, float wrap) {
  if (x >= 0)
    return x % wrap;
  else
    return x % wrap + wrap;
}

public static float distance(float x, float target, float wrap) {
  x = wrap(x, wrap);
  target = wrap(target, wrap);
  float dist = target - x, invDist;
  return Math.abs(dist) > wrap / 2 ? dist - wrap : dist;
}

void displayDecomp(int[] vals, int width, int height) {
  for(int i = 0; i < 4; i++) {
    stroke(255);
    fill(vals[i]);
    //    print(red(vals[i])+", "+green(vals[i])+", "+blue(vals[i])+"--");
    rect(width/2*(i/2), height/2*(i%2), width/2, height/2);
  }
}

/** The array of lists is of length 4, and each individual list is of length list.length
 *
 */
List[] toDepthLists(List<int[]> list) {
  List[] ret = new List[4];
  for(int i = 0; i < 4; i++) ret[i] = new ArrayList(list.size());
  for(int[] data : list) {
    for(int i = 0; i < 4; i++) {
      ret[i].add(data[i]);
  }
}
return ret;
}
