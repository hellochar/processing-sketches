float y(float x, float z) {
  try{
    return z/(x*x+z);
  }
  catch(ArithmeticException e) {
    return 0;
  }
}
