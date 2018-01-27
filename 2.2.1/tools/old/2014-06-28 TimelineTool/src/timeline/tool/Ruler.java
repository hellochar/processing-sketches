package timeline.tool;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Timer;
import processing.core.PApplet;
import processing.core.PVector;

/**
 * The x-axis ruler.  Shows the user where time values are, and also allows
 * the user to drag it to pan along the x-axis
 */
public class Ruler extends PApplet {
    public final static int NAV_BUTTON_WIDTH = 20;
    public final static int RULER_HEIGHT = 24;
    public final static int RULER_WIDTH = 800 - TimelineApplet.RULER_THICKNESS + NAV_BUTTON_WIDTH; /*- VariableInfoPanel.PANEL_WIDTH*/;

    boolean leftButtonPressed = false;
    boolean rightButtonPressed = false;

    PVector lastPanCoords;
    Timer timer;
    Timeline timeline;
    boolean dragThreadRunning = false;
    float playbackHeadLocation = 0.0f;

    public Ruler(Timeline timeline) {
        this.timeline = timeline;
    }

    public void setup() {
        size(RULER_WIDTH, RULER_HEIGHT);
        smooth();
        noLoop();
    }

    private void drawButton(boolean pointsLeft, boolean isDown) {
        if (isDown) {
            fill(115, 128, 111);
        } else {
            fill(184, 204, 177);
        }

        noStroke();
        rect(0, 0, NAV_BUTTON_WIDTH, RULER_HEIGHT);

        // arrow
        if (isDown) {
            fill(215);
        } else {
            fill(255);
        }

        stroke(81, 89, 78);

        if (pointsLeft) {
            triangle(NAV_BUTTON_WIDTH - 6, 6, NAV_BUTTON_WIDTH - 6, RULER_HEIGHT - 6, 6, RULER_HEIGHT / 2);
        } else {
            triangle(6, 6, 6, RULER_HEIGHT - 6, NAV_BUTTON_WIDTH - 6, RULER_HEIGHT / 2);
        }
    }

    public void draw() {
        translate(NAV_BUTTON_WIDTH, 0);

        float majorDistance = 100;
        float minorDistance = 10;

        float xZoom = timeline.getXZoom();

        // use different ruler spacing for different zoom levels
        // these are set manually for maximal niceness (still might need
        // to be tweaked)
        if (xZoom > 3) {
            majorDistance = 25;
            minorDistance = 2.5f;
        } else if (xZoom >= 1.5) {
            majorDistance = 50;
            minorDistance = 5;
        } else if (xZoom >= 0.99) {
            majorDistance = 100;
            minorDistance = 10;
        } else if (xZoom >= 0.5) {
            majorDistance = 250;
            minorDistance = 25;
        } else if (xZoom >= 0.25) {
            majorDistance = 500;
            minorDistance = 50;
        } else {
            majorDistance = 1000;
            minorDistance = 100;
        }

        final int majorHeight = 12;
        final int minorHeight = 5;

        fill(223, 248, 215);
        stroke(160, 192, 159);
        rect(0, 0, RULER_WIDTH, RULER_HEIGHT);

        // draw the major lines
        stroke(88, 105, 87);
        fill(100); // text color

        // TODO: create font only once
        processing.core.PFont helveticaFont = createFont("helvetica", 10);
        textFont(helveticaFont);

        // TODO: optimize the initial value of i when panned
        for (float i = majorDistance; i < screenToX(width); i += (majorDistance)) {
            line(xToScreen(i), 0, xToScreen(i), majorHeight);
            text(i/100.0f + "s", xToScreen(i) - 5, 22);
        }

        for (float i = 0; i < screenToX(width); i += (minorDistance)) {
            if (i % majorDistance != 0) { // don't draw over major lines
                line(xToScreen(i), 0, xToScreen(i), minorHeight);
            }
        }


        // draw the left nav button
        translate(-NAV_BUTTON_WIDTH, 0);
        drawButton(true, leftButtonPressed);

        // draw the right nav button
        translate(RULER_WIDTH - NAV_BUTTON_WIDTH, 0);
        drawButton(false, rightButtonPressed);
    }

    private final int NAV_SCROLL_AMNT = 20;
    int navScrollDelay = 300;


    Timer leftButtonTimer = new Timer(navScrollDelay, new ActionListener() {

        public void actionPerformed(ActionEvent e) {
            timeline.setXPan((timeline.getXPan() + NAV_SCROLL_AMNT / timeline.getXZoom()));
            timeline.redraw();
            navScrollDelay /= 1.5;
            if (navScrollDelay < 30) {
                navScrollDelay = 30;
            }
            leftButtonTimer.setDelay(navScrollDelay);
        }
    });

    Timer rightButtonTimer = new Timer(navScrollDelay, new ActionListener() {

        public void actionPerformed(ActionEvent e) {
            timeline.setXPan((timeline.getXPan() - NAV_SCROLL_AMNT / timeline.getXZoom()));
            timeline.redraw();
            navScrollDelay /= 1.5;
            if (navScrollDelay < 30) {
                navScrollDelay = 30;
            }
            rightButtonTimer.setDelay(navScrollDelay);
        }
    });
    
    public void mousePressed() {

        if (mouseX < NAV_BUTTON_WIDTH) { // left button pressed
            navScrollDelay = 300;
            leftButtonPressed = true;
            timeline.setXPan(timeline.getXPan() + NAV_SCROLL_AMNT / timeline.getXZoom());
            timeline.redraw();
            leftButtonTimer.start();
        } else if (mouseX > RULER_WIDTH - NAV_BUTTON_WIDTH) { // right button pressed
            navScrollDelay = 300;
            rightButtonPressed = true;
            timeline.setXPan((timeline.getXPan() - NAV_SCROLL_AMNT / timeline.getXZoom()));
            timeline.redraw();
            rightButtonTimer.start();
        } else { // ruler dragged
            lastPanCoords = new PVector(mouseX, mouseY);
        }
    }

    public void mouseReleased() {
        leftButtonPressed = false;
        rightButtonPressed = false;

        leftButtonTimer.stop();
        rightButtonTimer.stop();

        redraw();
    }

    public void mouseDragged() {
        // dragging the ruler, not clicking either nav button
        if (!leftButtonPressed && !rightButtonPressed) {
            float x_new = timeline.getXPan() + (mouseX - lastPanCoords.x) / timeline.getXZoom();
            if (x_new <= 0) {
                timeline.setXPan(x_new);
                timeline.redraw();
            }
            lastPanCoords = new PVector(mouseX, mouseY);
        }
    }
    
    // TODO: optimize
    // extra 1.0f is because of the scrollable border
    float xToScreen(float x) {
        return (x + timeline.getXPan()) * timeline.getXZoom() + 1.0f;
    }

    float screenToX(float screenX) {
        return (screenX - 1.0f) / timeline.getXZoom() - timeline.getXPan();
    }


    public Dimension getPreferredSize() {
        return new Dimension(RULER_WIDTH, RULER_HEIGHT);
    }

    public Dimension getMinimumSize() {
        return new Dimension(RULER_WIDTH, RULER_HEIGHT);
    }

    public Dimension getMaximumSize() {
        return new Dimension(RULER_WIDTH, RULER_HEIGHT);
    }

    public boolean modifierActive() {
        return keyPressed && key == CODED && keyCode == ALT;
    }

}
