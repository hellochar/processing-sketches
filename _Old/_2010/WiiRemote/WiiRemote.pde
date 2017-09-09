import wiiremotej.*;
import wiiremotej.event.*;

WiiRemote wii;

void setup() {
  size(800, 600);
  wii = WiiRemoteJ.findRemote();
  wii.add(new Listener());
  wii.enableContinuous();
}

void close() {
  wii.disconnect();
}


