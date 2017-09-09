import java.util.BitSet;

class TextGrid {
  BitSet[] bits; //storing with each index as the y, the BitSet inside as the x
  int width;
  TextGrid(BitSet[] bits, int width) {
    this.bits = bits;
    this.width = width;
  }
  
  TextGrid(int width, String bitString) {
    this.width = width;
    bits = new BitSet[bitString.length() / width];
    int a = 0;
    for(int k = 0; k < bits.length; k++) {
      bits[k] = new BitSet(width);
      for(int y = 0; y < width; y++) {
        if(bitString.charAt(a) =='1') {
          bits[k].set(y);
        }
        a++;
      }
    }
  }
  
  boolean get(int x, int y) {
    return bits[y].get(x);
  }
  
  int width() {
    return width;
  }
  
  int height() {
    return bits.length;
  }
}

final TextGrid Y = new TextGrid(4, "1000"+
                                   "0101"+
                                   "0010"+
                                   "0010"),
               O = new TextGrid(3, "010"+
                                   "101"+
                                   "101"+
                                   "010"),
               U = new TextGrid(3, "101"+
                                   "101"+
                                   "101"+
                                   "010");
