import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

Kinect kinect;
ArrayList <SkeletonData> bodies;

void setup()
{
  size(640, 480);
  background(0);
  kinect = new Kinect(this);
  smooth();
  bodies = new ArrayList<SkeletonData>();
  setupOsc();
}

void draw()
{
  background(0);
  image(kinect.GetImage(), 320, 0, 320, 240);
  image(kinect.GetDepth(), 320, 240, 320, 240);
  image(kinect.GetMask(), 0, 240, 320, 240);
  for (int i=0; i<bodies.size (); i++) 
  {
    drawSkeleton(bodies.get(i));
    drawPosition(bodies.get(i));
  }
}

void drawPosition(SkeletonData _s) 
{
  noStroke();
  fill(0, 100, 255);
  String s1 = str(_s.dwTrackingID);
  text(s1, _s.position.x*width/2, _s.position.y*height/2);
}

void drawSkeleton(SkeletonData _s) 
{
  // Body
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HEAD, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
  Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT, 
  Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SPINE, 
  Kinect.NUI_SKELETON_POSITION_HIP_CENTER);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_CENTER, 
  Kinect.NUI_SKELETON_POSITION_HIP_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_CENTER, 
  Kinect.NUI_SKELETON_POSITION_HIP_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_LEFT, 
  Kinect.NUI_SKELETON_POSITION_HIP_RIGHT);

  // Left Arm
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT, 
  Kinect.NUI_SKELETON_POSITION_WRIST_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_WRIST_LEFT, 
  Kinect.NUI_SKELETON_POSITION_HAND_LEFT);

  // Right Arm
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_HAND_RIGHT);

  // Left Leg
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_LEFT, 
  Kinect.NUI_SKELETON_POSITION_KNEE_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_KNEE_LEFT, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT, 
  Kinect.NUI_SKELETON_POSITION_FOOT_LEFT);

  // Right Leg
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT);
}

void DrawBone(SkeletonData _s, int _j1, int _j2) 
{
  noFill();
  stroke(255, 255, 0);
  if (_s.skeletonPositionTrackingState[_j1] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED &&
    _s.skeletonPositionTrackingState[_j2] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED) {
    line(_s.skeletonPositions[_j1].x*width/2, 
    _s.skeletonPositions[_j1].y*height/2, 
    _s.skeletonPositions[_j2].x*width/2, 
    _s.skeletonPositions[_j2].y*height/2);
  }
}

void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
  oscSendBodies(bodies);
}

void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
  oscSendBodies(bodies);
}

void moveEvent(SkeletonData _b, SkeletonData _a) 
{
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
  oscSendBodies(bodies);
}