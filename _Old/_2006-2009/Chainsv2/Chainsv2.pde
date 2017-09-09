import java.awt.geom.*;
import javax.swing.*;
import java.awt.event.*;
import java.text.*;
import java.beans.*;
import java.awt.*;


 static final int mouseDrag = 5;
 static final int mouseCreate = 6;
 static final int mouseRemove = 7;
 static final int mouseAnchor = 8;


 static final int mouseConnect = 15;
 static final int mouseBreak = 16;
 static final int mouseConnectAll = 17;

int leftMouseMode = mouseDrag;
int rightMouseMode = mouseConnect;

 static final int vertexInitNum = 0;

class makeGUI extends JFrame implements ActionListener, ItemListener, PropertyChangeListener {


  static final String playPauseButtonString = "Play/Pause";
  static final String leftMouseLabelString = "Left Mouse Button";
  static final String leftMouseDragString = "Drag";
  static final String leftMouseCreateString = "Create";
  static final String leftMouseRemoveString = "Remove";
  static final String leftMouseAnchorString = "Anchor";


  static final String rightMouseLabelString = "Right Mouse Button";
  static final String rightMouseConnectString = "Connect";
  static final String rightMouseConnectAllString = "Connect All";
  static final String rightMouseBreakString = "Break";


  static final String showBgButtonString = "Background";
  static final String showConnectionsButtonString = "Connections";
  static final String showVerticesButtonString = "Vertices";
  static final String applyMomentumButtonString = "Apply Momentum";
  static final String rubberbandLikeButtonString = "Rubberband-like";
  static final String autoConnectButtonString = "Autoconnect";
  static final String wallNorthButtonString = "North Wall";
  static final String wallSouthButtonString = "South Wall";
  static final String wallEastButtonString = "East Wall";
  static final String wallWestButtonString = "West Wall";



  static final String rigidityTextFieldLabelString = "Rigidity: ";
  static final String gravityTextFieldLabelString = "Gravity: ";
  static final String dragTextFieldLabelString = "Momentum Drag: ";
  static final String wallReboundTextFieldLabelString = "Wall Rebound: ";

  NumberFormat defaultNF;


  JButton playPauseButton = new JButton(playPauseButtonString);

  JLabel leftMouseLabel = new JLabel(leftMouseLabelString);
  JRadioButton leftMouseDrag = new JRadioButton(leftMouseDragString);
  JRadioButton leftMouseCreate = new JRadioButton(leftMouseCreateString);
  JRadioButton leftMouseRemove = new JRadioButton(leftMouseRemoveString);
  JRadioButton leftMouseAnchor = new JRadioButton(leftMouseAnchorString);
  ButtonGroup leftMouseButtonGroup = new ButtonGroup();

  JLabel rightMouseLabel = new JLabel(rightMouseLabelString);
  JRadioButton rightMouseConnect = new JRadioButton(rightMouseConnectString);
  JRadioButton rightMouseConnectAll = new JRadioButton(rightMouseConnectAllString);
  JRadioButton rightMouseBreak = new JRadioButton(rightMouseBreakString);
  ButtonGroup rightMouseButtonGroup = new ButtonGroup();

  JCheckBox showBgButton = new JCheckBox(showBgButtonString);
  JCheckBox showConnectionsButton = new JCheckBox(showConnectionsButtonString);
  JCheckBox showVerticesButton = new JCheckBox(showVerticesButtonString);
  JCheckBox applyMomentumButton = new JCheckBox(applyMomentumButtonString);
  JCheckBox rubberbandLikeButton = new JCheckBox(rubberbandLikeButtonString);
  JCheckBox autoConnectButton = new JCheckBox(autoConnectButtonString);
  JCheckBox wallNorthButton = new JCheckBox(wallNorthButtonString);
  JCheckBox wallSouthButton = new JCheckBox(wallSouthButtonString);
  JCheckBox wallEastButton = new JCheckBox(wallEastButtonString);
  JCheckBox wallWestButton = new JCheckBox(wallWestButtonString);


