interface NumberGenerator {  
  float getFloat();
  int getInt();
}

class RandomNumber implements NumberGenerator {
  float low, high;
  
  RandomNumber(float l, float h) {
    low = l;
    high = h;
  }
  
  float getFloat() {
    return random(low, high);
  }
  
  int getInt() {
    return (int)getFloat();
  }
}
