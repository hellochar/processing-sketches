import java.awt.event.*;
import java.beans.*;
import javax.swing.*;
import java.awt.*;

final int fieldwidth = 400;
final int fieldheight = 400;

int framerate = 60;

final color blue = color(0, 0, 255);
final color red = color(255, 0, 0);
final color green = color(0, 255, 0);
final color black = color(-16776961);


final int SPAWN_LINE = 1;
final int SPAWN_INTERVAL = 2;
final int SPAWN_RANDOM = 3;

final int BLUE_MOVE_X_SET = 10;
final int BLUE_MOVE_X_RANDOM = 11;
final int BLUE_MOVE_Y_SET = 15;
final int BLUE_MOVE_Y_RANDOM = 16;

final int RED_MOVE_X_SET = 20;
final int RED_MOVE_X_RANDOM = 22;
final int RED_MOVE_Y_SET = 25;
final int RED_MOVE_Y_RANDOM = 26;


int spawnType = SPAWN_LINE;


int startOffset = 40;
int SPAWN_INTERVALS_NUM = 1;


int BLUE_COLOR = blue;
int RED_COLOR = red;


int BLUE_NUMBER = 9000;
int RED_NUMBER = 9000;


int TOTAL;


int BLUE_MOVE_X = 3;
int BLUE_MOVE_Y = -7;

int RED_MOVE_X = 3;
int RED_MOVE_Y = 7;


int BLUE_AVOID_RATE = 7;
int RED_AVOID_RATE = 7;


int BLUE_PARTNER_REQ = 0;
int RED_PARTNER_REQ = 0;


int BLUE_PARTNERED_MOVE_RATE = 0;
int RED_PARTNERED_MOVE_RATE = 0;


int BLUE_LOWBOUND_X = -1;
int BLUE_HIGHBOUND_X = 1;
int BLUE_LOWBOUND_Y = -1;
int BLUE_HIGHBOUND_Y = 1;

int RED_LOWBOUND_X = -1;
int RED_HIGHBOUND_X = 1;
int RED_LOWBOUND_Y = -1;
int RED_HIGHBOUND_Y = 1;


int blueMoveXType = BLUE_MOVE_X_RANDOM;
int blueMoveYType = BLUE_MOVE_Y_SET;


int redMoveXType = RED_MOVE_X_RANDOM;
int redMoveYType = RED_MOVE_Y_SET;


class makeGUI extends JPanel implements ActionListener, PropertyChangeListener {
  final String resetButtonString = "Restart";
  final String playButtonString = "Play";
  final String pauseButtonString = "Pause";
  final String framerateTextFieldLabelString = "Framerate";
  final String spawnLineButtonString = "Spawn line at ";
  final String spawnRandomButtonString = "Spawn random";
  final String spawnIntervalButtonString = "Spawn at intervals";

  final String blueLabelString = "Blue";
  final String spawnBlueTextFieldLabelString = "Particles ";
  final String blueMoveXTextFieldLabelString = "X movement ";
  final String blueMoveYTextFieldLabelString = "Y movement ";
  final String blueMoveXRandomButtonString = "Random X movement ";
  final String blueMoveXSetButtonString = "Set X movement ";
  final String blueMoveYRandomButtonString = "Random Y movement ";
  final String blueMoveYSetButtonString = "Set Y Movement ";
  final String blueAvoidRateTextFieldLabelString = "Avoid rate ";
  final String bluePartnerReqTextFieldLabelString = "Partner requirement ";
  final String bluePartneredMoveRateTextFieldLabelString = "Partnered move rate ";


  final String redLabelString = "Red";
  final String spawnRedTextFieldLabelString = "Particles";
  final String redMoveXTextFieldLabelString = "X movement";
  final String redMoveYTextFieldLabelString = "Y movement";
  final String redMoveXRandomButtonString = "Random X movement";
  final String redMoveXSetButtonString = "Set X movement";
  final String redMoveYRandomButtonString = "Random Y movement";
  final String redMoveYSetButtonString = "Set Y Movement";
  final String redAvoidRateTextFieldLabelString = "Avoid rate ";
  final String redPartnerReqTextFieldLabelString = "Partner requirement ";
  final String redPartneredMoveRateTextFieldLabelString = "Partnered move rate ";