  JLabel rigidityTextFieldLabel = new JLabel(rigidityTextFieldLabelString);
  JFormattedTextField rigidityTextField = new JFormattedTextField(defaultNF);
  JLabel gravityTextFieldLabel = new JLabel(gravityTextFieldLabelString);
  JFormattedTextField gravityTextField = new JFormattedTextField(defaultNF);
  JLabel dragTextFieldLabel = new JLabel(dragTextFieldLabelString);
  JFormattedTextField dragTextField = new JFormattedTextField(defaultNF);
  JLabel wallReboundTextFieldLabel = new JLabel(wallReboundTextFieldLabelString);
  JFormattedTextField wallReboundTextField = new JFormattedTextField(defaultNF);

  Container content;

  void addEmptySpace() {
    content.add(new JLabel());
  }

  makeGUI() {
    super("Chains");
    content = getContentPane();
    content.setLayout(new GridLayout(0, 2));
    playPauseButton.setActionCommand(playPauseButtonString);
    playPauseButton.addActionListener(this);


    leftMouseDrag.setActionCommand(leftMouseDragString);
    leftMouseDrag.addActionListener(this);
    leftMouseCreate.setActionCommand(leftMouseCreateString);
    leftMouseCreate.addActionListener(this);
    leftMouseRemove.setActionCommand(leftMouseRemoveString);
    leftMouseRemove.addActionListener(this);
    leftMouseAnchor.setActionCommand(leftMouseAnchorString);
    leftMouseAnchor.addActionListener(this);
    leftMouseButtonGroup.add(leftMouseDrag);
    leftMouseButtonGroup.add(leftMouseCreate);
    leftMouseButtonGroup.add(leftMouseRemove);
    leftMouseButtonGroup.add(leftMouseAnchor);
    leftMouseDrag.setSelected(true);


    rightMouseConnect.setActionCommand(rightMouseConnectString);
    rightMouseConnect.addActionListener(this);
    rightMouseConnectAll.setActionCommand(rightMouseConnectAllString);
    rightMouseConnectAll.addActionListener(this);
    rightMouseBreak.setActionCommand(rightMouseBreakString);
    rightMouseBreak.addActionListener(this);
    rightMouseButtonGroup.add(rightMouseConnect);
    rightMouseButtonGroup.add(rightMouseConnectAll);
    rightMouseButtonGroup.add(rightMouseBreak);
    rightMouseConnect.setSelected(true);


    showBgButton.addItemListener(this);
    showBgButton.setSelected(true);
    showConnectionsButton.addItemListener(this);
    showConnectionsButton.setSelected(true);
    showVerticesButton.addItemListener(this);
    showVerticesButton.setSelected(true);
    applyMomentumButton.addItemListener(this);
    rubberbandLikeButton.addItemListener(this);
    autoConnectButton.addItemListener(this);
    wallNorthButton.addItemListener(this);
    wallSouthButton.addItemListener(this);
    wallSouthButton.setSelected(true);
    wallEastButton.addItemListener(this);
    wallWestButton.addItemListener(this);

    rigidityTextField.setValue(new Double(rigidity));
    rigidityTextField.addPropertyChangeListener("value", this);
    gravityTextField.setValue(new Double(gravity));
    gravityTextField.addPropertyChangeListener("value", this);
    dragTextField.setValue(new Double(drag));
    dragTextField.addPropertyChangeListener("value", this);
    wallReboundTextField.setValue(new Double(wallRebound));
    wallReboundTextField.addPropertyChangeListener("value", this);


    content.add(playPauseButton);
    addEmptySpace();
    content.add(leftMouseLabel);           
    content.add(rightMouseLabel);              //Left Mouse Button     Right Mouse Button
    content.add(leftMouseDrag);            
    content.add(rightMouseConnect);            //Drag                  Connect
    content.add(leftMouseCreate);          
    content.add(rightMouseConnectAll);         //Create                Connect All
    content.add(leftMouseRemove);          
    content.add(rightMouseBreak);              //Remove                Break
    content.add(leftMouseAnchor);
    addEmptySpace();
    content.add(new JSeparator());         
    content.add(new JSeparator());             //-----------------------------------------
    content.add(showBgButton);             
    content.add(showConnectionsButton);        //[ ] Background        [ ] Connections
    content.add(showVerticesButton);
    content.add(applyMomentumButton);
    content.add(rubberbandLikeButton);
    content.add(autoConnectButton);
    content.add(rigidityTextFieldLabel);        
    content.add(rigidityTextField);                 //Pull Strength         **.0004***********
    content.add(gravityTextFieldLabel);
    content.add(gravityTextField);
    content.add(dragTextFieldLabel);
    content.add(dragTextField);
    content.add(wallReboundTextFieldLabel);
    content.add(wallReboundTextField);
    content.add(new JSeparator());         
    content.add(new JSeparator());             //-----------------------------------------
    content.add(wallNorthButton);
    content.add(wallSouthButton);
    content.add(wallEastButton);
    content.add(wallWestButton);
  }




