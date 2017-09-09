import point2line.*;

float px = .5,
py = .25;

Vect2[][] edges = new Vect2[4][2];

Vect2 topLeft = new Vect2(0, 1),
bottomLeft = new Vect2(0, 0),
topRight = new Vect2(1, 1),
bottomRight = new Vect2(1, 0);


void setup() {
  size(500, 500);
  edges[0][0] = bottomLeft;
  edges[0][1] = topLeft;

  edges[1][0] = topRight;
  edges[1][1] = topLeft;

  edges[2][0] = bottomRight;
  edges[2][1] = topRight;

  edges[3][0] = bottomLeft;
  edges[3][1] = bottomRight;

  noLoop();
  
  background(240, 140, 20);
  stroke(255);
  smooth();
  float scale = width;
  translate(width/2 - scale/2, height/2 - scale/2);
  scale(scale);
  strokeWeight(1/scale);
  
    for(int i = 0; i < 4; i++) {
      Vect2[] edge = edges[i];
      line(edge[0].x, edge[0].y, edge[1].x, edge[1].y);
    }
    
}

void mousePressed() {redraw();}

int count = 0;
float times = 200000;

void draw() {
  float scale = width;
  translate(width/2 - scale/2, height/2 - scale/2);
  scale(scale);
  strokeWeight(1/scale);
//  count = 0;
//  background(240, 140, 20);
//  stroke(255);
//  smooth();
//  float scale = width;
//  translate(width/2 - scale/2, height/2 - scale/2);
//  scale(scale);
//  strokeWeight(1/scale);
//  
//    for(int i = 0; i < 4; i++) {
//      Vect2[] edge = edges[i];
//      line(edge[0].x, edge[0].y, edge[1].x, edge[1].y);
//    }
//    
//  fill(color(100, 200, 0));
//  ellipse(px, py, .1, .1);
  for(int k = 0; k < times; k++) {
  float x = random(1);
  float y = random(1);
   px = random(1); py = random(1);
  //Since Space2.lineIntersection only checks the line segments, find two points along the same line that are farther out.
  //equation for line - (y-y0) = (slope) * (x-x0). 
  //x0 and y0 will be px and py. 
  //y = slope*(x-x0) + y0
  float slope = (.25 - y) / (.5 - x);
  //choosing a point x to be -2
  Vect2 v1 = new Vect2(-2, slope * (-2 - px) + py);
  //choosing a second point x to be positive 2)
  Vect2 v2 = new Vect2(2, slope * (2 - px) + py);

//  line(v1.x, v1.y, v2.x, v2.y);
//  fill(color(255, 0, 0));
//  ellipse(x, y, .1, .1);
//  

    for(int i = 0; i < 4; i++) {
      Vect2[] edge = edges[i];
//      line(edge[0].x, edge[0].y, edge[1].x, edge[1].y);
      if(Space2.lineIntersection( v1, v2, edge[0], edge[1]) != null) {
        intersects[i] = true;
      }
      else {intersects[i] = false; }
    }
   for(int i = 0; i < 4; i++) {
//     if(intersects[i]) fill(255);
//     else noFill();
//     stroke(0);
//     rect(-1*i*.11, -1, .1, .1);
     if(intersects[i] && intersects[(i+1)%4]) {
       stroke(0, 10);
//       fill(0, 10);
       point(x, y);
       point(px, py);
       count++;
       break;
//       fill(0);
//       rect(-.1, -.1, .1, .1);
     }
   }
}
   println(count / (times * frameCount));
}