  NumberFormat generalNumberFormat;

  JButton resetButton = new JButton("Reset");
  JButton playPauseButton = new JButton("Play/Pause");

  JFormattedTextField framerateTextField = new JFormattedTextField(generalNumberFormat);
  JLabel framerateTextFieldLabel = new JLabel(framerateTextFieldLabelString);

  JRadioButton spawnLineButton = new JRadioButton(spawnLineButtonString);
  JRadioButton spawnRandomButton = new JRadioButton(spawnRandomButtonString);
  JRadioButton spawnIntervalButton = new JRadioButton(spawnIntervalButtonString);
  JFormattedTextField spawnLineTextField = new JFormattedTextField(generalNumberFormat);
  JFormattedTextField spawnIntervalTextField = new JFormattedTextField(generalNumberFormat);
  ButtonGroup spawnButtonGroup = new ButtonGroup();

  //---------------------------BLUE-------------------------


  JLabel blueLabel = new JLabel(blueLabelString);
  //Number to spawn
  JLabel spawnBlueTextFieldLabel = new JLabel(spawnBlueTextFieldLabelString);
  JFormattedTextField spawnBlueTextField = new JFormattedTextField(generalNumberFormat);

  //X movement speed
  JLabel blueMoveXTextFieldLabel = new JLabel(blueMoveXTextFieldLabelString);
  JFormattedTextField blueMoveXTextField = new JFormattedTextField(generalNumberFormat);

  //X movement type
  JRadioButton blueMoveXRandomButton = new JRadioButton(blueMoveXRandomButtonString);
  JRadioButton blueMoveXSetButton = new JRadioButton(blueMoveXSetButtonString);
  ButtonGroup blueMoveXButtonGroup = new ButtonGroup();

  //Y movement speed
  JLabel blueMoveYTextFieldLabel = new JLabel(blueMoveYTextFieldLabelString);
  JFormattedTextField blueMoveYTextField = new JFormattedTextField(generalNumberFormat);

  //Y movement type
  JRadioButton blueMoveYRandomButton = new JRadioButton(blueMoveYRandomButtonString);
  JRadioButton blueMoveYSetButton = new JRadioButton(blueMoveYSetButtonString);
  ButtonGroup blueMoveYButtonGroup = new ButtonGroup();

  //Avoid rate
  JLabel blueAvoidRateTextFieldLabel = new JLabel(blueAvoidRateTextFieldLabelString);
  JFormattedTextField blueAvoidRateTextField = new JFormattedTextField(generalNumberFormat);

  //Nopartner req
  JLabel bluePartnerReqTextFieldLabel = new JLabel(bluePartnerReqTextFieldLabelString);
  JFormattedTextField bluePartnerReqTextField = new JFormattedTextField(generalNumberFormat);

  //Partnered move rate
  JLabel bluePartneredMoveRateTextFieldLabel = new JLabel(bluePartneredMoveRateTextFieldLabelString);
  JFormattedTextField bluePartneredMoveRateTextField = new JFormattedTextField(generalNumberFormat);


  //---------------------------RED--------------------------


  JLabel redLabel = new JLabel(redLabelString);
  //Number to spawn
  JLabel spawnRedTextFieldLabel = new JLabel(spawnRedTextFieldLabelString);
  JFormattedTextField spawnRedTextField = new JFormattedTextField(generalNumberFormat);

  //X movement speed
  JLabel redMoveXTextFieldLabel = new JLabel(redMoveXTextFieldLabelString);
  JFormattedTextField redMoveXTextField = new JFormattedTextField(generalNumberFormat);

  //X movement type
  JRadioButton redMoveXRandomButton = new JRadioButton(redMoveXRandomButtonString);
  JRadioButton redMoveXSetButton = new JRadioButton(redMoveXSetButtonString);
  ButtonGroup redMoveXButtonGroup = new ButtonGroup();

  //Y movement speed
  JLabel redMoveYTextFieldLabel = new JLabel(redMoveYTextFieldLabelString);
  JFormattedTextField redMoveYTextField = new JFormattedTextField(generalNumberFormat);