  void actionPerformed(ActionEvent e) {
    String action = e.getActionCommand();
    if(action.equals(leftMouseDragString)) {
      leftMouseMode = mouseDrag;
    }
    else if(action.equals(playPauseButtonString)) {
      play = !play;
    }
    else if(action.equals(leftMouseCreateString)) {
      leftMouseMode = mouseCreate;
    }
    else if(action.equals(leftMouseRemoveString)) {
      leftMouseMode = mouseRemove;
    }
    else if(action.equals(leftMouseAnchorString)) {
      leftMouseMode = mouseAnchor;
    }
    else if(action.equals(rightMouseConnectString)) {
      rightMouseMode = mouseConnect;
    }
    else if(action.equals(rightMouseConnectAllString)) {
      rightMouseMode = mouseConnectAll;
    }
    else if(action.equals(rightMouseBreakString)) {
      rightMouseMode = mouseBreak;
    }
  }

  void itemStateChanged(ItemEvent e) {
    Object source = e.getItemSelectable();
    int state = e.getStateChange();
    if(source.equals(showBgButton)) {
      if(state == ItemEvent.SELECTED) showBg = true;
      else showBg = false;
    }
    else if(source.equals(showConnectionsButton)) {
      if(state == ItemEvent.SELECTED) showConnections = true;
      else showConnections = false;
    }
    else if(source.equals(showVerticesButton)) {
      if(state == ItemEvent.SELECTED) showVertices = true;
      else showVertices = false;
    }
    else if(source.equals(applyMomentumButton)) {
      if(state == ItemEvent.SELECTED) { 
        applyMomentum = true; 
      }
      else {
        applyMomentum = false;
        for(int a = 0; a < vertex.length; a++)
          vertex[a].resetMomentum();
      }
    }
    else if(source.equals(rubberbandLikeButton)) {
      if(state == ItemEvent.SELECTED) rubberbandLike = true;
      else rubberbandLike = false;
    }
    else if(source.equals(autoConnectButton)) {
      if(state == ItemEvent.SELECTED) autoConnect = true;
      else autoConnect = false;
    }
    else if(source.equals(wallNorthButton)) {
      if(state == ItemEvent.SELECTED) wallNorth = true;
      else wallNorth = false;
    }
    else if(source.equals(wallSouthButton)) {
      if(state == ItemEvent.SELECTED) wallSouth = true;
      else wallSouth = false;
    }
    else if(source.equals(wallEastButton)) {
      if(state == ItemEvent.SELECTED) wallEast = true;
      else wallEast = false;
    }
    else if(source.equals(wallWestButton)) {
      if(state == ItemEvent.SELECTED) wallWest = true;
      else wallWest = false;
    }
  }

