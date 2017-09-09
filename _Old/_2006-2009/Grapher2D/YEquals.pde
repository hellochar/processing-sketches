void drawWhich() {
  y1.draw();
  y2.draw();
  y3.draw();
  y4.draw();
}

Function y1 = new Function(color(255, 0, 0)) {
  float func(float x) {
    return pow(x*255, .46f)*(1+sin(PI*x / 200) + sqrt(x / 1000))/2;
  }
};

Function y2 = new Function(color(0, 255, 0)) {
  float func(float x) {
    return y1.func(x)*(1+sin(PI*x / 17))/2;
  }
};

Function y3 = new Function(color(0, 0, 255)) {
  float func(float x) {
    return 1/atan(x);
  }
};

Function y4 = new Function(color(0, 0, 0)) {
  float func(float x) {
    return 3;
  }
};
