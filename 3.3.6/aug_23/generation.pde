
class Generation {
  List<Walker> population;
  int age = 0;
  Generation(List<Walker> population) {
    this.population = population;
  }
  
  public void step() {
    Arrays.fill(numWalkers, 0);
    for (Walker w : population) {
      int index = w.y * gridWidth + w.x;
      if (index >= 0 && index < numWalkers.length) {
        numWalkers[index]++;
      }
    }
    for (Walker w : population) {
      w.step();
    }
    age++;
  }
  
  public Generation nextGeneration() {
    // sort the current population by fitness
    // take the top half
    // copy the top half, mutating each one
    // that's the new population
    //population.sort(null);
    Collections.sort(population, Collections.reverseOrder());
    List<Walker> topHalf = population.subList(0, population.size() / 2);
    //List<Walker> topHalfMutated = new ArrayList(topHalf.size());
    List<Walker> nextGen = new ArrayList(population.size());
    for (Walker w : topHalf) {
      nextGen.add(w.reset());
      nextGen.add(w.mutate());
    }
    return new Generation(nextGen);
  }
}

public Generation randomGeneration() {
  List<Walker> generation = new ArrayList();
  for (int i = 0; i < 30; i++) {
    Walker walker = new Walker(randomPath());
    generation.add(walker);
  }
  return new Generation(generation);
}