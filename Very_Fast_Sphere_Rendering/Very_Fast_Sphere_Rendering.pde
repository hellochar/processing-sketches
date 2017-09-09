import processing.opengl.PGraphicsOpenGL;
import javax.media.opengl.GL;
import javax.media.opengl.glu.GLU;
import javax.media.opengl.glu.GLUquadric;
import com.sun.opengl.util.texture.Texture;
import com.sun.opengl.util.texture.TextureIO;
import peasy.PeasyCam;  //peasy camera control
PGraphicsOpenGL pgl;
GL gl;
GLU glu;
GLUquadric mysphere;
Texture earth;
PeasyCam cam;
float r = 2048/PI;  //Sized to fit the texture (2048 x 1024)
float rotateearth = 0;
void setup() {
  size(screenWidth, screenHeight, OPENGL );
  pgl = (PGraphicsOpenGL) g;  
  gl = pgl.gl;  
  glu = pgl.glu;
  mysphere = glu.gluNewQuadric();
  glu.gluQuadricDrawStyle(mysphere, glu.GLU_FILL);
  glu.gluQuadricNormals(mysphere, glu.GLU_NONE);
  glu.gluQuadricTexture(mysphere, true);
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*32.0);
  cam = new PeasyCam(this, width);
  cam.setResetOnDoubleClick(false);
  cam.setMinimumDistance(width/14);
  cam.setMaximumDistance(width*10);
  cam.rotateZ(radians(-90));
  cam.rotateX(radians(105));

  try {    
    earth = TextureIO.newTexture(new File(dataPath("earthtruecolor_nasa_big.jpg")), true);
      /*  http://apod.nasa.gov/apod/image/0203/earthtruecolor_nasa_big.jpg */
  }  
  catch (IOException e) {
    javax.swing.JOptionPane.showMessageDialog(this, e);
  }
  frameRate(3000);
}
void draw() {
  background(0);
  pgl.beginGL();
  gl.glPushMatrix();
  gl.glRotatef(degrees(rotateearth),0.0,0.0,1.0);
  gl.glColor3f(1,1,1);
  earth.enable();
  earth.bind();
  glu.gluSphere(mysphere, r, 40, 40);
  earth.disable();
  gl.glPopMatrix();
  pgl.endGL();
  if (rotateearth < 360) {
    rotateearth = rotateearth + .0005;
  } 
  else {
    rotateearth = 0;
  }
  println(frameRate);
}

