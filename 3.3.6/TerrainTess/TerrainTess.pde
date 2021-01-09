// Terrain tessellation with dynamic LOD and height map:
// codeflow.org/entries/2010/nov/07/opengl-4-tessellation/
// 
// Press 'z' to enable/disable surface
// Press 'x' to enable/disable grid
// Press '1' to move camera along path

import remixlab.proscene.*;
import remixlab.dandelion.geom.*;
  
import com.jogamp.opengl.GL; //<>//
import com.jogamp.opengl.GL3;
import com.jogamp.opengl.GL4;

PImage heightMap;
GL4Shader terrainShader;
GL4Shader edgesShader;
PShape grid;
Scene scene;

void settings() {
  fullScreen(P3D);
  //size(640, 360, P3D);
  PJOGL.profile = 4;
}

void setup() { 
//  size(displayWidth, displayHeight, P3D);
  heightMap = loadImage("goodmountains.jpg");

  scene = new Scene(this);
  setupCameraPath();

  setupShaders();
  
  setupGrid();
}

boolean showSurf = true;
boolean showEdges = false;
void draw() {
  background(0);

  pointLight(255, 255, 255, 0, 0, 500);  
  
  if (showSurf) {
    shader(terrainShader);
    shape(grid); 
  }
  
  if (showEdges) {
    shader(edgesShader);
    shape(grid);
  }
}  

void keyPressed() {
  if (key == 'z') showSurf = !showSurf;
  if (key == 'x') showEdges = !showEdges;
}

void setupCameraPath() {
  scene.camera().setUpVector(new Vec(0, 0, -1), false);  
  scene.camera().setPosition(new Vec(0, 120, 50));
  scene.camera().lookAt(scene.camera().sceneCenter());
  scene.camera().addKeyFrameToPath(1);

  scene.camera().setUpVector(new Vec(0, 0, -1), false);
  scene.camera().setPosition(new Vec(0, 60, 10));
  scene.camera().lookAt(scene.camera().sceneCenter());
  scene.camera().addKeyFrameToPath(1);

  scene.camera().setUpVector(new Vec(0, 0, -1), false);
  scene.camera().setPosition(new Vec(0, -60, 10));
  scene.camera().lookAt(scene.camera().sceneCenter());
  scene.camera().addKeyFrameToPath(1);

  scene.camera().setUpVector(new Vec(0, 0, -1), false);
  scene.camera().setPosition(new Vec(0, -120, 50));
  scene.camera().lookAt(scene.camera().sceneCenter());
  scene.camera().addKeyFrameToPath(1);
}  

void setupShaders() {
  terrainShader = new GL4Shader(this, "vert.glsl", "tesscontrol.glsl", "tesseval.glsl", "frag.glsl");
  terrainShader.set("heightMap", heightMap);
  terrainShader.set("resolution", (float)(width), (float)(height));
  terrainShader.set("lodFactor", 4.0f);
  terrainShader.set("bumpScale", 0.05f);
  terrainShader.set("cullGeometry", true);

  edgesShader = new GL4Shader(this, "vert.glsl", "tesscontrol.glsl", "tesseval.glsl", "geomEdges.glsl", "fragEdges.glsl");
  edgesShader.set("heightMap", heightMap);
  edgesShader.set("resolution", (float)(width), (float)(height));
  edgesShader.set("lodFactor", 4.0f);
  edgesShader.set("cullGeometry", true);
}  

void setupGrid() {
  grid = createShape();
  grid.beginShape(QUADS);
  grid.noStroke();
  for (int i = 0; i < 180; i++) {
    for (int j = 0; j < 240; j++) {
      float x0 = map(i, 0, 180, -90, 90); 
      float x1 = x0 + 1;
      float y0 = map(j, 0, 240, -120, 120); 
      float y1 = y0 + 1;    
      float u0 = map(x0, -90, 90, 0, 1);
      float u1 = map(x1, -90, 90, 0, 1);      
      float v0 = map(y0, -120, 120, 0, 1);
      float v1 = map(y1, -120, 120, 0, 1);
      grid.normal(0, 0, 1); 
      grid.vertex(x0, y0, u0, v0);
      grid.vertex(x1, y0, u1, v0);
      grid.vertex(x1, y1, u1, v1);
      grid.vertex(x0, y1, u0, v1);
    }  
  } 
  grid.endShape();  
}  