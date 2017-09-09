import java.util.*;

import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioInput in;

LinkedList<Float> amps;
int len = 7;
public static final float YELL_THRESH = .6,
                          YELL_SUSTAIN = 0;
int curYellSustain = 0;

void setup() {
  size(450, 450);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 512);
  amps = new LinkedList();
}

void draw() {
  background(204);
  smooth();
  
  
    float max = -1, min = 1;
    for(int i = 0; i < in.bufferSize(); i++)
    {
      float val = in.mix.get(i);
      if(max < val) max = val;
      if(min > val) min = val;
    }
    amps.add(max-min);
    float maxAmp = 0;
    for(float f : amps) if(f > maxAmp) maxAmp = f;
//    maxAmp = map(mouseX, 0, width, 0, 1000);
//    maxAmp = 9;
    
  strokeWeight(2);
  stroke(32);
  fill(120);
  int bodyRad = 150;
  ellipse(width/2, height/2, bodyRad*2, bodyRad*2); //body
  
  fill(0);
  strokeWeight(4 + 4 * maxAmp);
  stroke(64, 200);
  float eyesHWidth = 74,
      eyesHeight = 40,
      eyesRad = 10 + 2 * maxAmp;
  ellipse(width/2-eyesHWidth, height/2-eyesHeight, eyesRad*2, eyesRad*2);
  ellipse(width/2+eyesHWidth, height/2-eyesHeight, eyesRad*2, eyesRad*2); //eyes
  
    strokeWeight(2);
    stroke(0);
    int mouthY = 66;
    int mouthHWidth = 60;
    float h = map(maxAmp, 0, 2, 0, 90);
//    float h = 99;
    if(maxAmp > YELL_THRESH) {
      curYellSustain++;
      if(curYellSustain > YELL_SUSTAIN) {
      //angry eyebrows
    float browsOffEyeWidth = 10,
        browsOffEyeHeight = 22,
        browsSlope = 8;
        line(width/2 - eyesHWidth - eyesRad - browsOffEyeWidth, height/2 - eyesHeight - eyesRad - browsOffEyeHeight, //left end, left brow
             width/2 - eyesHWidth + eyesRad + browsOffEyeWidth, height/2 - eyesHeight - eyesRad - browsOffEyeHeight + browsSlope); //right end
             
        line(width/2 + eyesHWidth - eyesRad - browsOffEyeWidth, height/2 - eyesHeight - eyesRad - browsOffEyeHeight + browsSlope, //left end, right brow
             width/2 + eyesHWidth + eyesRad + browsOffEyeWidth, height/2 - eyesHeight - eyesRad - browsOffEyeHeight); //right end
      }
    }
    else curYellSustain = 0;
//    line(width/2 - mouthHWidth, height/2+mouthY, width/2 + mouthHWidth, height/2+mouthY);//mouth line top
//    line(width/2 - mouthHWidth, height/2+mouthY+h, width/2 + mouthHWidth, height/2+mouthY+h);//mouth line bottom
//    ellipse(width/2, height/2 + mouthY, mouthHWidth*2, h);
    bezier(width/2 - mouthHWidth, height/2+mouthY, 
           width/2 - mouthHWidth, height/2+mouthY+h,
           width/2 + mouthHWidth, height/2+mouthY+h,
           width/2 + mouthHWidth, height/2+mouthY); //bottom of mouth
    bezier(width/2 - mouthHWidth, height/2+mouthY, 
           width/2 - mouthHWidth, height/2+mouthY-h/3,
           width/2 + mouthHWidth, height/2+mouthY-h/3,
           width/2 + mouthHWidth, height/2+mouthY); //top of mouth
    textAlign(CENTER, TOP);
    text(h+", "+maxAmp, width/2, 0);
    
    
    
  if(amps.size() > 8) amps.removeFirst();
}


void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  
  super.stop();
}
