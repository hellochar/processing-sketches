import java.util.*;

interface Task {
  void doIt();
}

class Circle {
  float x, y, cR;
  public Circle(float xx, float yy, float rr) {
    x = xx;
    y = yy;
    cR = rr;
  }
  
  void drawAo() {
    // ambient occlusion - slight dark gradient around the circle
    for (float r = cR * 1.5; r >= 0; r -= 4 / sqrt(2)) {
      final float lerp = constrain(map(r, cR, cR * 1.5, 1, 0), 0, 1);
      final color c0 = #10161A; // $black
      final float rr = r;
      tasks.add(new Task() {
        public void doIt() {
          noStroke();
          fill(c0, pow(lerp, 10) / 12 * 255);
          ellipse(x, y, rr, rr);
        }
      });
    }
  }
  
  void drawShadow() {
    // directional shadow of circle
    final float diagRad = cR / 2 / sqrt(2);
    for (float t = 0; t < cR; t += 1 / sqrt(2)) {
      final color c0 = #10161A; // $black
      final float tt = t;
      tasks.add(new Task() {
        public void doIt() {
          stroke(c0, (1 - tt / cR) * 255);
          noFill();
          //arc(x + tt, y + tt, cR, cR, -PI / 4, PI * 3 / 4);
          line(x + tt + diagRad, y + tt - diagRad, 
            x + tt - diagRad, y + tt + diagRad);
        }
      }
      );
    }
  }
  
  void drawCircle() {
    //float rMax = ceil(sqrt(width * width + height * height));
    //final float rLerp = 1 - dist(width/2, height/2, x, y) / rMax;
    ////final color c0 = #202B33; // $dark-gray2
    ////final color c1 = #5C7080; // $gray1
    //final color c0 = #5C7080; // $gray1
    //final color c1 = #ffffff; // $white

    //tasks.add(new Task() {
    //  public void doIt() {
    //    noStroke();
    //    fill(lerpColor(c0, c1, rLerp));
    //    //fill(#ffffff);
    //    ellipse(x, y, cR, cR);
    //  }
    //});
    
    final float focusX = x - cR * 0.2, focusY = y - cR * 0.2;
    for (float r = cR; r >= 0; r -= 1) {
      final color cOuter = #5C7080; // $gray1
      final color cInner = #ffffff; // $white
      final float rr = r;
      tasks.add(new Task() {
        public void doIt() {
          fill(lerpColor(cOuter, cInner, sqrt(sqrt(1 - rr / cR))));
          noStroke();
          ellipse(map(rr, cR, 0, x, focusX), map(rr, cR, 0, y, focusY), rr, rr);
        }
      }
      );
    }
  }

  void draw() {
    drawAo();
    drawShadow();
    drawCircle();
  }
}

List<Task> tasks = new ArrayList();
void setup() {
  size(1920, 1080, P2D);
  smooth(8);

  // radial gradient background
  float rMax = ceil(sqrt(width * width + height * height));
  for (float r = rMax; r >= 0; r--) {
    final float rLerp = 1 - r / rMax;
    //final color c0 = #202B33; // $dark-gray2
    //final color c1 = #5C7080; // $gray1
    final color c0 = #5C7080; // $gray1
    final color c1 = #ffffff; // $white

    final float rr = r;
    tasks.add(new Task() {
      public void doIt() {
        fill(lerpColor(c0, c1, rLerp));
        noStroke();
        ellipse(width/2, height/2, rr, rr);
      }
    });
  }
  //background(#202B33);

  final List<Circle> circles = new ArrayList();
  circles.add(new Circle(width/2, height/2, width/4));
  for (int i = 0; i < 100; i++) {
    float x, y, minDist;
    // find a random point not within any of the other circles
    do {
      x = random(width);
      y = random(height);
      minDist = min(min(x, width - x), y, height - y);
      for(Circle c : circles) {
        minDist = min(minDist, dist(c.x, c.y, x, y) - c.cR / 2);
      }
    } while (minDist < 0);
    circles.add(new Circle(x, y, minDist));
  }
  
  //// diffuse background reflectivity
  //tasks.add(new Task() {
  //  public void doIt() {
  //    for (float x = 0; x < width; x++) {
  //      for (float y = 0; y < height; y++) { 
  //        float reflectAmount = 0;
  //        for (Circle c : circles) {
  //          if (dist(c.x, c.y, x, y) < c.cR / 2) continue;
  //          float dist = max(0, dist(c.x, c.y, x, y) - c.cR / 2);
  //          float scalar = 0.05;//random(0.15, 0.25);
  //          reflectAmount += 1 / (1 + dist / 50) * scalar;
  //        }
  //        color cOuter = #5C7080; // $gray1
  //        color cInner = #ffffff; // $white
  //        stroke(lerpColor(cOuter, cInner, reflectAmount), reflectAmount * 255);
  //        point(x, y);
  //      }
  //    }
  //  }
  //});
  
  for (Circle c : circles) {
    c.drawAo();
  }
  for (Circle c : circles) {
    c.drawShadow();
  }
  for (Circle c : circles) {
    c.drawCircle();
  }
  

  for (Task t  : tasks) {
    t.doIt();
  }
  //saveFrame("frames/03.png");
}

void draw() {
  //for (int i = 0; i < 50; i++) {
  //  if (tasks.size() > 0) {
  //    Task t = tasks.get(0);
  //    t.doIt();
  //    tasks.remove(t);
  //  }
  //}

  //int index = (int)map(mouseX, 0, width, 0, tasks.size());
  //tasks.get(index).doIt();

  //if (tasks.size() > 0) {
  //  Task t = tasks.get(0);
  //  t.doIt();
  //  tasks.remove(t);
  //}

  //for (Task t  : tasks) {
  //  t.doIt();
  //}

  //println(frameRate);
}