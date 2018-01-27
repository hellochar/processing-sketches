Vec3D centeringForce = new Vec3D();
 
class Particle {
  Vec3D position, velocity, force;
  Vec3D localOffset;
  
  public String toString() {
    Vec3D pos = position, vel = velocity;
    return pos.x+", "+pos.y+", "+pos.z+", "+vel.x+", "+vel.y+", "+vel.z;
  }
  
  Particle() {
    resetPosition();
    velocity = new Vec3D();
    force = new Vec3D();
    localOffset = Vec3D.randomVector();
  }
  void resetPosition() {
    position = Vec3D.randomVector();
    position.scaleSelf(random(rebirthRadius));
    if(particles.size() == 0)
      position.addSelf(avg);
    else
      position.addSelf(randomParticle().position);
  }
  void draw() {
    float distanceToFocalPlane = focalPlane.getDistanceToPoint(position);
    distanceToFocalPlane *= 1 / dofRatio;
    distanceToFocalPlane = constrain(distanceToFocalPlane, 1, 15);
    strokeWeight(distanceToFocalPlane);
    stroke(255, constrain(255 / (distanceToFocalPlane * distanceToFocalPlane), 1, 255));
    point(position.x, position.y, position.z);
  }
  void applyFlockingForce() {
    force.addSelf(
      noise(
        position.x / neighborhood + globalOffset.x + localOffset.x * independence,
        position.y / neighborhood,
        position.z / neighborhood)
        - .5,
      noise(
        position.x / neighborhood,
        position.y / neighborhood + globalOffset.y  + localOffset.y * independence,
        position.z / neighborhood)
        - .5,
      noise(
        position.x / neighborhood,
        position.y / neighborhood,
        position.z / neighborhood + globalOffset.z + localOffset.z * independence)
        - .5);
  }
  void applyViscosityForce() {
    force.addSelf(velocity.scale(-viscosity));
  }
  void applyCenteringForce() {
    centeringForce.set(position);
    centeringForce.subSelf(avg);
    float distanceToCenter = centeringForce.magnitude();
    centeringForce.normalize();
    centeringForce.scaleSelf(-distanceToCenter / (spread * spread));
    force.addSelf(centeringForce);
  }
  void update() {
    force.clear();
    applyFlockingForce();
    applyViscosityForce();
    applyCenteringForce();
    velocity.addSelf(force); // mass = 1
    position.addSelf(velocity.scale(speed));
  }
}

