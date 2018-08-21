import KinectPV2.*;
import com.hamoid.*;
import java.util.*;

VideoExport videoExport;
PGraphics pg;

KinectPV2 kinect;

void setup() {
  size(1920, 1080, P2D);
  kinect = new KinectPV2(this);
  kinect.enableBodyTrackImg(true);
  kinect.enableDepthImg(true);
  kinect.enableDepthMaskImg(true);
  kinect.enableColorImg(true);
  kinect.enablePointCloud(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableCoordinateMapperRGBDepth(true);
  kinect.enableSkeleton3DMap(true);
  kinect.init();
  pg = createGraphics(KinectPV2.WIDTHDepth, KinectPV2.HEIGHTDepth);
}

void draw() {
  background(200);
  PImage i = kinect.getBodyTrackImage();
  //println(i.width, i.height);
  //println(KinectPV2.WIDTHColor, KinectPV2.WIDTHDepth);
  image(i, 0, 0);
  PImage di = kinect.getDepthImage();
  //PImage di256 = kinect.getDepth256Image();
  PImage pcImage = kinect.getPointCloudDepthImage();
  List<KSkeleton> skeletonDepthMap = kinect.getSkeleton3d();
  if (skeletonDepthMap.size() > 0) {
    KSkeleton first = skeletonDepthMap.get(0);
    KJoint j = first.getJoints()[0];
    //println(j.getPosition());
    println(skeletonDepthMap); //<>//
  }
  image(di, 512, 0);
  image(pcImage, 1024, 0);
  //int[] rawDepth = kinect.getRawDepth256Data(); // DepthData();
  //image(kinect.getColorImage(), 0, 0);
  //println(frameRate);
  color c = di.get(mouseX - 512, mouseY);
  String debug = red(c)+", "+green(c)+", "+blue(c)+", "+alpha(c);
  //int pxIndex = mouseY*KinectPV2.WIDTHDepth+(mouseX - 512);
  //if (pxIndex >= 0 && pxIndex < rawDepth.length) {
  //  debug += ", " + rawDepth[pxIndex];
  //}
  fill(0);
  //text(debug, mouseX, mouseY);
  PVector k = new PVector((mouseX - width/2) / 1000f, (mouseY - height/2) / 1000f, sin(millis() / 1000f) * 10);
  text(k+"->"+kinect.MapCameraPointToColorSpace(k).toString(), mouseX, mouseY);
}