abstract class SingleGrowth implements Growth {

    public SingleGrowth() {
    }
    
    public abstract String getText();
    
    public void show() {
      text(getClass().getSimpleName() + "["+getText()+"]", 0, 0);
    }
    
    protected abstract Set getGrowth(MNode parent);

    public Set grow(MNode parent) {
        Set set = getGrowth(parent);
        parent.getChildren().addAll(set);
        return set;
    }
}
