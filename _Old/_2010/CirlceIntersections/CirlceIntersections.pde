/*
 * The MIT License
 * 
 * Copyright (c) 2009 William Ngan (http://metaphorical.net)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import processing.core.*;

public class CircleIntersection extends PApplet {
 
 /*
  * This is a Processing sketch.
  * See http://processing.org to learn more about Processing
  */
 
 
 // Processing Code Start
 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
 Circle circleA, circleB;
 
 // Processing sketch setup
 public void setup() {
  size(360,360);
  background(255);
 
  circleA = new Circle( 180, 180, 60 );
  circleB = new Circle( 180, 180, 70 );
  
  rectMode(CENTER);
  
  noStroke();
  smooth();
 }
 
 // Processing main loop
 public void draw() {
  background(255,255,0);
  
  fill( 150, 150, 150, 150 );
  ellipse( circleA.x, circleA.y, circleA.r*2, circleA.r*2 );

  fill( 25, 150, 150, 150 );
  ellipse( circleB.x, circleB.y, circleB.r*2, circleB.r*2 );

  circleB.x = mouseX;
  circleB.y = mouseY;

  intersect( circleA, circleB );
 }
 
  /**
   * Find intersection points
   * @param cA circle a
   * @param cB circle b
   */
  void intersect( Circle cA, Circle cB ) {

  float dx = cA.x - cB.x;
  float dy = cA.y - cB.y;
  float d2 = dx*dx + dy*dy;
  float d = sqrt( d2 );

  if ( d>cA.r+cB.r || d<abs(cA.r-cB.r) ) return; // no solution
  

  float a = (cA.r2 - cB.r2 + d2) / (2*d);
  float h = sqrt( cA.r2 - a*a );
  float x2 = cA.x + a*(cB.x - cA.x)/d;
  float y2 = cA.y + a*(cB.y - cA.y)/d;

  noStroke();
  fill(255);

  rect( x2, y2, 5, 5 ); // mid point

  float paX = x2 + h*(cB.y - cA.y)/d;
  float paY = y2 - h*(cB.x - cA.x)/d;
  float pbX = x2 - h*(cB.y - cA.y)/d;
  float pbY = y2 + h*(cB.x - cA.x)/d;

  fill(255,0,0);

  ellipse( paX, paY, 10, 10 ); // intersection point 1
  ellipse( pbX, pbY, 10, 10 ); // intersection point 2

  }


  /**
   * Circle class
   */
  class Circle {

  float x, y, r, r2;

  Circle( float px, float py, float pr ) {
   x = px;
   y = py;
   r = pr;
   r2 = r*r;
  }


  }


 
 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 // Processing Code End
 
}

