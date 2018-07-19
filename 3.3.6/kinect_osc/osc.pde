
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation = new NetAddress("127.0.0.1", 12000);

void setupOsc() {
  oscP5 = new OscP5(this, 12001);
}

final int[] jointOrder = {
  Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT ,
  Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT ,
  Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT ,
  Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT ,
  Kinect.NUI_SKELETON_POSITION_FOOT_LEFT ,
  Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT ,
  Kinect.NUI_SKELETON_POSITION_HAND_LEFT ,
  Kinect.NUI_SKELETON_POSITION_HAND_RIGHT ,
  Kinect.NUI_SKELETON_POSITION_HEAD ,
  Kinect.NUI_SKELETON_POSITION_HIP_CENTER ,
  Kinect.NUI_SKELETON_POSITION_HIP_LEFT ,
  Kinect.NUI_SKELETON_POSITION_HIP_RIGHT ,
  Kinect.NUI_SKELETON_POSITION_KNEE_LEFT ,
  Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT ,
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER ,
  Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT ,
  Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT ,
  Kinect.NUI_SKELETON_POSITION_WRIST_LEFT ,
  Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT
};

void oscSendBodies(Collection<SkeletonData> bodies) {
  OscMessage msg = new OscMessage("/bodies");
  for (SkeletonData skeleton : bodies) {
    msg.add(skeleton.dwTrackingID);
    msg.add(skeleton.trackingState);
    msg.add(skeleton.position.x);
    msg.add(skeleton.position.y);
    msg.add(skeleton.position.z);
    for (int joint : jointOrder) {
      PVector position = skeleton.skeletonPositions[joint];
      int trackingState = skeleton.skeletonPositionTrackingState[joint];
      msg.add(position.x);
      msg.add(position.y);
      msg.add(position.z);
      msg.add(trackingState);
    }
  }
  println("sending", bodies.size(), "bodies");
  oscP5.send(msg, myRemoteLocation);
}

void oscSendDepth(PImage depth) {
  depth.loadPixels();
  OscMessage msg = new OscMessage("/depth");
  for (int i = 0; i < depth.pixels.length; i++) {
    int b = depth.pixels[i] & 0xFF;
    msg.add(b);
  }
  oscP5.send(msg, myRemoteLocation);
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  println(theOscMessage.arguments());
}