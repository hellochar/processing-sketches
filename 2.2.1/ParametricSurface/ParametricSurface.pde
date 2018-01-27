import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

Surface s;
PeasyCam cam;

void setup() {
  size(500, 500, P3D);
  cam = new PeasyCam(this, 200);
//  s = new Surface(new SurfaceExpr() {
//      PVector eval(int u, int v) {
//        return new PVector(u, v, u*u+v*v);
//      }
//  });
  s = new Surface(new SurfaceExpr() {
    public PVector eval(int u, int v) {
      return new PVector(u, u*cos(v), u*sin(v));
    }
  });
}

void draw() {
  background(20);
  stroke(255);
  fill(216);
  lights();
  s.draw();
}

class Range<T extends Number> implements Iterable {
  T low, high, interval;
  
  public Range(T low, T high, T interval) {
    this.low = low;
    this.high = high;
    this.interval = interval;
  }
  
  Iterator<T> iterator() {
    return new Iterator() {
      double num = low.doubleValue();
      public boolean hasNext() {
        return num < high.doubleValue();
      }
      
      public T next() {
        return num += interval.doubleValue(); //gotta do some testing for this
      }
      
      public void remove() { throw new UnsupportedOperationException(); }
    };
  } 
}

abstract class SurfaceExpr implements Expression<PVector> {
  abstract PVector eval(int u, int v);
  
  PVector eval(Environment env) {
    return eval(env.get("u", Integer.TYPE), env.get("v", Integer.TYPE));
  }
}

class Surface {//maps the x, y plane into the u, v plane.
  Expression<PVector> r_fuv;
  Environment env;
  int minU = -5, minV = -5, maxU = 5, maxV = 5;
  PVector[][] cache;
  
  Surface(Expression<PVector> func) {
    r_fuv = func;
    env = new Environment();
    cache = new PVector[maxU-minU+1][maxV-minV+1];
//    computeCache();
  }
//  
//  void computeCache() {
//    for(int u = -minU; u <= maxU; u++) {
//      for(int v = -minV; v <= maxV; v++) {
//        cache[u+minU][v+minV] = r_fuv.eval(u, y);
//      }
//    }
//  }
  
  //automatically caches values.
  PVector r(int u, int v) {
    PVector cacheValue = cache[u-minU][v-minV];
    if(cacheValue == null) { //compute value and cache it.
      env.put("u", u); env.put("v", v);
      cache[u-minU][v-minV] = cacheValue = r_fuv.eval(env);
    }
    return cacheValue;
  }
  
  void draw() {
    //do a square
    for(int u = minU; u < maxU; u++) {
      for(int v = minV; v < maxV; v++) {
        beginShape();
        vertex(r(u, v));
        vertex(r(u+1, v));
        vertex(r(u+1, v+1));
        vertex(r(u, v+1));
        endShape(CLOSE);
      }
    }
  }
}

void vertex(PVector p) {
  vertex(p.x, p.y, p.z);
}

interface Expression<T> {
  
  T eval(Environment env);
  
}

class Environment extends HashMap<String, Object> {
//  HashMap<String, Class> types;
  Environment() {
    super();
//    types = new HashMap();
  }
  
  public <T> T get(String name, Class<T> type) {
    return (T) super.get(name);
  }
}