  void propertyChange(PropertyChangeEvent e) {
    JFormattedTextField source = (JFormattedTextField)e.getSource();
    if(source == rigidityTextField) {
      rigidity = ((Number)source.getValue()).floatValue();
    }
    else if(source == gravityTextField) {
      gravity = ((Number)source.getValue()).floatValue();
    }
    else if(source == dragTextField) {
      drag = ((Number)source.getValue()).floatValue();      
    }
    else if(source == wallReboundTextField) {
      wallRebound = ((Number)source.getValue()).floatValue();      
    }
  }

}

color bg = color(96);

boolean play = true;
boolean showBg = true;
boolean showConnections = true;
boolean showVertices = true;
boolean applyMomentum = false;
boolean rubberbandLike = false;
boolean autoConnect = false;

boolean wallNorth = false;
boolean wallSouth = false;
boolean wallEast = false;
boolean wallWest = false;


float rigidity = .5;
float drag = .975;
float wallRebound = .6;
float gravity = .25;
float spawnRandX;
float spawnRandY;

int a = 0;

Vertex[] vertex;

Vertex grabbed = null;
Vertex whichConnect = null;

float ax;
float ay;
float bx;
float by;


Vertex temp;
Point2D.Float mp = new Point2D.Float();
Point2D.Float tempPoint = new Point2D.Float();
Connection tempCon;
Connection[] tempConArray;

JFrame gui;

void setup() {
  size(800, 600);
  gui = new makeGUI();
  gui.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  gui.pack();
  gui.show();
  spawnRandX = width/2;
  spawnRandY = height/2;
  strokeWeight(5);
  stroke(bg/3, 25);
  vertex = new Vertex[vertexInitNum];
  for(a = 0; a < vertex.length; a++) {
    vertex[a] = randVertex();
    if(a > 0) vertex[a].connectTo(vertex[a-1]);
  }
  if(vertex.length > 1) vertex[0].connectTo(vertex[vertex.length-1]);
}


void draw() {
  if(showBg) background(bg);
  else background(color(bg, 10));
  for(a = 0; a < vertex.length; a++) {
    temp = vertex[a];
    if(play) temp.tugAll();
  }
  if(play)
    for(a = 0; a < vertex.length; a++)
      vertex[a].update();
  if(showConnections)
    for(a = 0; a < vertex.length; a++)
      vertex[a].showConnections();
  if(mousePressed) {
    if(mouseButton == CENTER)
      for(a = 0; a < vertex.length; a++)
      {
        temp = vertex[a];
        temp.resetMomentum();
        setVertexRandLoc(temp);
      }
    else if(mouseButton == LEFT & grabbed != null) {
      grabbed.setLocAbsolute(mouseX, mouseY);
      grabbed.resetMomentum();
    }
  }
  //  println("finished!");
}

void mousePressed() {
  mp.setLocation(mouseX, mouseY);
  if(leftMouseMode == mouseCreate && mouseButton == LEFT) {
    temp = randVertex();
    temp.setLocAbsolute(mouseX, mouseY);
    if(autoConnect) {
      if(whichConnect != null)
        temp.connectTo(whichConnect);
      whichConnect = temp;
    }
    vertex = (Vertex[])append(vertex, temp);
    return;
  }
  for(a = vertex.length-1; a >= 0; a--) {
    temp = vertex[a];
    temp.locSetAs(tempPoint);
    if(tempPoint.distance(mp) < 10) {
      switch(mouseButton) {
      case LEFT:
        switch(leftMouseMode) {
        case mouseDrag: 
          grabbed = temp; 
          break;
        case mouseRemove: 
          remove(temp); 
          break;
        case mouseAnchor: 
          temp.anchor = !temp.anchor; 
          break;
        }
        break;
      case RIGHT:
        if(rightMouseMode == mouseConnectAll) {
          for(a = 0; a < vertex.length; a++)
            temp.connectTo(vertex[a]);
        }
        else {
          if(whichConnect == null) {
            whichConnect = temp;
          }
          else if(temp == whichConnect)
            whichConnect = null;
          else {
            if(rightMouseMode == mouseConnect) {
              whichConnect.connectTo(temp);
            }
            else if(rightMouseMode == mouseBreak) {
              killConnection(whichConnect, temp);
            }
            //            whichConnect.update();
            //            temp.update();
            if(autoConnect) whichConnect = temp;
            else whichConnect = null;
          }
        }
      }
      break;
    }
  }

}

