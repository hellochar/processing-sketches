class FlowerGrowth extends BranchGrowth {

    public FlowerGrowth() {
    }

    public FlowerGrowth createRandom() {
        return new FlowerGrowth((int)random(1, 6), random(25, 200));
    }

    public FlowerGrowth(int num, float radius) {
        super(num, 360f/num, radius);
    }

}
