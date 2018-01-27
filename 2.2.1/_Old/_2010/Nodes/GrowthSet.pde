abstract class GrowthSet implements Growth {

  Collection grows;

  public GrowthSet(Collection grows) {
    this.grows = grows;
  }

  public void addGrowth(Growth g) {
    grows.add(g);
  }

  public void removeGrowth(Growth g) {
    grows.remove(g);
  }

  public void show() {
    text(getClass().getSimpleName()+" [num="+grows.size()+"]", 0, 0);
    pushStyle();
    translate(15, lineHeight);
    stroke(0);
    strokeWeight(1);
    Iterator gr = grows.iterator();
    while(gr.hasNext()) {
      Growth g = (Growth) gr.next();
      //vertical
      line(0, 0, 0, lineHeight);
      //horizontal
      line(0, lineHeight, lineHeight * .7f, lineHeight);
      translate(lineHeight, lineHeight / 2);
      g.show();
      translate(-lineHeight, lineHeight / 2);
      //            translate(0, lineHeight);
    }
    translate(-15, 0);
    popStyle();
  }

}