  //Y movement type
  JRadioButton redMoveYRandomButton = new JRadioButton(redMoveYRandomButtonString);
  JRadioButton redMoveYSetButton = new JRadioButton(redMoveYSetButtonString);
  ButtonGroup redMoveYButtonGroup = new ButtonGroup();

  //Avoid rate
  JLabel redAvoidRateTextFieldLabel = new JLabel(redAvoidRateTextFieldLabelString);
  JFormattedTextField redAvoidRateTextField = new JFormattedTextField(generalNumberFormat);

  //Nopartner req
  JLabel redPartnerReqTextFieldLabel = new JLabel(redPartnerReqTextFieldLabelString);
  JFormattedTextField redPartnerReqTextField = new JFormattedTextField(generalNumberFormat);

  //Partnered move rate
  JLabel redPartneredMoveRateTextFieldLabel = new JLabel(redPartneredMoveRateTextFieldLabelString);
  JFormattedTextField redPartneredMoveRateTextField = new JFormattedTextField(generalNumberFormat);




  void addEmptySpace() {
    add(new JLabel());
  }


  makeGUI() {
    super(new GridLayout(25, 5));
    resetButton.setActionCommand(resetButtonString);
    resetButton.addActionListener(this);
    playPauseButton.setActionCommand(pauseButtonString);
    playPauseButton.addActionListener(this);

    framerateTextField.setValue(new Integer(framerate));
    framerateTextField.addPropertyChangeListener("value", this);

    spawnLineTextField.setValue(new Integer(startOffset));
    spawnLineTextField.addPropertyChangeListener("value", this);
    spawnIntervalTextField.setValue(new Integer(SPAWN_INTERVALS_NUM));
    spawnIntervalTextField.addPropertyChangeListener("value", this);

    //Mode to spawn - line, random, or interval
    spawnLineButton.setActionCommand(spawnLineButtonString);
    spawnRandomButton.setActionCommand(spawnRandomButtonString);
    spawnIntervalButton.setActionCommand(spawnIntervalButtonString);
    spawnLineButton.addActionListener(this);
    spawnRandomButton.addActionListener(this);
    spawnIntervalButton.addActionListener(this);
    spawnButtonGroup.add(spawnLineButton);
    spawnButtonGroup.add(spawnRandomButton);
    spawnButtonGroup.add(spawnIntervalButton);
    spawnIntervalButton.setSelected(true);

    //---------------------------BLUE-------------------------

    //Number to spawn
    spawnBlueTextFieldLabel.setLabelFor(spawnBlueTextField);
    spawnBlueTextField.setValue(new Integer(BLUE_NUMBER));
    spawnBlueTextField.addPropertyChangeListener("value", this);

    //X movement speed
    blueMoveXTextField.setValue(new Integer(BLUE_MOVE_X));
    blueMoveXTextField.addPropertyChangeListener("value", this);
    //X movement type
    blueMoveXRandomButton.setActionCommand(blueMoveXRandomButtonString);
    blueMoveXRandomButton.addActionListener(this);
    blueMoveXButtonGroup.add(blueMoveXRandomButton);
    blueMoveXSetButton.setActionCommand(blueMoveXSetButtonString);
    blueMoveXSetButton.addActionListener(this);
    blueMoveXButtonGroup.add(blueMoveXSetButton);
    blueMoveXRandomButton.setSelected(true);
    //Y movement speed
    blueMoveYTextField.setValue(new Integer(BLUE_MOVE_Y));
    blueMoveYTextField.addPropertyChangeListener("value", this);
    //Y movement type
    blueMoveYRandomButton.setActionCommand(blueMoveYRandomButtonString);
    blueMoveYRandomButton.addActionListener(this);
    blueMoveYButtonGroup.add(blueMoveYRandomButton);
    blueMoveYSetButton.setActionCommand(blueMoveYSetButtonString);
    blueMoveYSetButton.addActionListener(this);
    blueMoveYButtonGroup.add(blueMoveYSetButton);
    blueMoveYSetButton.setSelected(true);

    //Avoid rate
    blueAvoidRateTextField.setValue(new Integer(BLUE_AVOID_RATE));
    blueAvoidRateTextField.addPropertyChangeListener("value", this);  
    //Nopartner req
    bluePartnerReqTextField.setValue(new Integer(BLUE_PARTNER_REQ));
    bluePartnerReqTextField.addPropertyChangeListener("value", this);
    //Partnered move rate
    bluePartneredMoveRateTextField.setValue(new Integer(BLUE_PARTNERED_MOVE_RATE));
    bluePartneredMoveRateTextField.addPropertyChangeListener("value", this);




    //---------------------------RED--------------------------


    //Number to spawn
    spawnRedTextFieldLabel.setLabelFor(spawnRedTextField);
    spawnRedTextField.setValue(new Integer(RED_NUMBER));
    spawnRedTextField.addPropertyChangeListener("value", this);

    //X movement speed
    redMoveXTextField.setValue(new Integer(RED_MOVE_X));
    redMoveXTextField.addPropertyChangeListener("value", this);
    //X movement type
    redMoveXRandomButton.setActionCommand(redMoveXRandomButtonString);
    redMoveXRandomButton.addActionListener(this);
    redMoveXButtonGroup.add(redMoveXRandomButton);
    redMoveXSetButton.setActionCommand(redMoveXSetButtonString);
    redMoveXSetButton.addActionListener(this);
    redMoveXButtonGroup.add(redMoveXSetButton);
    redMoveXRandomButton.setSelected(true);
    //Y movement speed
    redMoveYTextField.setValue(new Integer(RED_MOVE_Y));
    redMoveYTextField.addPropertyChangeListener("value", this);
    //Y movement type
    redMoveYRandomButton.setActionCommand(redMoveYRandomButtonString);
    redMoveYRandomButton.addActionListener(this);
    redMoveYButtonGroup.add(redMoveYRandomButton);
    redMoveYSetButton.setActionCommand(redMoveYSetButtonString);
    redMoveYSetButton.addActionListener(this);
    redMoveYButtonGroup.add(redMoveYSetButton);
    redMoveYSetButton.setSelected(true);

    //Avoid rate
    redAvoidRateTextField.setValue(new Integer(RED_AVOID_RATE));
    redAvoidRateTextField.addPropertyChangeListener("value", this);  
    //Nopartner req
    redPartnerReqTextField.setValue(new Integer(RED_PARTNER_REQ));
    redPartnerReqTextField.addPropertyChangeListener("value", this);
    //Partnered move rate
    redPartneredMoveRateTextField.setValue(new Integer(RED_PARTNERED_MOVE_RATE));
    redPartneredMoveRateTextField.addPropertyChangeListener("value", this);



    add(resetButton);                        
    add(playPauseButton);                  // [    Reset    ]    [play/pause]
    add(framerateTextFieldLabel);            
    add(framerateTextField);               //Framerate           **60********
    add(spawnLineButton);                    
    add(spawnLineTextField);               //spawn line at:      **40********
    add(spawnRandomButton);                  
    addEmptySpace();                       //spawn random                    
    add(spawnIntervalButton);                
    add(spawnIntervalTextField);           //spawn interval at:  **2*********
    add(new JSeparator());                   
    add(new JSeparator());                 //--------------------------------
    add(blueLabel);                          
    addEmptySpace();                       //Blue                            
    add(spawnBlueTextFieldLabel);            
    add(spawnBlueTextField);               //Particles:          **20000*****
    add(blueMoveXTextFieldLabel);            
    add(blueMoveXTextField);               //X movement:         **-8********
    add(blueMoveXRandomButton);              
    add(blueMoveXSetButton);               //Random X move       Set x move
    add(blueMoveYTextFieldLabel);            
    add(blueMoveYTextField);               //Y movement:         **5*********
    add(blueMoveYRandomButton);              
    add(blueMoveYSetButton);               //Random y move       Set y move
    add(blueAvoidRateTextFieldLabel);        
    add(blueAvoidRateTextField);           //Avoid rate          **7*********
    add(bluePartnerReqTextFieldLabel);       
    add(bluePartnerReqTextField);          //Partner req         **0*********
    add(bluePartneredMoveRateTextFieldLabel);
    add(bluePartneredMoveRateTextField);   //Partnered move rate **0*********
    add(new JSeparator());                   
    add(new JSeparator());
    ;
    add(redLabel);                           
    addEmptySpace();                       //Red                            
    add(spawnRedTextFieldLabel);             
    add(spawnRedTextField);                //Particles:          **20000*****
    add(redMoveXTextFieldLabel);             
    add(redMoveXTextField);                //X movement:         **-8********
    add(redMoveXRandomButton);               
    add(redMoveXSetButton);                //Random X move       Set x move
    add(redMoveYTextFieldLabel);             
    add(redMoveYTextField);                //Y movement:         **5*********
    add(redMoveYRandomButton);               
    add(redMoveYSetButton);                //Random y move       Set y move
    add(redAvoidRateTextFieldLabel);        
    add(redAvoidRateTextField);           //Avoid rate          **7*********
    add(redPartnerReqTextFieldLabel);       
    add(redPartnerReqTextField);          //Partner req         **0*********
    add(redPartneredMoveRateTextFieldLabel);
    add(redPartneredMoveRateTextField);   //Partnered move rate **0*********
  }




