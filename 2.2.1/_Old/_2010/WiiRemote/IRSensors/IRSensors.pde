import wiiremotej.*;
import wiiremotej.event.*;

WiiRemote remote;
IRLight[] lastLights;
IRSensitivitySettings[] levels = {
  IRSensitivitySettings.WII_LEVEL_1, IRSensitivitySettings.WII_LEVEL_2, IRSensitivitySettings.WII_LEVEL_3,
  IRSensitivitySettings.WII_LEVEL_4, IRSensitivitySettings.WII_LEVEL_5};

int level = 2;

void setup() {
  size(800, 600);
  try{
    remote = WiiRemoteJ.findRemote();
    remote.addWiiRemoteListener(new Listener());
    remote.setIRSensorEnabled(true, WRIREvent.FULL, levels[level]);
    remote.setLEDIlluminated(0, true);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  smooth();
  noFill();
  stroke(255);
  textFont(createFont("Arial", 12));
  noLoop();
}

void draw() {
  background(color(0, 0, 32));
  for (int k = 0; k < lastLights.length; k++) {
    IRLight l = lastLights[k];
    if (l != null)
    {
      float s = map((float)l.getIntensity(), 0, 1, 5, 200);
      float x = map((float)l.getX(), 0, 1, width, 0),
            y = map((float)l.getY(), 0, 1, 0, height);
      ellipse(x, y, s, s);
//      pushStyle();
//      rectMode(CORNERS);
//      noFill();
//      stroke(255, 128, 0);
//      rect((float)l.getXMin()*width, (float)l.getYMin()*height, (float)l.getXMax()*width, (float)l.getYMax()*height);
//      popStyle();
    }
  }
  text(level+1, 90, 90);
}

class Listener extends WiiRemoteAdapter {
  public void IRInputReceived(WRIREvent evt) {
    lastLights = evt.getIRLights();
    redraw();
  }

  public void buttonInputReceived(WRButtonEvent evt) {
    try{
      if(evt.isOnlyPressed(WRButtonEvent.UP)) {
        level = min(level+1, 4);
        remote.setIRSensorEnabled(true, WRIREvent.FULL, levels[level]);
      }
      else if(evt.isOnlyPressed(WRButtonEvent.DOWN)) {
        level = max(level-1, 0);
        remote.setIRSensorEnabled(true, WRIREvent.FULL, levels[level]);
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }

  public void disconnected() {
    exit();
  }
}


