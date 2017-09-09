import processing.core.*;
import java.util.*;
import java.lang.reflect.*;

//combiners

//Joint makeRandomJoint() {
//  Class<? extends Joint> c = jointClasses.get((int)(Math.random() * jointClasses.size()));
//  Constructor[] consArr = c.getDeclaredConstructors();
//  Constructor cons = consArr[0];
//  for(Constructor t : consArr) {
//    if(t.getParameterTypes().length > cons.getParameterTypes().length) {
//      cons = t;
//    }
//  }//find constructor with the most arguments.
//  
//}

abstract class Joint {
  Joint[] children;
  int numChildren;

  static boolean firstCall = true;
  static List<Class<? extends Joint>> jointClasses = new ArrayList();
  static Joint makeRandomJoint() {
    if(firstCall) { System.out.println("FC"); firstCall = false; }
    if(Math.random() < .8)
      return new BallEndPoint(2+(float)(Math.random()*13));
    else 
      return new HalfSphere(50, 5).populate();
  }
  
  {
    Class myClass = this.getClass();
    if(!jointClasses.contains(myClass) && 
    !Modifier.isAbstract(myClass.getModifiers())) {
      jointClasses.add(myClass);
      System.out.println("Added class "+myClass+" to jointClasses!");
    }
  }
  
  Joint(int numChildren) {
    this.numChildren = numChildren;
  }
  
  abstract void draw(PApplet p);
  
  Joint populate() {
    if(children == null) {
      children = new Joint[numChildren];
    } else {
      throw new RuntimeException("Trying to populate a HalfSphere that's already full!");
    }
    for(int i = 0; i < children.length; i++) {
      children[i] = makeRandomJoint();
    }
    return this;
  }
}

class HalfSphere extends Joint {
  float rad;
  
  HalfSphere(float rad, int num) {
    super(num);
    this.rad = rad;
  }
  
  void draw(PApplet p) {
    p.noFill(); p.stroke(255); p.strokeWeight(3);
    p.pushMatrix();
    p.rotateX(PApplet.PI/2);
    for(int i = 0; i < 5; i++) {
      float x = 0, y = rad * i / 5, tempRad = (float)Math.sqrt(rad*rad - y*y);
      p.ellipse(x, y, tempRad, tempRad);
    }
    p.popMatrix();
    for(int i = 0; i < numChildren; i++) {
      p.pushMatrix();
      p.rotateY(p.map(i, 0, numChildren, 0, PApplet.TWO_PI));
      p.arc(0, rad, rad*2, rad*2, -PApplet.PI/2, 0);
      p.translate(rad, 0);
      p.pushStyle();
      children[i].draw(p);
      p.popStyle();
      p.popMatrix();
    }
  }
}

class MultiJoint extends Joint {
  
  MultiJoint(int num) {
    super(num);
  }
  
  void draw(PApplet p) {
    for(Joint j : children) {
      j.draw(p);
    }
  }
  
}

abstract class EndPoint extends Joint {
  EndPoint() {
    super(0);
  }
}

class BallEndPoint extends EndPoint {
  float rad;
  
  BallEndPoint(float rad) {
    this.rad = rad;
  }
  
  void draw(PApplet p) {
    p.noStroke(); p.fill(255, 0, 0);
    p.sphere(rad);
  }
}
