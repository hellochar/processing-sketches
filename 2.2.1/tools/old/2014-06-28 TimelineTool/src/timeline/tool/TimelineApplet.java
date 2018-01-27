package timeline.tool;

import java.awt.Dimension;
import java.math.BigDecimal;
import java.math.RoundingMode;
import processing.core.*;

public class TimelineApplet extends PApplet {
  
    public static final int WIDE = 800;
    public static final int HIGH = 200;

    public final static int RULER_THICKNESS = 88;
  
    public TimelineVariable timelineVariable;
  
    TimelineApplet(TimelineVariable timeline) {
        this.timelineVariable = timeline;
    }
  
    public void setup() {
        size(WIDE, HIGH);
        noLoop();
    }
    
    public void draw() {
        background(255);
        pushMatrix();
        translate(RULER_THICKNESS, 0);
        timelineVariable.draw(this);
        popMatrix();

        // draw the ruler
        drawYAxisRuler();
    }

    private void drawYAxisRuler() {
        fill(223, 248, 215);
        stroke(160, 192, 159);
        strokeWeight(1);
        
        // draw the background of the ruler:
        // the - 1 is for the stroke
        rect(0, 0, RULER_THICKNESS - 1, HIGH);

        // figure out the tick marks:

        float minY = timelineVariable.screenToY(height);
        float maxY = timelineVariable.screenToY(0);

        float range = maxY - minY;
        float majorDistance = 1;
        float pixelDistance = timelineVariable.yToScreen(0) - timelineVariable.yToScreen(majorDistance);

        final int MAX_PIXEL_DIST = 60;
        final int MIN_PIXEL_DIST = 20;

        // use mutlipliers: 2, 2.5 then 2
        // 1, 2, 5, 10, 20, 50, 100, 200, 500, ...

        float zoom = timelineVariable.getYZoom();
        int whichMultiplier = 0;

        if ( pixelDistance < MIN_PIXEL_DIST ) {
            while ( pixelDistance < MIN_PIXEL_DIST) {
                switch(whichMultiplier) {
                    case 1:
                        majorDistance *= 2.5;
                        break;
                    default:
                        whichMultiplier = 0;
                    case 0:
                    case 2:
                        majorDistance *= 2;
                        break;
                }

                whichMultiplier++;
                pixelDistance = timelineVariable.yToScreen(0) - timelineVariable.yToScreen(majorDistance);
            }
        }
        else { // must divide
            float divisor = 1;
            while ( pixelDistance > MAX_PIXEL_DIST) {
                switch(whichMultiplier) {
                    case 1:
                        divisor *= 2.5;
                        break;
                    default:
                        whichMultiplier = 0;
                    case 0:
                    case 2:
                        divisor *= 2;
                        break;
                }

                majorDistance = 1 / divisor;
                whichMultiplier++;
                pixelDistance = timelineVariable.yToScreen(0) - timelineVariable.yToScreen(majorDistance);
            }

            BigDecimal bigDivision = new BigDecimal(1);
            majorDistance = bigDivision.divide(new BigDecimal(divisor), 3, RoundingMode.HALF_UP).floatValue();
        }

        final int TICK_MARK_LENGTH = 14;

        // TODO: this can be optimized heavily
        strokeWeight(1);
        stroke(88, 105, 87);
        fill(100); // text color

        processing.core.PFont helveticaFont = createFont("helvetica", 10);
        textFont(helveticaFont);
        textAlign(RIGHT, CENTER);

        // draw 0
        line(0, timelineVariable.yToScreen(0), RULER_THICKNESS - 1, timelineVariable.yToScreen(0));

        // draw above 0
        for (float y = majorDistance; y < timelineVariable.screenToY(0); y += majorDistance) {
            line(RULER_THICKNESS - TICK_MARK_LENGTH, (int) timelineVariable.yToScreen(y), RULER_THICKNESS - 1, (int) timelineVariable.yToScreen(y));
            text("" + y, RULER_THICKNESS - TICK_MARK_LENGTH - 4, timelineVariable.yToScreen(y));
        }

        // draw below 0
        for (float y = -majorDistance; y > timelineVariable.screenToY(height); y -= majorDistance) {
            line(RULER_THICKNESS - TICK_MARK_LENGTH, (int) timelineVariable.yToScreen(y), RULER_THICKNESS - 1, (int) timelineVariable.yToScreen(y));
            text("" + y, RULER_THICKNESS - TICK_MARK_LENGTH - 4, timelineVariable.yToScreen(y));
        }
    }

    public void mousePressed() {
        if (mouseX >= RULER_THICKNESS) {
            timelineVariable.mousePressed(mouseX - RULER_THICKNESS, mouseY);
            redraw();
        }
    }
  
    public void mouseDragged() {
        timelineVariable.mouseDragged(mouseX - RULER_THICKNESS, mouseY);
        redraw();
    }

    public void mouseReleased() {
        timelineVariable.mouseReleased(mouseX - RULER_THICKNESS, mouseY);
        redraw();
    }


    public void keyPressed() {
        if (key == PApplet.BACKSPACE) {
            timelineVariable.deletePressed();
        }
    }

    public void keyReleased() {
        // nothing yet...
    }
  
    public Dimension getPreferredSize() {
      return new Dimension(WIDE, HIGH);
    }

    public Dimension getMinimumSize() {
      return new Dimension(WIDE, HIGH);
    }

    public Dimension getMaximumSize() {
      return new Dimension(WIDE, HIGH);
    }

    public boolean modifierActive() {
        return keyPressed && key == CODED && keyCode == ALT;
    }
}
