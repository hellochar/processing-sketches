package timeline.tool;

import java.io.FileNotFoundException;
import processing.app.*;

import java.awt.*;
import java.awt.event.*;
import java.io.File;
import java.util.Hashtable;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.event.*;
import processing.app.Editor;
import processing.app.tools.Tool;
import timeline.TimelineImporter;
import timeline.VariableInfoPanel;

/**
 * This is the actual PDE plugin, based on code from the color picker tool.
 * Handles most of the awt/swing UI madness
 */
public class TimelineTool implements Tool, KeyListener {
    Editor editor;
    public JFrame frame;
    TimelineApplet timelineApplet;
    JButton saveButton;
    JSlider zoomSlider;
    TimelineApplet timelineApplet2;
    Box modeBox;
    Box box;
    JPanel controlPanel;
    JPanel timelineVarsPanel;
    JPanel var1;
    JPanel var2;
    Timeline timeline;
    ScrollPane scrollPane;
    int counter = 0;
    JPanel rulerPanel;

    JButton drawModeButton;
    JButton selectModeButton;
    JButton tangentModeButton;

    static final int ZOOM_MIN = 0;
    static final int ZOOM_MAX = 10;
    static final int ZOOM_INIT = 5;

    public void init(Editor editor) {
        this.editor = editor;
        
        timelineVarsPanel = new JPanel();
        timelineVarsPanel.setLayout(new BoxLayout(timelineVarsPanel, BoxLayout.Y_AXIS));
        timelineVarsPanel.setAlignmentY(0);
        timelineVarsPanel.setAlignmentX(0);

        frame = new JFrame("Timeline");
        frame.getContentPane().setLayout(new BoxLayout(frame.getContentPane(), BoxLayout.Y_AXIS));

        controlPanel = new JPanel();
        controlPanel.setLayout(new BoxLayout(controlPanel, BoxLayout.LINE_AXIS));


        box = Box.createVerticalBox();
        box.setBorder(new EmptyBorder(12, 12, 12, 12));

        timeline = new Timeline();

        
        drawModeButton = new JButton("Draw points");
        drawModeButton.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent e) {
                drawModeButtonPressed();
            }
        });
        
        selectModeButton = new JButton("Move points");
        selectModeButton.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent e) {
                selectModeButtonPressed();
            }
        });

        tangentModeButton = new JButton("Create tangents");
        tangentModeButton.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent e) {
                tangentModeButtonPressed();
            }
        });
        
        modeBox = Box.createHorizontalBox();
        modeBox.setBorder(new EmptyBorder(4, 4, 4, 4));
        modeBox.setBorder(new CompoundBorder(new MatteBorder(0, 0, 1, 0, new Color(125, 125, 125)), new EmptyBorder(4, 4, 4, 4)));
        modeBox.add(drawModeButton);
        modeBox.add(Box.createHorizontalStrut(6));
        modeBox.add(selectModeButton);
        modeBox.add(Box.createHorizontalStrut(6));
        modeBox.add(tangentModeButton);
        modeBox.add(Box.createHorizontalGlue());

        drawModeButtonPressed();

        zoomSlider = new JSlider(JSlider.HORIZONTAL, ZOOM_MIN, ZOOM_MAX, ZOOM_INIT);
        zoomSlider.setSnapToTicks(true);
        zoomSlider.setMinorTickSpacing(1);
        zoomSlider.setMajorTickSpacing(ZOOM_INIT);
        zoomSlider.setPaintTicks(true);
        zoomSlider.setPaintLabels(true);

        Hashtable labelTable = new Hashtable();
        labelTable.put(ZOOM_MIN, new JLabel("-"));
        labelTable.put(ZOOM_INIT, new JLabel("Zoom"));
        labelTable.put(ZOOM_MAX, new JLabel("+"));

        zoomSlider.setLabelTable(labelTable);
        zoomSlider.addChangeListener(new ChangeListener() {
                public void stateChanged(ChangeEvent e) {
                    int zoomLevel = zoomSlider.getValue();
                    timeline.setXZoom((float) Math.pow(1.5, zoomLevel - ZOOM_INIT));

                }
        });
        zoomSlider.setMaximumSize(new Dimension(300, 200));
        zoomSlider.setMinimumSize(new Dimension(300, zoomSlider.getWidth()));

        saveButton = new JButton("Save");

        final Editor theEditor = editor;
        saveButton.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                    try {
                        timeline.export(theEditor.getSketch().getFolder().toString() + "/timeline-data.txt");
                    } catch (FileNotFoundException ex) {
                        System.out.println("Error: Export failed");
                    }
                }
            });

        JButton loadButton = new JButton("Load");
        loadButton.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                    loadFile();
                }
            });



            JButton addButton = new JButton("Add");
        addButton.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                    addButtonPressed();
                }
            });

        controlPanel.setBorder(new EmptyBorder(2, 6, 2, 6));
        controlPanel.add(Box.createHorizontalStrut(16));
        controlPanel.add(addButton);
        controlPanel.add(Box.createHorizontalStrut(120));
        controlPanel.add(zoomSlider);
        controlPanel.add(Box.createGlue());
        controlPanel.add(saveButton);
        controlPanel.add(Box.createHorizontalStrut(5));
        controlPanel.add(loadButton);
        controlPanel.add(Box.createHorizontalStrut(5));

        box.add(Box.createVerticalStrut(8));

        scrollPane = new ScrollPane(ScrollPane.SCROLLBARS_ALWAYS);
        timelineVarsPanel.setBorder(new EmptyBorder(0, 0, 0, 0));
        scrollPane.add(timelineVarsPanel);
        scrollPane.setSize(800 + scrollPane.getVScrollbarWidth(), 600);

        timeline.ruler.init();

        rulerPanel = new JPanel();
        rulerPanel.setLayout(new BoxLayout(rulerPanel, BoxLayout.X_AXIS));
        setupRuler();

        frame.getContentPane().add(modeBox);
        frame.getContentPane().add(rulerPanel);
        frame.getContentPane().add(scrollPane);
        frame.getContentPane().add(controlPanel);


        frame.pack();
        frame.setResizable(false);

        Dimension size = frame.getSize();
        Dimension screen = Toolkit.getDefaultToolkit().getScreenSize();
        frame.setLocation((screen.width - size.width) / 2,
                          (screen.height - size.height) / 2);

        frame.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
        frame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
              frame.setVisible(false);
            }
          });
        Base.registerWindowCloseKeys(frame.getRootPane(), new ActionListener() {
            public void actionPerformed(ActionEvent actionEvent) {
              frame.setVisible(false);
            }
          });
        Base.setIcon(frame);
    }

    public void deleteVariable(TimelineVariable timelineVariable) {
        timeline.removeTimelineVariable(timelineVariable);
        timelineVarsPanel.removeAll();
        timelineVarsPanel.validate();
        buildTimelineVarsPanel();

        // TODO: not all of this is necessary, figure out what is
        timelineVarsPanel.repaint();
        frame.validate();
        scrollPane.validate();
        scrollPane.repaint();
        frame.repaint();
  }

    public String getMenuTitle() {
        return "Timeline";
    }

    public void drawModeButtonPressed() {
        drawModeButton.setSelected(true);
        selectModeButton.setSelected(false);
        tangentModeButton.setSelected(false);
        timeline.setMode(Timeline.Mode.DRAW);
    }

    public void selectModeButtonPressed() {
        drawModeButton.setSelected(false);
        selectModeButton.setSelected(true);
        tangentModeButton.setSelected(false);
        timeline.setMode(Timeline.Mode.SELECT);
    }

    public void tangentModeButtonPressed() {
        drawModeButton.setSelected(false);
        selectModeButton.setSelected(false);
        tangentModeButton.setSelected(true);
        timeline.setMode(Timeline.Mode.TANGENT);
    }

    public void addButtonPressed() {
        int varNameCounter = 0;

        while (timeline.nameExists("var" + varNameCounter)) {
            varNameCounter++;
        }

        TimelineVariable timelineVar = new TimelineVariable(timeline, "var" + varNameCounter);

        timeline.addNewVariable(timelineVar);

        Box timelineBox = Box.createHorizontalBox();
        timelineBox.add(new VariableInfoPanel(timelineVar, this));
        timelineBox.add(timelineVar.getApplet());
        timelineBox.setBorder(new MatteBorder(0, 0, 3, 0, new Color(125, 125, 125)));
        timelineVarsPanel.add(timelineBox);
        timelineVar.getApplet().init();
        scrollPane.validate();
        frame.repaint();
    }

    public void loadFile() {
        String pathName = editor.getSketch().getFolder().toString() + "/timeline-data.txt";
        File f = new File(pathName);

        if (!f.exists()) {
            return;
        }
        timelineVarsPanel.removeAll();
        
        timeline = TimelineImporter.importTimeline(pathName);

        rulerPanel.removeAll();
        timeline.ruler.init();
        setupRuler();


        // initialize all of the applets that we just created
        for (TimelineVariable timelineVariable : timeline.getTimelineVariables()) {
            timelineVariable.getApplet().init();
            timelineVariable.spline.createDraggables();
            timelineVariable.spline.autoAdjustYAxis();
        }

        buildTimelineVarsPanel();

        zoomSlider.setValue(ZOOM_INIT);

        // TODO: not all of this is necessary, figure out what is
        timelineVarsPanel.repaint();
        frame.validate();
        scrollPane.validate();
        scrollPane.repaint();
        frame.repaint();
    }

    public void buildTimelineVarsPanel() {
        for (TimelineVariable timelineVar : timeline.getTimelineVariables()) {
            Box timelineBox = Box.createHorizontalBox();
            timelineBox.add(new VariableInfoPanel(timelineVar, this));
            timelineBox.add(timelineVar.getApplet());
            timelineBox.setBorder(new MatteBorder(0, 0, 3, 0, new Color(125, 125, 125)));
            timelineVarsPanel.add(timelineBox);
        }

        scrollPane.validate();
        frame.repaint();
    }

    public void setupRuler() {
        final int RULER_PANEL_STRUT = TimelineApplet.RULER_THICKNESS + VariableInfoPanel.PANEL_WIDTH - Ruler.NAV_BUTTON_WIDTH;

        // See nasty hack notice in run() for an explanation about ScrollPanel's
        // border
        String whichOS = System.getProperty("os.name");
        if (whichOS.contains("Mac")) {
            rulerPanel.add(Box.createHorizontalStrut(RULER_PANEL_STRUT));
        } else { // Grrr Windows and your 2 pixel border
            rulerPanel.add(Box.createHorizontalStrut(RULER_PANEL_STRUT + 1));
        }
        rulerPanel.add(timeline.ruler);
        rulerPanel.add(Box.createHorizontalGlue());
    }

    public void run() {
        // we don't know the VScrollBarWidth until we get here
        loadFile(); // let's load the file if it exists, so it's ready to go
                    // when the user first opens the timeline in a new session

        // this is nasty, I'd prefer not to do this if possible...
        // the ScrollPane has a 2 pixel border on Windows, and a 1 pixel border
        // on Mac, and apparently no way to change either.  That's where this
        // special case comes into play.  Still need to test on some Linuxes.
        String whichOS = System.getProperty("os.name");
        if (whichOS.contains("Mac")) {
            scrollPane.setSize(800 + scrollPane.getVScrollbarWidth() + 2 + VariableInfoPanel.PANEL_WIDTH, 600);
        } else {
            scrollPane.setSize(800 + scrollPane.getVScrollbarWidth() + 4 + VariableInfoPanel.PANEL_WIDTH, 600);
        }
        frame.pack();
        frame.repaint();
        frame.setVisible(true);
    }

    // TODO: use key listening to switch modes via shortcuts
    public void keyTyped(KeyEvent e) {
    }

    public void keyPressed(KeyEvent e) {
        if (e.getID() == KeyEvent.KEY_TYPED) {
            if (e.getKeyChar() == 's') {
                selectModeButtonPressed();
            } else if (e.getKeyChar() == 'd') {
                drawModeButtonPressed();
            }
        }
    }

    public void keyReleased(KeyEvent e) {
    }
}
