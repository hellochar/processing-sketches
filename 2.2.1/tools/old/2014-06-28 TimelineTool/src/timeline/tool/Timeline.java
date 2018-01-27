package timeline.tool;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import processing.core.PVector;
import timeline.TimelineExporter;

public class Timeline {

    PVector zoom;
    float xPan = 0.0f;
    float xZoom = 1.0f;
    Ruler ruler;
    float playHeadLocation = 0.0f;
    Mode mode = Mode.DRAW;

    enum Mode {
        DRAW, SELECT, TANGENT
    }

    public Timeline() {
        ruler = new Ruler(this);
    }


    public List<TimelineVariable> timelineVariables = new ArrayList<TimelineVariable>();

    public void addNewVariable(String name) {
        timelineVariables.add(new TimelineVariable(this, name));
    }

    public void addNewVariable(TimelineVariable variable) {
        timelineVariables.add(variable);
    }

    public TimelineVariable getVariable(String name) {
        for (TimelineVariable curVar : timelineVariables) {
            if (curVar.name.equals(name)) {
                return curVar;
            }
        }

        return null;
    }

    public boolean nameExists(String name) {
        for (TimelineVariable curVar : timelineVariables) {
            if (curVar.name.equals(name)) {
                return true;
            }
        }

        return false;
    }

    // redraw all of the timeline var applets
    public void redraw() {
        ruler.redraw();
        for (TimelineVariable var : timelineVariables) {
            var.getApplet().redraw();
        }

        ruler.redraw();
    }

    void export(String filename) throws FileNotFoundException {
        TimelineExporter.export(this, filename);
    }

    void setPlayHeadLocation(float playHeadLocation) {
        // set the play head location
        this.playHeadLocation = playHeadLocation;

        // if we're to the right of the screen edge, we should move right
        if (playHeadLocation > screenToX(ruler.RULER_WIDTH)) {
            xPan -= playHeadLocation + - screenToX(ruler.RULER_WIDTH);
        } else if (playHeadLocation < -xPan) { // to the left
            xPan = -playHeadLocation;
        }

        //redraw(); // redraw all variables
    }

    void removeTimelineVariable(TimelineVariable timelineVariable) {
        timelineVariables.remove(timelineVariable);
    }

    // Getters & Setters
    public void setMode(Mode mode) {
        this.mode = mode;
    }

    public Mode getMode() {
        return mode;
    }
    
    PVector getZoom() {
        return zoom;
    }

    float getXPan() {
        return xPan;
    }

    void setXPan(float xPan) {
        this.xPan = xPan;

        if (this.xPan > 0) {
            this.xPan = 0;
        }
    }

    float getXZoom() {
        return xZoom;
    }

    void setXZoom(float xZoom) {
        this.xZoom = xZoom;
        redraw();
    }

    float xToScreen(float x) {
        return (x + xPan) * xZoom + 1.0f;
    }

    float screenToX(float screenX) {
        return (screenX - 1.0f) / xZoom - xPan;
    }

    public List<TimelineVariable> getTimelineVariables() {
        return timelineVariables;
    }
}
