// screen hacks to:
 
// a) create shaped windows
// b) track the windows position
// c) track the absolute mouse position ( even when mouse is outside the window )
// d) calculate modelX and modelY in 2D graphics
 
import com.sun.awt.AWTUtilities;
import java.awt.GraphicsDevice.*;
import java.awt.*;
import java.awt.geom.*;
import javax.swing.*;
 
// mouse position in absolute screen coordinates
int absMouseX, absMouseY, pabsMouseX, pabsMouseY;
 
// window position in absolute screen coordinates
int windowX, windowY, pwindowX, pwindowY;
 
// polygon for inside test
Polygon poly ;
 
 
void init() {
   
    super.init();
     
    if(!online) {
        
      if (!AWTUtilities.isTranslucencySupported(AWTUtilities.Translucency.PERPIXEL_TRANSPARENT)) {
        println("sorry ... no transparency support");
      }
      frame.removeNotify();
      frame.setUndecorated(true);
      frame.setAlwaysOnTop(true);
    }
     
    updateScreenInfo();
  
}
 
 
// call this at the beginning of every drawing loop
 
void updateScreenInfo() {
   
  // update previous coords
  pabsMouseX = absMouseX;
  pabsMouseY = absMouseY;
  pwindowX = windowX;
  pwindowY = windowY;
     
  if(!online) {
     
    // update mouse coords
    PointerInfo i = MouseInfo.getPointerInfo();
    Point p = i.getLocation();
    absMouseX = p.x;
    absMouseY = p.y;
     
    // update windows coords
    p = frame.getLocation();
    windowX = p.x;
    windowY = p.y;
     
  } else {
     
    absMouseX = mouseX;
    absMouseY = mouseY;
     
  }
   
}
 
void moveWindow(int x, int y) {
  if(!online) frame.setLocation(x, y);
}
 
void dragWindow() {
  moveWindow(windowX + absMouseX - pabsMouseX, windowY + absMouseY - pabsMouseY);
}
 
 
// polygon clipped window
// (poligon coords are given in model space)
 
void setWindowShape(float x[], float y[]) {
  
    // transform model space to screen space
    int sx[] = new int[x.length];
    int sy[] = new int[y.length];
    for(int i=0; i<x.length; i++) {
      sx[i] = (int) screenX(x[i], y[i]);
      sy[i] = (int) screenY(x[i], y[i]);
    }
 
    Shape s = new Polygon(sx, sy, sx.length) ;
    if(!online) AWTUtilities.setWindowShape(frame, s);
    poly = new Polygon(sx, sy, sx.length);
 
}
 
// check if the mouse is inside the window
boolean mouseInside() {
  return pointInside(absMouseX - windowX, absMouseY - windowY);
}
 
// check if the point is inside the window
boolean pointInside(float x, float y) {
  return poly.contains(x,y);
}
 
 
// modelX and modelY functions for 2D
 
float modelX(float x, float y) {
  float[] v = {x,y};
  PMatrix m = getMatrix();
  m.invert();
  m.mult(v,v);
  return v[0];
}
 
float modelY(float x, float y) {
  float[] v = {x,y};
  PMatrix m = getMatrix();
  m.invert();
  m.mult(v,v);
  return v[1];
}

