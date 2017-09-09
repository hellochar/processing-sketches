double sensitivity = 1;
boolean control;
boolean aPressed;
void keyPressed() {
  if(key == CODED) {
    if(keyCode == CONTROL) {
      control = true;
    }
    else if(keyCode == UP) {
      setCam(xMin, xMax, yMin-yCamDif*.1, yMax-yCamDif*.1);
      render();
    }
    else if(keyCode == DOWN) {
      setCam(xMin, xMax, yMin+yCamDif*.1, yMax+yCamDif*.1);
      render();
    }
    else if(keyCode == LEFT) {
      setCam(xMin-xCamDif*.1, xMax-xCamDif*.1, yMin, yMax);
      render();
    }
    else if(keyCode == RIGHT) {
      setCam(xMin+xCamDif*.1, xMax+xCamDif*.1, yMin, yMax);
      render();
    }
  }
  else if(keyCode == 83 && control) { //83 == s
    println(save());
  }
  else if(key == '-') {
    setCam(xMin-xCamDif*.5, xMax+xCamDif*.5, yMin-yCamDif*.5, yMax+yCamDif*.5);
  }
  else if(key == '=') {
    setCam(xMin+xCamDif*.25, xMax-xCamDif*.25, yMin+yCamDif*.25, yMax-yCamDif*.25);
  }
  else if(key >= '0' & key <= '9') {
    sensitivity = 1+int(String.valueOf(key));
    render();
  }
  else if(key == 'a') {
    aPressed = !aPressed;
    render();
  }
}

void keyReleased() {
  if(key == CODED) {
    if(keyCode == CONTROL) {
      control = false;
    }
  }
}

void mouseMoved() {
  if(mouseX < width/5) {
    xalign = LEFT;
    textAlign(xalign, yalign);
  }
  else if(mouseX > .8*width) {
    xalign = RIGHT;
    textAlign(xalign, yalign);
  }
  if(mouseY < height/5) {
    yalign = TOP;
    textAlign(xalign, yalign);
  }
  else if(mouseY > .8*height) {
    yalign = BOTTOM;
    textAlign(xalign, yalign);
  }
}

void mouseDragged() {
  mouseMoved();
}

