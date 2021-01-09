import KinectPV2.*;
import com.hamoid.*;

VideoExport videoExport;

KinectPV2 kinect;

void setup() {
  size(512, 424, P2D);
  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.init();
  
  videoExport = new VideoExport(this);
  videoExport.startMovie();
  
  frameRate(30);
}

void draw() {
  image(kinect.getBodyTrackImage(), 0, 0);
  videoExport.saveFrame();
}

void exit() {
  videoExport.endMovie();
  super.exit();
}