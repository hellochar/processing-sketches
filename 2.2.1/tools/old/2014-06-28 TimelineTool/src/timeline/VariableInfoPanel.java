package timeline;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import timeline.tool.TimelineTool;
import timeline.tool.TimelineVariable;

/**
 * This panel is shown on the left of every variable track.  It contains the
 * name of the timeline variable, as well as buttons for deleting and renaming
 * the variable.
 */
public class VariableInfoPanel extends JPanel {
    public final static int PANEL_WIDTH = 88;
    public final static int PANEL_HEIGHT = 200;


    JLabel variableNameLabel;
    JButton deleteButton;
    JButton renameButton;
    TimelineVariable timelineVariable;
    TimelineTool timelineTool;

    public VariableInfoPanel(TimelineVariable timelineVariable, TimelineTool timelineTool) {
        this.timelineVariable = timelineVariable;
        this.timelineTool = timelineTool;
        
        setBorder(new EmptyBorder(4, 4, 4, 4));

        variableNameLabel = new JLabel(timelineVariable.name);
        variableNameLabel.setHorizontalAlignment(JLabel.LEFT);

        setOpaque(true);
        setBackground(new Color(200, 200, 200));
        
        setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
        setAlignmentX(TOP_ALIGNMENT);
        add(variableNameLabel);

        renameButton = new JButton("Rename");
        renameButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                rename();
            }
        });

        deleteButton = new JButton("Delete");
        deleteButton.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent e) {
                deleteVariable();
               
            }
        });

        Box buttonBox = Box.createHorizontalBox();
        Dimension buttonSize = renameButton.getPreferredSize();
        deleteButton.setPreferredSize(buttonSize);
        deleteButton.setMaximumSize(buttonSize);
        deleteButton.setMinimumSize(buttonSize);
        add(Box.createVerticalStrut(3));
        add(renameButton);
        add(Box.createVerticalStrut(3));
        add(deleteButton);
        add(Box.createVerticalGlue());
    }

    public void rename() {
        String newName = (String)JOptionPane.showInputDialog(timelineTool.frame,
                            "Enter a new name for this variable:",
                            "Rename Variable",
                            JOptionPane.PLAIN_MESSAGE,
                            null,
                            null,
                            "");

        if (newName != null) {
            timelineVariable.rename(newName);
            variableNameLabel.setText(timelineVariable.name);
            repaint();
        }

    }

    public void deleteVariable() {
         timelineTool.deleteVariable(timelineVariable);
    }

    public Dimension getPreferredSize() {
        return new Dimension(PANEL_WIDTH, PANEL_HEIGHT);
    }

    public Dimension getMaximumSize() {
        return getPreferredSize();
    }

    public Dimension getMinimumSize() {
        return getPreferredSize();
    }
}
