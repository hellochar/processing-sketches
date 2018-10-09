abstract class Config {
  color bg;
  PVector delta = new PVector();

  Config(color bg) {
    this.bg = bg;
  }

  abstract void init();
  abstract void update(Runner r, PImage source);
}
