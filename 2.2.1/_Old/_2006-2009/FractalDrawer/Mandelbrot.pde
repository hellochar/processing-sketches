//Mandelbrot
int maxIter = 1500; //change this to get more accurate but time-consuming results
double[] valsX = new double[maxIter];
double[] valsY = new double[maxIter];
double log2 = Math.log(2);
final double bailout = 6;
double solveFor(double x, double y) {
  int iter = 0;
  Complex c = new Complex(x, y);
  Complex z = new Complex(0, 0);
  
  while(z.mod() <= bailout*bailout && iter < maxIter) {
//    z = z.multiply(z).multiply(z).subtract(z.multiply(z).multiply(2)).add(c);
    z = z.times(z).times(z).plus(z.times(z)).plus(c);
    valsX[iter] = z.real();
    valsY[iter] = z.imag();
    iter++;
  }
  
  if(iter >= maxIter) {
    setPixAt(x, y, #000000);
    return maxIter;
  }
  else {
//    double change = 1-(Math.log(Math.log(z.magnitude())))/log2;
    double change = ( Math.log(2 * Math.log(bailout)) - Math.log(Math.log(z.mod())) ) / Math.log(4);
    double val = iter+change; //This gives a smooth transition between colors
//    println("iter, change, percentage: "+iter+", "+change+", "+(100 * Math.abs(change) / val));
//    mx = (deviation(valsX, iter)+sum(valsX, iter))/2; //for some reason, my deviation method doesn't work. Feel free to tell me why :D
//    my = (deviation(valsY, iter)+sum(valsX, iter))/2;
//    mx = sum(valsX, iter);
//    my = sum(valsY, iter);
//    val = Math.sqrt(mx*mx+my*my); //this colors it according to the magnitude of the complex number represented by mx and my
//    val = Math.atan2(y, x)*Math.sqrt(mx*mx+my*my); //this colors it through a mix of angle and magnitude
//    val = Math.pow(val, .5); //If there are too many colors, use this to get some stabilization
    return val;
  }
}

double mean(double[] array, int end) {
  return sum(array, end)/end;
}

double sum(double[] array, int end) {
  if(end > array.length) end = array.length;
  double k = 0;
  for(int a =0 ; a < end; a++) {
    k += array[a];
  }
  return k;
}

double deviation(double[] array, int end) {
  double k = mean(array, end);
  for(int a = 0; a < end; a++) {
    array[a] -= k;
  }
  for(int a = 0; a < end; a++) {
    array[a] *= array[a];
  }
  return Math.sqrt(mean(array, end));
}