  public void actionPerformed(ActionEvent e) {
    String action = e.getActionCommand();
    if(action.equals(resetButtonString)) {
      playPauseButton.setActionCommand(pauseButtonString);   
      reset();
    }
    else if(action.equals(pauseButtonString)) {
      pause();
      playPauseButton.setActionCommand(playButtonString);
    }
    else if(action.equals(playButtonString)) {
      play();
      playPauseButton.setActionCommand(pauseButtonString);      
    }
    else if(action.equals(spawnLineButtonString)) {
      spawnType = SPAWN_LINE;
    }
    else if(action.equals(spawnRandomButtonString)) {
      spawnType = SPAWN_RANDOM;
    }
    else if(action.equals(spawnIntervalButtonString)) {
      spawnType = SPAWN_INTERVAL;
    }
    else if(action.equals(blueMoveXRandomButtonString)) { 
      blueMoveXType = BLUE_MOVE_X_RANDOM;
    }
    else if(action.equals(blueMoveXSetButtonString)) { 
      blueMoveXType = BLUE_MOVE_X_SET;
    }
    else if(action.equals(blueMoveYRandomButtonString)) { 
      blueMoveYType = BLUE_MOVE_Y_RANDOM;
    }
    else if(action.equals(blueMoveYSetButtonString)) { 
      blueMoveYType = BLUE_MOVE_Y_SET;
    }
    else if(action.equals(redMoveXRandomButtonString)) { 
      redMoveXType = RED_MOVE_X_RANDOM;
    }
    else if(action.equals(redMoveXSetButtonString)) { 
      redMoveXType = RED_MOVE_X_SET;
    }
    else if(action.equals(redMoveYRandomButtonString)) { 
      redMoveYType = RED_MOVE_Y_RANDOM;
    }
    else if(action.equals(redMoveYSetButtonString)) { 
      redMoveYType = RED_MOVE_Y_SET;
    }
  }

