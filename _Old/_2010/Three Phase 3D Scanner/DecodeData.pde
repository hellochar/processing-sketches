float[][] _wrapphase = new float[inputHeight][inputWidth];
boolean[][] _mask = new boolean[inputHeight][inputWidth];
boolean[][] _process = new boolean[inputHeight][inputWidth];

void decodeData() {
  phaseUnwrapAll();
  propagatePhases();
}