void mouseReleased() {
  if(mouseButton == LEFT) {
    if(grabbed != null) {
      grabbed.setLoc(mouseX, mouseY);
      grabbed = null;
    }
  }
}


public void remove(Vertex temp) {
  if(temp == null) return;
  if(temp == whichConnect) whichConnect = null;
  for(int index = 0; index < vertex.length; index++) {
    if(vertex[index].equals(temp)) {
      if(index == 0) vertex = (Vertex[]) subset(vertex, 1, vertex.length-1);
      else if(index == vertex.length-1) vertex = (Vertex[]) subset(vertex, 0, vertex.length-1);
      else vertex = (Vertex[])concat(subset(vertex, 0, index), subset(vertex, index+1, vertex.length-index-1));
      temp.kill();
      return;
    }
  }
}

public void killConnection(Vertex a, Vertex b) {
  if(!a.unConnect(b)) b.unConnect(a);
}


void setVertexRandLoc(Vertex which) {
  which.setLocAbsolute(width/2-spawnRandX/2+random(spawnRandX), height/2-spawnRandY/2+random(spawnRandY));
  which.clrData();
  which.resetMomentum();
  //  which.update();
}

Vertex randVertex() {
  Vertex v = new Vertex(0, 0);
  setVertexRandLoc(v);
  v.setColor(color(random(255), random(255), random(255)));
  return v;
}

float degAlign(float deg) {
  deg = deg%360;
  if(deg < 0) deg = abs(deg)+(deg+180)*2;
  if(abs(round(deg)-deg) < .00004) deg = round(deg);
  return deg;
}

float radAlign(float rad) {
  rad = rad%TWO_PI;
  if(rad < 0) rad = abs(rad)+(rad+PI)*2;
  return rad;
}

float radTo(float x1, float y1, float x2, float y2) {
  return atan2(y2-y1, x2-x1);
}

float radTo(Point2D.Float which, Point2D.Float to) {
  return radTo(which.x, which.y, to.x, to.y);
}

float angleTo(float x1, float y1, float x2, float y2) {
  return degrees(radTo(x1, y1, x2, y2));
}

float angleTo(Point2D.Float which, Point2D.Float to) {
  return angleTo(which.x, which.y, to.x, to.y);
}

float median(float[] arg0, int num) {
  if(num > arg0.length) num = arg0.length;
  else if(num < 0) return 0;
  float mean = 0;
  for(int a = 0; a < num; a++)
    mean += arg0[a];
  return mean/num;
}

float realign(float rad) {
  while (rad < 0) rad += TWO_PI;
  while (rad > TWO_PI) rad -= TWO_PI;
  return rad;
}

float radInv(float a) {
  return realign(a+PI);
}

float turnRad(float rad1, float rad2, float amount) {
  rad1 = realign(rad1);
  rad2 = realign(rad2);
  int dir = sign(rad2-rad1);
  if(dir == 1 & radInv(rad1) < rad2)
    return radInv(turnRad(radInv(rad1), radInv(rad2), amount));   
  else if(dir == -1 & radInv(rad1) > rad2)
    return radInv(turnRad(radInv(rad1), radInv(rad2), amount));
  return realign(rad1+(rad2-rad1)*amount);
}

int sign(float what) {
  if(what < 0) return -1;
  return 1;
}

class Vertex {
  private Point2D.Float loc;
  private float dx;
  private float dy;
  Connection[] connectors;
  private color c;
  private Vertex previous;
  private boolean alive = true;
  private float[] newXs;
  private float[] newYs;
  private int updCounter;
  private boolean anchor = false;
  private float grav;

