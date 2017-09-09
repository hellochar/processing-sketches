
import remixlab.proscene.*;
import controlP5.*;

// global vars.
Scene scene, GUIscene;
float rot;
ControlP5 controlP5;

PGraphics buffer;

void setup()
{
  size(600, 600, JAVA2D);
  
  // initialize the scene.
  buffer = createGraphics(600, 600, P3D);
  scene = new Scene(this, (PGraphics3D)buffer);
  // scene.setGridIsDrawn(false);
  // scene.setRadius(200);
  
  rot = 0.0;
  
  controlP5 = new ControlP5(this);
  controlP5.setAutoDraw(false);
  ListBox l = controlP5.addListBox("GUI", 5, 30, 100, height-20);
  l.setLabel("Test controlP5");
}

void draw()
{
  background(0);
  
  // 3D drawing.
  drawCube();
  
  refresh();
  
  // 2D drawing.
  drawGUI();
}

void drawCube()
{
  buffer.beginDraw();
  scene.beginDraw();
  buffer.background(0);
  buffer.pushMatrix();
  buffer.pushStyle();
  buffer.colorMode(HSB);
  buffer.fill(#66FFFF);
  buffer.stroke(#FF3070);
  buffer.rotateY(rot+=.005);
  buffer.box(50);
  buffer.popStyle();
  buffer.popMatrix();
  scene.endDraw();
  buffer.endDraw();
}

void drawGUI()
{
  scene.beginScreenDrawing();
  controlP5.draw();
  scene.endScreenDrawing();
}

void refresh()
{
  image(buffer, 0, 0);
}

