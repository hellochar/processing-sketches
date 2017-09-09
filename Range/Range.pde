
class Range<T extends Number> implements Iterable {
  T low, high, interval;
  Class<T> c;
  
  public Range(T low, T high, T interval, Class<T> c) {
    this.low = low;
    this.high = high;
    this.interval = interval;
    this.c = c;
  }
  
  Iterator<T> iterator() {
    return new Iterator<T>() {
      double num = low.doubleValue();
      
      public boolean hasNext() {
        return num < high.doubleValue();
      }
      
      public T next() {
        println("low, high, int: "+low+", "+high+", "+interval+" -- "+c);
        num += interval.doubleValue();
        if(c == Integer.TYPE) {//ugh
          return c.cast(new Integer((int)num));
        }
        else if(c == Long.TYPE) {
          return c.cast(new Long((long)num));
        }
        else if(c == Double.TYPE) {
          return c.cast(new Double(num));
//          return c.cast(new Double(d.intValue()));
        }
        else if(c == Float.TYPE) {
          return c.cast(new Float((float)num));
        }
        else {
          throw new ClassCastException("Cannot do ranges for class "+c+"!");
        }
//        return c.cast(d); //gotta do some testing for this
      }
      
      public void remove() { throw new UnsupportedOperationException(); }
    };
  }
}

void setup() {
  Range<Integer> r = new Range<Integer>(-10, 10, 1, Integer.TYPE);
  Iterator<Integer> i = r.iterator();
  while(i.hasNext()) {
    println(i.next());
  }
//  for(int i : r) {
//    println(i);
//  }
}
