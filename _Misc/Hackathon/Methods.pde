int[] decompose(PImage m) {
  // *-----------*------------*
  // |           |            |
  // |     0     |     1      |
  // |           |            |
  // |---------- |------------|
  // |           |            |
  // |     2     |     3      |
  // |           |            |
  // *-----------*------------*
  m.loadPixels();
  int[] ret = new int[4];
  for(int i = 0; i < 2; i++) {
    for(int j = 0; j < 2; j++) {
      int eleNum = (m.width/2)*(m.height/2);
      long aR = 0, aG = 0, aB = 0;
      for(int y = j*m.height/2; y < (j+1)*m.height/2; y++) {
        for(int x = i*m.width/2; x < (i+1)*m.width/2; x++) {
          //          pixels[y*width+x] = color(255);
          int c = m.pixels[m.width*y + x];
          aR += c >> 16 & 0xFF;
          aG += c >> 8 & 0xFF;
          aB += c >> 0 & 0xFF;
        }
//        if(aR < 0 | aG < 0 | aB < 0) throw new RuntimeException("RGB overflow: "+aR+", "+aG+", "+aB+" at "+y+"!"); //didn't happen in 1920x1680, i think we're good
      }
//      print("("+i+", "+j+"): "+aR+", "+aG+", "+aB+" -> ");
      aR /= eleNum;
      aG /= eleNum;
      aB /= eleNum;
//      println(i+", "+j+": "+aR+", "+aG+", "+aB+"("+eleNum+", "+m.width+", "+m.height+")");
      ret[i*2+j] = 255 << 24 |
        ((int)aR & 0xFF) << 16 |
        ((int)aG & 0xFF) << 8 |
        ((int)aB & 0xFF) << 0;
    }
  }
  return ret;
}

/**
 * The list is of length imgList, and each array is of length 4.
 */
List<int[]> aggregate(PImage... imgList) {
  List<int[]> values = new ArrayList(imgList.length);
  for(PImage i : imgList)
    values.add(decompose(i));
  
  return values;
}

List<int[]> aggregate(List<PImage> imgList) {
  return aggregate(imgList.toArray(new PImage[] {} ));
}