  Vertex(Point2D.Float loc) {
    this.loc = new Point2D.Float(loc.x, loc.y);
    dx = 0;
    dy = 0;
    grav = 0;
    connectors = new Connection[0];
    newXs = new float[0];
    newYs = new float[0];
    grav = 0;
    //resetAvg();
    clrData();
    createPrevious();
  }

  Vertex(float x, float y) {
    this(new Point2D.Float(x, y));
  }

  Vertex() {
  }

  private void createPrevious() {
    previous = new Vertex();
    previous.loc = new Point2D.Float(loc.x, loc.y);
    previous.c = c;
  }

  Point2D.Float getLoc() {
    return new Point2D.Float(getX(), getY());
  }

  float getX() {
    return previous.loc.x;
  }

  float getY() {
    return previous.loc.y;
  }

  void setLocAbsolute(float x, float y) {
    loc.setLocation(x, y);
    //    resetAvg();
    clrData();
    update();
    //    update();
  }

  void setLocAbsolute(Point2D.Float which) {
    setLocAbsolute(which.x, which.y);
  }

  void setLoc(float x, float y) {
    addCounter(x, y);
  }

  void setLoc(Point2D.Float which) {
    setLoc(which.x, which.y);
  }

  color getColor() {
    return c;
  }

  void setColor(color c) {
    this.c = c;
  }

  void addCounter(float x, float y) {
    updCounter++;
    if(updCounter > newXs.length) {
      newXs = append(newXs, x);
      newYs = append(newYs, y);
    }
    else {
      newXs[updCounter-1] = x;
      newYs[updCounter-1] = y;
    }
  }

  void clrData() {
    updCounter = 0;
  }

  void resetAvg() {
    clrData();
    addCounter(loc.x, loc.y);
  }

  void resetGrav() {
    grav = 0;
  }

  void resetAllMovement() {
    resetGrav();
    resetMomentum();
    resetAvg();
  }

  void resetMomentum() {
    dx = 0;
    dy = 0;
  }

  void update() {
    bx = dx;
    by = dy;
    if(!anchor) {
      if(updCounter > 0) {
        bx += median(newXs, updCounter)-loc.x;
        by += median(newYs, updCounter)-loc.y;
      }
      if(applyMomentum & wallSouth & loc.y+10+by+gravity < height) by += gravity;
      loc.setLocation(bx+loc.x, by+loc.y);
      if(applyMomentum) {
        dx = bx*drag;
        dy = by*drag;
      }
      else {
        dx = 0;
        dy = 0;
      }
    }
    if(wallSouth & loc.y+10 > height) {
      dy *= -wallRebound;
      loc.setLocation(loc.x, height-10);
    }
    else if(wallNorth & loc.y-10 < 0) {
      dy *= -wallRebound;
      loc.setLocation(loc.x, 10);
    }

    if(wallEast & loc.x+10 > width) {
      dx *= -wallRebound;
      loc.setLocation(width-10, loc.y);
    }
    else if(wallWest & loc.x-10 < 0) {
      dx *= -wallRebound;
      loc.setLocation(10, loc.y);
    }
    //    resetAvg();
    clrData();
    previous.loc.setLocation(loc.x, loc.y);
    show();
  }

  void show() {
    if(showVertices) {
      if(grabbed == this) {
        fill(255);
        ellipse(loc.x, loc.y, 20, 20);
      }
      else if(whichConnect == this) {
        fill(0);
        ellipse(loc.x, loc.y, 20, 20);
      }
      fill(c, 85);
      ellipse(loc.x, loc.y, 20, 20);
      if(anchor) {
        fill(0);
        ellipse(loc.x, loc.y, 5, 5);
      }
    }
  }

  Connection[] getAllConnections() {
    return connectors;
  }

  Connection connectionTo(Vertex which) {
    int a;
    if(which == null | which == this | !alive) return null;
    for(a = 0; a < connectors.length; a++) {
      tempCon = connectors[a];
      if(tempCon.connected(which))
        return tempCon;
    }
    for(a = 0; a < which.connectors.length; a++) {
      tempCon = which.connectors[a];
      if(tempCon.connected(this))
        return tempCon;
    }
    return null;
  }

