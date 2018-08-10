
float symmetricRandom(float low, float high, float y) {
  return map(noise(y) + noise(-y), 0, 2, low, high);
}