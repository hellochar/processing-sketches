import peasy.*;

float[] xs, ys, zs;
PeasyCam cam;

void setup() {
  size(800, 600, P3D);
  cam = new PeasyCam(this, 400);
  
  xs = new float[1000];
  ys = new float[xs.length];
  zs = new float[xs.length];
  
  float x = 0;
  float y = 0;
  float z = 0;
  
  float focalPoint = width / 2;
  for (int i = 0; i < xs.length; i++) {
    xs[i] = x;
    ys[i] = y;
    zs[i] = z;
    
    float x2 = x + random(-7, 7);
    float y2 = y + random(-7, 7);
    float z2 = map(i, 0, xs.length, 1, focalPoint * 2);
    
    x = x2;
    y = y2;
    z = z2;
  }
}

void draw() {
  background(255);
  strokeCap(ROUND);
  
  float lineThickness = 5; // 5px right at the focal point 
  float focalDistance = 200;
  float[] cameraPosition = cam.getPosition(); // the camera is at (cx, cy, cz)
  // the point is at (x, y, z)
  for (int i = 0; i < xs.length - 1; i++) {
    float x = xs[i];
    float y = ys[i];
    float z = zs[i];
    float x2 = xs[i + 1];
    float y2 = ys[i + 1];
    float z2 = zs[i + 1];
    
    float midX = (x + x2) / 2;
    float midY = (y + y2) / 2;
    float midZ = (z + z2) / 2;
    
    float distanceToCamera = dist(cameraPosition[0], cameraPosition[1], cameraPosition[2], midX, midY, midZ);
    // we want this to be 1 at focalPoint, some higher number e.g. 5 very close by, and approaching 0 as it gets farther 
    float dofDistance = distanceToCamera / focalDistance; // at z = 1, dofDistance is very small like 0.02; at z = 200, dofDistance becomes 2
     // draw a line in 3d space. Points closer are more translucent but also bigger and blurrier (TODO how to do blurrier?)
    float percievedThickness = lineThickness / dofDistance;
    // lines at the dof and above are fully opaque, but lines nearer the camera have some opacity
    float opacity = min(1, dofDistance);
    //println(opacity);
    stroke(0, opacity * 255);
    strokeWeight(percievedThickness); // note that the perspective projection already divides by distance; we do it even more to attenuate the effect
    line(x, y, z, x2, y2, z2);
  }
}