class cell {
  float[] a, b, c;
  int x, y;
  
  cell(int x, int y, float a_, float b_, float c_) {
    this.x = x;
    this.y = y;
    a = new float[2];
    b = new float[2];
    c = new float[2];
    a[0] = a_;
    b[0] = b_;
    c[0] = c_;
  }
  
  public void calculateNext() {
    float aa = 0, ab = 0, ac = 0;
    for(int x = -1; x < 2; x++) {
      for(int y = -1; y < 2; y++) {
        aa += cellAt(this.x+x, this.y+y).a[p];
        ab += cellAt(this.x+x, this.y+y).b[p];
        ac += cellAt(this.x+x, this.y+y).c[p];
      }
    }
    aa /= 9;
    ab /= 9;
    ac /= 9;
    
//    aa *= .95;
//    ab *= .95;
//    ac *= .95;
    
    float n = 0, m = 1;
    a[q] = constrain(aa + aa*(B*ab-C*ac), n, m);
    b[q] = constrain(ab + ab*(C*ac-A*aa), n, m);
    c[q] = constrain(ac + ac*(A*aa-B*ab), n, m);
  }
  
  int getColor() {
    return color(a[p], b[p], c[p]);
//    return color(1, 0, a[p]);
//    return color(255*a[p], 255*b[p], 255*c[p]);
//    return color(map((a[p]+b[p]+c[p])/3, 0, 1, 0, 255));
  }
}
