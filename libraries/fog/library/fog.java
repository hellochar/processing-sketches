package hardcorepawn.fog;

import processing.core.*;
import processing.opengl.*;
//import net.java.games.jogl.*;
//import net.java.games.jogl.util.*;
//import com.sun.opengl.*;
import javax.media.opengl.*;
import java.nio.*;

public class fog
{
  PApplet parent;
  float near, far;
  PGraphics3D pg3;
  int col;
  GL gl;
//  float[] fogColor;
  public fog(PApplet _parent)
  {
    parent=_parent;
    parent.registerPre(this);
/*    if(parent.g.getClass().getName().indexOf("PGraphics3D")<0)
    {
      throw new RuntimeException("Fog only works with P3D, sorry");
    }*/
  }

  public void setupFog(float worldnear, float worldfar)
  {
    if(parent.g.getClass().getName().indexOf("PGraphics3D")>=0)
    {
      //parent.println("Not GL");
//      pg3=(PGraphics3)parent.g;
//      pg3=new PGraphics3D(parent.g.width,parent.g.height,null);
      pg3=(PGraphics3D)parent.createGraphics(parent.g.width,parent.g.height,parent.P3D);
//      pg3.defaults();
      pg3.beginDraw();
      pg3.camera(0,0,0,0,0,1,0,1,0);
      pg3.beginShape(parent.QUADS);
      {
        pg3.vertex(-100,-100,worldnear);
        pg3.vertex(100,-100,worldnear);
        pg3.vertex(100,100,worldnear);
        pg3.vertex(-100,100,worldnear);
      }
      pg3.endShape();
      pg3.updatePixels();
      near=pg3.zbuffer[pg3.width/2+((pg3.height/2)*pg3.width)];
      pg3.background(0);
      pg3.beginShape(parent.QUADS);
      {
        pg3.vertex(-100,-100,worldfar);
        pg3.vertex(100,-100,worldfar);
        pg3.vertex(100,100,worldfar);
        pg3.vertex(-100,100,worldfar);
      }
      pg3.endShape();
      pg3.updatePixels();
      far=pg3.zbuffer[pg3.width/2+((pg3.height/2)*pg3.width)];
      pg3.camera();
      pg3.background(0);
      pg3.endDraw();
      if(near == Float.MAX_VALUE || far == Float.MAX_VALUE)
      {
        throw new RuntimeException("Near and Far must be positive values, and not clipped");
      }
//      parent.println("Near:"+near+" Far:"+far);
      pg3=(PGraphics3D)parent.g;
    }
    else if(parent.g.getClass().getName().indexOf("PGraphicsOpenGL")>=0)
    {
      //parent.println("Is GL");
      //float[] fogColor= { (float)parent.red(c)/255.0f, (float)parent.green(c)/255.0f, (float)parent.blue(c)/255.0f, 1.0f };
      float[] fogColor= { 0.5f, 0.5f, 0.5f, 1.0f };
      PGraphicsOpenGL a=(PGraphicsOpenGL)parent.g;
      gl=a.gl; 
      gl.glClearColor(0.0f, 0.0f, 0.0f, 0.5f);    // Black Background
      gl.glClearDepth(1.0f);                      // Depth Buffer Setup
      gl.glEnable(GL.GL_DEPTH_TEST);              // Enables Depth Testing
      gl.glDepthFunc(GL.GL_LEQUAL);               // The Type Of Depth Testing To Do
      gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST);	// Really Nice Perspective Calculations
      gl.glEnable(GL.GL_TEXTURE_2D);
      gl.glClearColor( 0.5f, 0.5f, 0.5f, 1.0f);
      gl.glFogi(GL.GL_FOG_MODE, GL.GL_LINEAR);
      gl.glFogf(GL.GL_FOG_DENSITY, 0.35f);
      gl.glHint(GL.GL_FOG_HINT, GL.GL_NICEST);
      //FloatBuffer tmp=
      gl.glFogfv(GL.GL_FOG_COLOR,FloatBuffer.wrap(fogColor,0,fogColor.length));
//      gl.glFogfv(GL.GL_FOG_COLOR, fogColor);
      gl.glFogf(GL.GL_FOG_START, (float)worldnear);
      gl.glFogf(GL.GL_FOG_END, (float)worldfar);
      gl.glEnable(GL.GL_FOG);
    }
//    println("Near:" +worldnear+"="+near);
//    println("Far:" +worldfar+"="+far);
  }
  
  public void pre()
  {
    if(parent.g.getClass().getName().indexOf("PGraphicsOpenGL")>=0)
    {
      ((PGraphicsOpenGL)parent.g).gl.glEnable(GL.GL_FOG);
    }
  }
   
  float getDepth(float zval)
  {
    if(zval < near)
      return 0;
    else if(zval > far)
      return 1;
    else
    {
      return (zval-near)/(far-near);
    }
  }
  
  public void setColor(int c)
  {
    col=c;
    if(parent.g.getClass().getName().indexOf("PGraphicsOpenGL")>=0)
    {
      float[] fogColor= { (float)parent.red(c)/255.0f, (float)parent.green(c)/255.0f, (float)parent.blue(c)/255.0f, 1.0f };
      gl.glFogfv(GL.GL_FOG_COLOR, FloatBuffer.wrap(fogColor,0,fogColor.length));
    }
  }
  
  public void setDist(float zNear, float zFar)
  {
    if(parent.g.getClass().getName().indexOf("PGraphics3")>=0)
    {
      //parent.println("Sorry, Changing fog depth only available in OPENGL mode at the moment");
    }
    else if(parent.g.getClass().getName().indexOf("PGraphicsGL")>=0)
    {
      gl.glFogf(GL.GL_FOG_START, zNear);
      gl.glFogf(GL.GL_FOG_END, zFar);
    }
  }
  
  public void doFog()
  {
    if(parent.g.getClass().getName().indexOf("PGraphics3D")>=0)
    {
      pg3.loadPixels();
      for(int i=0;i<pg3.pixels.length;i++)
      {
        float a=this.getDepth(pg3.zbuffer[i]);
        pg3.pixels[i]=cblend(pg3.pixels[i],col,a);
      }
      pg3.updatePixels();
    }
    else if(parent.g.getClass().getName().indexOf("PGraphicsOpenGL")>=0)
    {
      ((PGraphicsOpenGL)parent.g).gl.glDisable(GL.GL_FOG);
    }
  }

  int cblend(int a, int b, float ratio)
  {
    if(ratio<=0)
      return a;
    if(ratio>=1)
    {
      return b;
    }  
    else
    {
      int ra=(a>>16)&0xff;
      int rb=(b>>16)&0xff;
      int ga=(a>>8)&0xff;
      int gb=(b>>8)&0xff;
      int ba=a&0xff;
      int bb=b&0xff;
      int r=(int)(ra*(1-ratio)+rb*ratio);
      int g=(int)(ga*(1-ratio)+gb*ratio);
      int bl=(int)(ba*(1-ratio)+bb*ratio);
      return((r<<16)+(g<<8)+bl);
    }
  }	
} 
