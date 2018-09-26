
class Generation {
  List<Runner> population;
  int age = 0;
  Generation(List<Runner> population) {
    this.population = population;
  }
  
  public void step() {
    Arrays.fill(numRunners, 0);
    for (Runner w : population) {
      int index = w.y * gridWidth + w.x;
      if (index >= 0 && index < numRunners.length) {
        numRunners[index]++;
      }
    }
    for (Runner w : population) {
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
    List<Runner> topHalf = population.subList(0, population.size() / 2);
    //List<Runner> topHalfMutated = new ArrayList(topHalf.size());
    List<Runner> nextGen = new ArrayList(population.size());
    for (Runner w : topHalf) {
      nextGen.add(w.reset());
      nextGen.add(w.mutate());
    }
    return new Generation(nextGen);
  }
}

public Generation randomGeneration() {
  List<Runner> generation = new ArrayList();
  for (int i = 0; i < 30; i++) {
    Runner runner = new Runner(randomPath());
    generation.add(runner);
  }
  return new Generation(generation);
}