  public void propertyChange(PropertyChangeEvent e) {
    JFormattedTextField source = (JFormattedTextField)e.getSource();
    int val = ((Number)source.getValue()).intValue();
    if(source == framerateTextField) {
      framerate = val;
      frameRate(framerate);
    }
    else if (source == spawnIntervalTextField) {
      SPAWN_INTERVALS_NUM = val;
    }
    else if(source == spawnLineTextField) {
      startOffset = val;
    }
    else if(source == spawnBlueTextField) {
      BLUE_NUMBER = val;
    }
    else if(source == spawnRedTextField) {
      RED_NUMBER = val;
    }
    else if(source == blueMoveXTextField) {
      BLUE_MOVE_X = val;
    }
    else if(source == blueMoveYTextField) {
      BLUE_MOVE_Y = val;
    }
    else if(source == blueAvoidRateTextField) {
      BLUE_AVOID_RATE = val;
    }
    else if(source == bluePartnerReqTextField) {
      BLUE_PARTNER_REQ = val;
    }
    else if(source == bluePartneredMoveRateTextField) {
      BLUE_PARTNERED_MOVE_RATE = val;
    }
    else if(source == redMoveXTextField) {
      RED_MOVE_X = val;
    }
    else if(source == redMoveYTextField) {
      RED_MOVE_Y = val;
    }
    else if(source == redAvoidRateTextField) {
      RED_AVOID_RATE = val;
    }
    else if(source == redPartnerReqTextField) {
      RED_PARTNER_REQ = val;
    }
    else if(source == redPartneredMoveRateTextField) {
      RED_PARTNERED_MOVE_RATE = val;
    }
  }
}

