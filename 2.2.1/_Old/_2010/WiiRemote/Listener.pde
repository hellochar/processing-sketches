class Listener extends WiiRemoteAdapter {
  
  public void accelerationInputReceived(WRAccelerationEvent evt) {
    println(evt.getXAcceleration()+" ,"+evt.getYAcceleration()+", "+getZAcceleration());
  }
  
}