  Connection connectTo(Vertex which, float length, int str) {
    if(which == null | which == this) return null;
    tempCon = connectionTo(which);
    if(tempCon != null) {
      tempCon.str++;
      return tempCon;
    }
    tempCon = new Connection(this, which, length, str);
    connectors = (Connection[])append(connectors, tempCon);
    return tempCon;
  }

  Connection connectTo(Vertex which) {
    return connectTo(which, (float)loc.distance(which.loc), 1);
  }

  boolean unConnect(Vertex which) {
    tempCon = connectionTo(which);
    if(tempCon == null) return false;
    for(int index = 0; index < connectors.length; index++) {
      if(connectors[index] == tempCon) {
        if(index == 0) connectors = (Connection[])subset(connectors, 1, connectors.length-1);
        else if(index == connectors.length-1) connectors = (Connection[])subset(connectors, 0, connectors.length-1);
        else connectors = (Connection[])concat(subset(connectors, 0, index), subset(connectors, index+1, connectors.length-index-1));
        tempCon.kill();
        return true;
      }
    }
    return false;
  }

  Point2D.Float locSetAs(Point2D.Float which) {
    which.setLocation(getX(), getY());
    return which;
  }

  void showConnections() {
    for(int a = 0; a < connectors.length; a++) 
      connectors[a].show();
  }

  void tugAll() {
    //    println(connectors.length+" connections!");
    for(int a = 0; a < connectors.length; a++)
      connectors[a].tug();
  }

  void kill() {
    loc = null;
    connectors = null;
    previous = null;
    newXs = null;
    newYs = null;
    alive = false;
    try{
      finalize();
    }
    catch(Throwable e) {
      println(e);
    }
  }
}


class Connection {

  Vertex a;
  Vertex b;
  float length;
  float distance;
  int str;
  int lastsig;
  Point2D.Float aloc;
  Point2D.Float bloc;
  float ang;
  float r;

  Connection(Vertex a, Vertex b, float length, int str) {
    this.a = a;
    this.b = b;
    this.length = length;
    this.str = str;
    aloc = a.getLoc();
    bloc = b.getLoc();
    ang = realign(radTo(aloc, bloc));
    r = ang;
  }

  void updLocs() {
    a.locSetAs(aloc);
    b.locSetAs(bloc);
    distance = (float)aloc.distance(bloc);
    r = realign(radTo(aloc, bloc));
    ax = cos(r);
    ay = sin(r);
  }

  void show() {
    updLocs();
    stroke(bg/3, 200*(float)str/((float)str+5.0));
    line(a.loc.x, a.loc.y, b.loc.x, b.loc.y);
    /*    fill(255);
     ellipse(aloc.x+ax*distance/2, aloc.y+ay*distance/2, 5, 5);*/
  }

  boolean connected(Vertex which) {
    if(which == a | which == b)
      return true;
    return false;
  }

  Vertex getOtherVertex(Vertex which) {
    if(which == a) return b;
    else if(which == b) return a;
    return null;
  }

  void kill() {
    a = null;
    b = null;
    aloc = null;
    bloc = null;
    try{
      finalize();
    }
    catch(Throwable e) {
      println(e);
    }
  }

  void tug() {
    if(!a.alive | !b.alive) {
      killConnection(a, b);
    }
    else {
      updLocs();
      //      r = turnRad(r, ang, .05);
      if( !rubberbandLike | (rubberbandLike & distance > length)) {
        float tugStr = distance-length;
        if(rigidity*str < 1)
          tugStr *= rigidity*str;
        ax *= tugStr;
        ay *= tugStr;
        a.setLoc(aloc.x+ax, aloc.y+ay);
        b.setLoc(bloc.x-ax, bloc.y-ay);
      }
    }
  }
}
