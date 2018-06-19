import java.util.*;

int sgn(float number) {
  if (number > 0) { return 1; }
  if (number < 0) { return -1; }
  return 0;
}

// all links want to be totally straight relative to their parent
// each link has its own coordinate system.
// +x is pointing in the direction of the link
// +y is pointing "down" perpendicular to the link
// the link's position is expressed relative to the parent link, using polar coordinates.
// the radius never changes, but gravity will pull down on the link and modify the angle.
// ok lets try that
class Link {
  // distance from parent
  float radius;
  // angle of this link's +x (clockwise) relative to the parent's +x
  float angle;
  Link parent;
  Link child;
  
  // cached positions
  private PVector worldPosition = new PVector();
  private float worldAngle;
  private PVector relativePosition = new PVector();
  
  Link(Link p, float radius, float angle) {
    parent = p;
    if (p != null) {
      p.child = this;
    }
    this.radius = radius;
    this.angle = angle;
    this.updatePositionsAndWorldAngle();
  }
  
  // update the relativePosition and worldPosition to match the new angle/radius
  // and parent's positions. Also recursively calls updatePositions on children.
  // So you only need to call this once on the root to update the positions for the whole chain.
  void updatePositionsAndWorldAngle() {
    if (parent == null) {
      // root world angle
      // worldAngle = map(mouseY, 0, height, -PI / 2, 0);
      worldAngle = -PI / 4;
    } else {
      worldAngle = parent.worldAngle + angle;
    }
    // set relative position
    relativePosition.set(cos(worldAngle) * radius, sin(worldAngle) * radius);
    
    // set world position
    
    if (parent == null) {
      // root Link
      worldPosition.set(width/4, height/2);
    } else {
      worldPosition.set(parent.worldPosition).add(relativePosition); 
    }
    if (child != null) {
      child.updatePositionsAndWorldAngle();
    }
  }

  float nextAngle;
  /**
   * Compute a timestep of gravity (or any other forces) pulling on this Link. The new angle is stored in
   * the nextAngle variable. To update, set all the nextAngles together and then call updatePositions() on the
   * whole chain.
   */
  void computeNextAngle(float dt) {
    if (this.parent == null) {
      return;
    }
    // computing the next angle:
    // take the world position, simulate it falling down due to gravity
    // the gravity force falls globally downwards
    // the parent spring force points perpendicular to the parent's world angle, scaled by the angle difference
    PVector totalForce = new PVector();
    
    // gravity
    totalForce.add(0, 10);
    strokeWeight(1);
    stroke(255, 0, 0);
    line(worldPosition.x, worldPosition.y, worldPosition.x + totalForce.x, worldPosition.y + totalForce.y);
    
    // parent spring force //<>//
    float STIFFNESS = map(mouseX, 0, width, 0, 100);
    //float STIFFNESS = 10;
    // curl inwards a bit - bias this.angle a bit
    // float biasedAngle = this.angle + map(mouseY, 0, height, -PI/4, PI/4);
    float biasedAngle = this.angle;
    //float theta = biasedAngle * biasedAngle;
    float theta = biasedAngle;
    float parentSpringForceMagnitude = theta * STIFFNESS * radius;
    float parentSpringForceWorldAngle = parent.worldAngle - PI / 2;
    PVector parentSpringForce = PVector.fromAngle(parentSpringForceWorldAngle).mult(parentSpringForceMagnitude);
    stroke(0, 255, 0);
    line(worldPosition.x, worldPosition.y, worldPosition.x + parentSpringForce.x, worldPosition.y + parentSpringForce.y);
    totalForce.add(parentSpringForce);
    
    // ok, now we have the "force". Add it to the world position to compute a new world position
    // and then extract the angle from that.
    
    PVector newWorldPosition = worldPosition.copy().add(totalForce.mult(dt));
    PVector newRelativePosition = newWorldPosition.copy().sub(parent.worldPosition);
    // i think this newWorldAngle translation is fucking it.
    float newWorldAngle = atan2(newRelativePosition.y, newRelativePosition.x);
    
    // finally, convert the world angle into the local angle. This just involves subtracting from the parent's world angle.
    float newAngle = newWorldAngle - parent.worldAngle;
    
    // special case to avoid instability: if you'd go past the 0, instead go to 0
    //if (abs(sgn(newAngle) - sgn(this.angle)) == 2) {
    //  nextAngle = 0;
    //} else {
    //  nextAngle = newAngle; //<>//
    //}
    nextAngle = newAngle;
  }
  
  // This doesn't work well since you can't go backwards in time (the log is negative)
  // so we hit the edge case (where you get a NaN for t) *a lot* 
  void analyticalNextAngle(float dt) {
    // for a constant G, the integral is O = 1*e^(-kt) + G/k
    // so we want the next O. We need to figure out the "current time" based off our current O, then add dt, then compute the next O
    // O - G/k = 1*e^(-kt)
    // log(O - G/k) = -kt
    // -log(O - G/k) / k = t
    // -log(O - (k*wantedAngle + G) / k) / k = t
    float G = 1;
    float stiffness = 1; // map(mouseX, 0, width, 1, 10);
    float wantedAngle = map(mouseY, 0, height, 0, -PI / 4);
    float t = -log(angle - (stiffness * wantedAngle + G) / stiffness) / stiffness;
    if (t != t) {
      t = 0;
    }
    float tNew = t + dt;
    float newTheta = exp(-stiffness*tNew) + (stiffness * wantedAngle + G) / stiffness;
    nextAngle = newTheta;
  }
  
  /**
   * Invalidates the position of this link and all downstream links. Be sure to recompute them.
   */
  void updateAngle() {
    // now the positions are invalid.
    this.angle = nextAngle;
  }
}

// ok so this works, kinda, but it's numerically instable.
// what's happening exactly?
// i'm not sure, lets just cap the angle at -PI/4, PI/4 (this should never even happen)

List<Link> links;

float LINK_RADIUS = 100;

void setup() {
  size(800, 600);
  links = new ArrayList();
  links.add(new Link(null, LINK_RADIUS, 0));
  for (int i = 1; i < 2; i++) {
    Link l = new Link(links.get(i - 1), LINK_RADIUS, 0);
    links.add(l);
  }
}

void draw() {
  background(255);
  for (Link l : links) {
    l.computeNextAngle(0.1);
  }
  for (Link l : links) {
    l.updateAngle();
  }
  links.get(0).updatePositionsAndWorldAngle();
  
  strokeWeight(1);
  stroke(0);
  noFill();
  beginShape();
  for (Link l : links) {
    vertex(l.worldPosition.x, l.worldPosition.y);
  }
  saveFrame("test/####.png");
  endShape();
}