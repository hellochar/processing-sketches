void setup() {
  size(32, 32);
  PGraphics g = createGraphics(width, height, JAVA2D);
  g.beginDraw();
  g.background(color(255, 0));
  g.smooth();
  g.noFill();
  g.stroke(0xFFFF6600);
  g.strokeWeight(1.5);
  g.line(4, 32-4, 32-4, 4);
  g.line(4, 4, 32-4, 32-4);
  g.beginShape();
  g.endShape(CLOSE);
  g.save("delete.png");
  image(g, 0, 0);
  g.endDraw();
}

//attack
//  g.bezier(0, 0, 0, 8, 8, 16, 32, 16);
//  g.bezier(0, 32, 0, 32-8, 8, 32-16, 32, 32-16);

//stop
//  g.ellipse(16, 16, 30, 30);
//  g.line(16+14*sqrt(2)/2, 16-14*sqrt(2)/2, 16-14*sqrt(2)/2, 16+14*sqrt(2)/2);

  //move
//  g.vertex(0, 10);
//  g.vertex(16, 10);
//  g.vertex(16, 0);
//  g.vertex(32, 16);
//  g.vertex(16, 32);
//  g.vertex(16, 22);
//  g.vertex(0, 22);
