import zhang.Camera;
//attempt to simulate friendship networks over time. each person
//has a list of traits they have and a list of traits they like.
//people are attracted to people they like and repelled by
//people they don't like. Traits change over time.

//idea: The threshold between "like" and "don't like" is yet another trait.

List<Person> people;
public static final float MAX_DIST = 80,
MIN_DIST = 1,
SPEED_FAC = .02;
Camera cam;

void setup() {
  size(800, 600);
  people = new ArrayList();
  cam = new Camera(this);
  for(int i = 0; i < 20; i++) people.add(new Person(random(width), random(height)));
//  smooth();
}

void mousePressed() {
  people.add(new Person(mouseX, mouseY));
}


void draw() {
  background(200, 200, 100);
  //draw things
  for(int i = 0; i < people.size(); i++) {
    Person me = people.get(i);
    boolean[] traits = me.traits;
    
    me.dx += random(-.1, .1);
    me.dy += random(-.1, .1);
    
    if(random(1) < .001) {
      int d = (int)random(traits.length);
      traits[d] = !traits[d];
    }
    
    for(int j = i+1; j < people.size(); j++) { // all of these next calculations are commutative in some way or another, so we only need do one calculation per pair.
      Person p = people.get(j);
      float ofx = me.x - p.x, ofy = me.y - p.y;
      float dist2 = ofx*ofx + ofy*ofy;
      if(dist2 < MAX_DIST*MAX_DIST) {
        //person p is in range of me.
        Person.Relationship r = me.getRelationship(p);
      }
    }
//      println(me.myId+": "+me.relationships.values().size());
      for(Person.Relationship r : me.relationships.values()) {
        Person p = r.p;
      float ofx = me.x - p.x, ofy = me.y - p.y;
        stroke(255);
        strokeWeight(r.liking < 1 ? 1 : r.liking*2);
        line(me.x, me.y, p.x, p.y);
//        float dist = sqrt(dist2);
        //you can see that person and want to be closer or farther away. If you're not like the person at all, you want to be max dist away. if you and that person
        //are exactly alike, you want to be min dist away. There's a direct mapping for in between.
        float wantDx, wantDy;
        if(r.liking > 0) {
        float wantDist = map(r.liking, 0, me.traits.length, MAX_DIST, MIN_DIST);
        float ang = atan2(ofy, ofx);
        float wantX = p.x + wantDist * cos(ang),
              wantY = p.y + wantDist * sin(ang);
        wantDx = (wantX - me.x) * SPEED_FAC;
        wantDy = (wantY - me.y) * SPEED_FAC;
        }
        else {
          wantDx = constrain((r.liking-1)*ofx*.02, -5, 5);
          wantDy = constrain((r.liking-1)*ofy*.02, -5, 5);
        }
//        ellipse(wantX, wantY, 10, 10);
        me.dx += wantDx;
        me.dy += wantDy;
//        p.dx += -wantDx;
//        p.dy += -wantDy;
        r.run();
//      }
    }
  }
  
  //draw things
  final float SIZE = 15;
  for(Person p : people) {
//    noFill();
//    stroke(255);
//    ellipse(p.x, p.y, MAX_DIST*2, MAX_DIST*2);
    
    fill(255, 0, 0);
    stroke(0);
    strokeWeight(1);
    ellipse(p.x, p.y, SIZE, SIZE);
    boolean[] traits = p.traits;
    for(int i = 0; i < traits.length; i++) {
      stroke(traits[i] ? 255 : 0);
      float x = p.x + (i-(traits.length-1.0)/2)*5;
      line(x, p.y-SIZE/2-2, x, p.y-SIZE/2-7);
    }
  }
  
  
  //update positions
  for(Person p : people) {
    p.x = constrain(p.x + (p.dx *= .98), 0, width);
    p.y = constrain(p.y + (p.dy *= .98), 0, height);
  }
}

