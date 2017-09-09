class MyGrayScott extends GrayScott {
  float[] fCache, kCache;
  public MyGrayScott(int w, int h, boolean t) {
    super(w, h, t);
    fCache = new float[w];
    kCache = new float[h];
    initCache();
  }
  
  void initCache() {
    for(int x = 0; x < width; x++) {
//      fCache[x] = f + map(x, 0, width, -.03, .03);
      fCache[x] = map(x, 0, width, .001, .043); //rangeX = .043 - .001 = .042; width = 400, slope = .042/400 = 105 * 10^-6 f/pix
    }
    for(int y = 0; y < height; y++) {
//      kCache[y] = k + map(y, 0, height, -.03, .03);
      kCache[y] = map(y, 0, height, .032, .102); //rangeY = .102 - .032 = .06; height = 400, slope = .06/400 = 150 * 10^-6 k/pix
    }
    //y/x slope = 150/105 = 1.428 k per f. 
  }
  
  int zoom = 5; //zoom in to the line x = y
  float getFCoeffAt(int x, int y) {
    return fCache[x];
  }
  
  float getKCoeffAt(int x, int y) {
    return kCache[y];
  }
  
  public void reset(int i) {
    v[i] = vv[i] = random(1);
  }
  
  public void setRect(int x, int y, int w, int h, float u, float v) {
        int mix = MathUtils.clip(x - w / 2, 0, width);
        int max = MathUtils.clip(x + w / 2, 0, width);
        int miy = MathUtils.clip(y - h / 2, 0, height);
        int may = MathUtils.clip(y + h / 2, 0, height);
        for (int yy = miy; yy < may; yy++) {
            for (int xx = mix; xx < max; xx++) {
                int idx = yy * width + xx;
                uu[idx] = u;
                vv[idx] = v;
            }
        }
    }
}
