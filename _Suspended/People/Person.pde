public static final float MAX_LIKING = 10;
static int id = 0;
class Person {
  final int myId = id++;
  float x, y;
  float dx, dy;
  int c;
  boolean[] traits;
  Map<Person, Relationship> relationships;

  Person(float x_, float y_, boolean[] traits) {
    if(traits.length != 8) throw new RuntimeException("Traits must be length 8!");
    x = x_;
    y = y_;
    this.traits = traits;
    relationships = new HashMap();
  }

  Person(float x_, float y_) {
    this(x_, y_, createRandomTraits());
  }

  Relationship getRelationship(Person p) {
    if(relationships.get(p) == null) relationships.put(p, new Relationship(p));
    return relationships.get(p);
  }

  //two people really hate each other, sim = -8. really like each other, sim = 8. This is an initial measure of how much two people will like each other.
  int similarity(Person p) {
    int sim = 0;
    for(int i = 0; i < traits.length; i++) {
      if(traits[i] == p.traits[i]) sim++;
      else sim--;
    }
    return sim;
  }

  //a relationship between two people is not the same for the two people who it pertains to.
  class Relationship {
    Person p;
    float liking;
    int began, lastRan, history;
    
    Relationship(Person p) {
      this.p = p;
      liking = similarity(p);
      began = frameCount;
    }
    
    void run() {
      lastRan = frameCount;
      history++;
      if(history % 10 == 0) liking = (liking+similarity(p))/2;
      liking += Math.signum(liking)*(MAX_LIKING - abs(liking))*.02;
//      println(liking);
    }
  }
  
}

boolean[] createRandomTraits() {
  boolean[] b = new boolean[8];
  for(int i = 0; i < b.length; i++) {
    b[i] = random(1) < .5;
  }
  return b;
}

