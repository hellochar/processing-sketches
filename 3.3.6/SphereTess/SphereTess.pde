// Tessellation shaders
// Adapted from Philip Rideout's code in:
// http://prideout.net/blog/?p=48
// 
// More about tessellation shaders:
// http://prideout.net/blog/?p=49
//
// Use left/right cursor keys to control outer tessellation level
// Use up/down cursor keys to control inner tessellation level

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL3;
import com.jogamp.opengl.GL4;

PShape ico;
PShader tessellator;
float angle;
float tessLevelInner = 3;
float tessLevelOuter = 2;  
boolean useTess = true;

void settings() {
  size(400, 400, P3D);
  PJOGL.profile = 4;
}

void setup() {
  ico = createIcosahedron();

  tessellator = new TessellationShader(this, "GeodesicVert.glsl", 
                                             "GeodesicTessControl.glsl", 
                                             "GeodesicTessEval.glsl", 
                                             "GeodesicGeom.glsl", 
                                             "GeodesicFrag.glsl");
  tessellator.set("TessLevelInner", tessLevelInner);    
  tessellator.set("TessLevelOuter", tessLevelOuter);    
  shader(tessellator);
}

void draw() {
  background(157);  

  pointLight(0, 204, 204, 0, 0, 200);

  translate(width/2, height/2, 0);

  scale(120);
  angle += 0.01;
  rotateY(angle);  
  shape(ico);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      tessLevelInner++;
      tessellator.set("TessLevelInner", tessLevelInner);
    } else if (keyCode == DOWN && 1 < tessLevelInner) {
      tessLevelInner--;
      tessellator.set("TessLevelInner", tessLevelInner);
    } else if (keyCode == RIGHT) {
      tessLevelOuter++;
      tessellator.set("TessLevelOuter", tessLevelOuter);
    } else if (keyCode == LEFT && 1 < tessLevelOuter) {
      tessLevelOuter--;
      tessellator.set("TessLevelOuter", tessLevelOuter);
    }
  } else {
    useTess = !useTess;
    if (useTess) shader(tessellator);
    else resetShader();
  }
}