Particle[] dots;
World w = new World();
makeGUI gui = new makeGUI();
JFrame frame = new JFrame("Particle interactions v011");

void setup() 
{
  size(fieldwidth, fieldheight);
  frameRate(60);
  background(0);
  frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  gui.setOpaque(true);
  frame.getContentPane().add(gui);
  frame.pack();
  frame.setVisible(true);
  TOTAL = BLUE_NUMBER+RED_NUMBER;
  dots = new Particle[TOTAL];
  int x = fieldwidth/2;
  int y = fieldheight-startOffset;
  for(int a = 0; a < BLUE_NUMBER; a++) {
    if(spawnType == SPAWN_LINE || spawnType == SPAWN_RANDOM) { 
      x = (int)random(fieldwidth+1);
      if(spawnType == SPAWN_RANDOM) y = (int)random(fieldheight+1);
    }
    else if(spawnType == SPAWN_INTERVAL) x = fieldwidth/(SPAWN_INTERVALS_NUM+1)*(int)(1+random(SPAWN_INTERVALS_NUM));
    dots[a] = new Blue(x, y);
  }
  y = startOffset;
  for(int a = BLUE_NUMBER; a < TOTAL; a ++) {
    if(spawnType == SPAWN_LINE || spawnType == SPAWN_RANDOM) { 
      x = (int)random(fieldwidth+1);
      if(spawnType == SPAWN_RANDOM) y = (int)random(fieldheight+1);
    }
    else if(spawnType == SPAWN_INTERVAL) x = fieldwidth/(SPAWN_INTERVALS_NUM+1)*(int)(1+random(SPAWN_INTERVALS_NUM));
    dots[a] = new Red(x, y);
  }
  play();
}

void draw()
{
  if(mousePressed) {
    if(mouseButton == LEFT) {
      dots = (Particle[])append(dots, new Blue(mouseX, mouseY));
    }
    else if(mouseButton == RIGHT) {
      dots = (Particle[])append(dots, new Red(mouseX, mouseY));    
    }
  }
  for(int a = 0; a < dots.length; a++)
    dots[a].run();
  /*dots = (Particle[])expand(dots, dots.length+2);
   dots[dots.length-2] = new Blue((int)random(250), 220);
   dots[dots.length-1] = new Red((int)random(250), 30);*/
}


void keyPressed() {
  if(keyCode == LEFT | keyCode == RIGHT) {
    for(int a = 0; a < dots.length; a++) {
      dots[a].offset(fieldwidth/2, 0);
    }
  }
  else if(keyCode == UP | keyCode == DOWN) {
    for(int a = 0; a < dots.length; a++) {
      dots[a].offset(0, fieldheight/2);
    }
  }
  else if(key == '-') {
    dots[dots.length-1].kill();
    dots = (Particle[])shorten(dots);
  }
}

int bounds(int num, int low, int high) {
  return num < low ? low : num > high ? high : num; 
}


void reset() {
  noLoop();
  setup();
}

void play() {
  loop();
}

void pause() {
  noLoop();
}

//  The World class simply provides two functions, get and set, which access the
//  display in the same way as getPixel and setPixel.  The only difference is that
//  the World class's get and set do screen wraparound ("toroidal coordinates").
class World
{
  void setpix(int x, int y, int c) {
    while(x < 0) x += fieldwidth;
    while(x > fieldwidth - 1) x -= fieldwidth;
    while(y < 0) y += fieldheight;
    while(y > fieldheight - 1) y -= fieldheight;
    set(x, y, c);
  }

  color getpix(int x, int y) {
    while(x < 0) x += fieldwidth;
    while(x > fieldwidth - 1) x -= fieldwidth;
    while(y < 0) y += fieldheight;
    while(y > fieldheight - 1) y -= fieldheight;
    return get(x, y);
  }
}
