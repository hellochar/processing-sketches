import processing.video.*;

// take three videos, play them together, and export it.

Movie frames16, frames17, frames18;

void setup() {
  size(1280, 800, P2D);
  frames16 = new Movie(this, "frames16.mp4");
  frames17 = new Movie(this, "frames17.mp4");
  frames18 = new Movie(this, "frames18.mp4");
  
  frames16.play();
  frames17.play();
  frames18.play();
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  //image(frames16, 0, 0, frames16.width / 3, frames16.height / 3);
  //image(frames17, frames16.width/3, 0, frames17.width / 3, frames17.height / 3);
  //image(frames18, frames16.width / 3 + frames17.width / 3, 0, frames18.width / 3, frames18.height / 3);
  int idx = (frameCount / 5) % 3;
  Movie choice = (new Movie[] {frames16, frames17, frames18})[idx];
  //if (frameCount < 250 / 3) {
  //  choice = frames16;
  //} else if (frameCount < 250 / 3 * 2) {
  //  choice = frames17;
  //} else {
  //  choice = frames18;
  //}
  
  image(choice, 0, 0);
}