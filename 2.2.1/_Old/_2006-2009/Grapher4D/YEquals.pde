
float y(float x, float z, float t) {
  try{
    return x*cos(t)+z*sin(t);
//    return (10 - 3*x - 3*z) / 3;
    //    return 1640*log(x*20/(x/z-z/x));
  }
  catch(ArithmeticException e) {
    return 0;
  }
}
