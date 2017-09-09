/**
 * User Defined Effect 
 * by Damien Di Fede.
 *  
 * This sketch demonstrates how to write your own AudioEffect. 
 * See NoiseEffect.pde for the implementation.
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer groove;
LowFiEffect ce;

void setup()
{
  size(512, 200, P2D);

  minim = new Minim(this);
  groove = minim.loadFile("groove.mp3", (int)pow(2, 10));
  groove.loop();
  ce = new LowFiEffect();
  groove.addEffect(ce);

  textFont(createFont("", 12));
  textAlign(LEFT, TOP);
}

void draw()
{
  ce.newRate = (int)pow(2, (map(mouseX, 0, width, 0, 16)));
//  ce.wet = map(mouseY, 0, height, 0, 1);
  background(0);
  stroke(255);
  // we multiply the values returned by get by 50 so we can see the waveform
  for ( int i = 0; i < groove.bufferSize() - 1; i++ )
  {
    float x1 = map(i, 0, groove.bufferSize(), 0, width);
    float x2 = map(i+1, 0, groove.bufferSize(), 0, width);
    //    println(i+": "+x1+", "+x2);
    line(x1, height/4 - groove.left.get(i)*50, x2, height/4 - groove.left.get(i+1)*50);
    line(x1, 3*height/4 - groove.right.get(i)*50, x2, 3*height/4 - groove.right.get(i+1)*50);
  }
  text(ce.wet+", "+ce.newRate, 0, 0);
  fill(255);
}

void stop()
{
  // always close Minim audio classes when you finish with them
  groove.close();
  // always stop Minim before exiting
  minim.stop();

  super.stop();
}

