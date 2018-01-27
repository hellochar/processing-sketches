void setup() {
  
}

void draw() {
  
}

class Transform {//maps the x, y plane into the u, v plane.
  Expression u_fxy,
             v_fxy;
  Environment env;
  int minX = -5, minY = -5, maxX = 5, maxY = 5;
  int res;
  double[][] cache;
  
  Transform(Expression u, Expression v) {
    u_fxy = u;
    v_fxy = v;
    env = new Environment();
    cache = new double[maxX-minX][maxY-minY];
    computeCache();
  }
  
  void computeCache() {
    for(int x = -minX; x <= maxX; x++) {
      for(int y = -minY; y <= maxY; y++) {
        cache[x+minX][y+minY] = 
      }
    }
  }
  
  float u(float x, float y) {
    env.put("x", x); env.put("y", y);
    return u_fxy.eval(env);
  }
  
  float v(float x, float y) {
    env.put("x", x); env.put("y", y);
    return v_fxy.eval(env);
  }
  
  void draw() {
    //do a gridded square
    for(int x = -minX; x <= maxX; x++) {
      for(int y = -minY; y <= maxY; y++) {
        
      }
    }
  }
}

interface Expression {
  
  float eval(Environment env);
  
}

class Environment extends HashMap<String, Double> {
  Environment() {
    super();
  }
}
