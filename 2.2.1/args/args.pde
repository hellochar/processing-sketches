void setup() {
  size(500, 500);
  println("args: "+Arrays.toString(args));
}

static void main(String[] args) {
  System.out.println(Arrays.toString(args));
  PApplet.main(new String[] {"sketch_may19b", "abc"});
}
