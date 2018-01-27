import wiiremotej.*;
import wiiremotej.event.*;

WiiRemote remote;

void setup() {
  size(800, 600);
  try{
  remote = WiiRemoteJ.findRemote();
  remote.addWiiRemoteListener(new Listener());
  remote.setAccelerometerEnabled(true);
  remote.setLEDIlluminated(0, true);
  }catch(Exception e) {
    e.printStackTrace();
  }
  smooth();
  noFill();
  stroke(255);
}

void draw() {
}

float lastZ, lastChange;

class Listener extends WiiRemoteAdapter {
  
  public void accelerationInputReceived(WRAccelerationEvent e) {
    float z = e.getZAcceleration();
    float change = z - lastZ;
    boolean sigChange = Math.signum(change) != Math.signum(lastChange);
    
  }
  
  
    public void disconnected() {
      exit();
    }
}
