
double xPressed, yPressed;
boolean dragged;
void mousePressed() {  
  if(mouseButton == LEFT) {
    xPressed = mouseX;
    yPressed = mouseY;
    dragged = true;
  }
  else if(mouseButton == RIGHT) {
    if(xMinStack.size() > 1) {
      setCamBoundaries((Double)xMinStack.pop(), (Double)xMaxStack.pop(), (Double)yMinStack.pop(), (Double)yMaxStack.pop());
    }
  }
}

void mouseClicked() {
  if(mouseButton == LEFT) {
    dragged = false;
    setCam(xCoord(mouseX)-xCamDif*.5, xCoord(mouseX)+xCamDif*.5, yCoord(mouseY)-yCamDif*.5, yCoord(mouseY)+yCamDif*.5);
  }
}

void mouseReleased() {
  if(mouseButton == LEFT & xPressed-mouseX != 0 & yPressed-mouseY != 0) {
    dragged = false;
    setCam(xCoord(Math.min(xPressed, mouseX)), xCoord(Math.max(xPressed, mouseX)), yCoord(Math.min(yPressed, mouseY)), yCoord(Math.max(yPressed, mouseY)));
  }
}
