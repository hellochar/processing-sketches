package timeline.tool;

import java.applet.Applet;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import processing.core.PApplet;
import processing.core.PVector;
import timeline.BezierSpline;
import timeline.BezierVertex;

public class TimelineVariable {
    public List<Draggable> draggables = new ArrayList<Draggable>();
    Draggable selectedDraggable = null;
    public String name = "";
    public BezierSpline spline;
    Timeline timeline;

    float yPan = 0.0f;


    //public List<TimelineVariable> timelineVariables = new ArrayList<TimelineVariable>();

    void deletePressed() {
        // tell the selected draggable the user is trying to delete something
        if (selectedDraggable != null) {
            selectedDraggable.delete(applet);
        }
    }


    public enum PlaybackType { TIME_BASED, FRAME_BASED }
    public PlaybackType playbackMode = PlaybackType.TIME_BASED;
    private PVector lastPanCoord;
    //private PVector panOffset;
    private PVector zoom = new PVector(1, 1);
    //private float playbackHeadLocation = 20;
    private TimelineApplet applet;
    private boolean isDraggingPlaybackHead = false;
    private boolean hasDragged = false;

    public final static int RULER_HEIGHT = 24;

    public TimelineVariable(Timeline timeline, String name) {
        this.applet = new TimelineApplet(this);
        this.name = name;
        this.spline = new BezierSpline(this);
        yPan = -TimelineApplet.HIGH / 2.0f; // start off centered on 0
        this.timeline = timeline;
    }

    void setApplet(TimelineApplet applet) {
        this.applet = applet;
    }

    void draw(PApplet applet) {
        applet.smooth();
        applet.strokeWeight(1);

        applet.background(250);
        applet.stroke(155);
        applet.line(0, yToScreen(0), applet.width, yToScreen(0));

        drawDraggables(applet);
        spline.drawOnApplet(applet);

        //applet.strokeWeight(1);
    }

    void drawRulerOld(PApplet applet) {
        float majorDistance = 100;
        float minorDistance = 10;

        // use different ruler spacing for different zoom levels
        if (zoom.x > 3) {
            majorDistance = 25;
            minorDistance = 2.5f;
        } else if (zoom.x >= 1.5) {
            majorDistance = 50;
            minorDistance = 5;
        } else if (zoom.x >= 0.99) {
            majorDistance = 100;
            minorDistance = 10;
        } else if (zoom.x >= 0.5) {
            majorDistance = 250;
            minorDistance = 25;
        } else if (zoom.x >= 0.25) {
            majorDistance = 500;
            minorDistance = 50;
        } else {
            majorDistance = 1000;
            minorDistance = 100;
        }

        final int majorHeight = 12;
        final int minorHeight = 5;

        applet.fill(223, 248, 215, 125);
        applet.stroke(160, 192, 159);
        applet.rect(0, 0, applet.width, RULER_HEIGHT);

        // draw the major lines
        applet.stroke(88, 105, 87);
        applet.fill(100); // text color


        // TODO: create font only once
        processing.core.PFont helveticaFont = applet.createFont("helvetica", 10);
        applet.textFont(helveticaFont);
        
        // TODO: optimize the initial value of i
        for (float i = majorDistance; i < screenToX(applet.width); i += (majorDistance)) {
            applet.line(xToScreen(i), 0, xToScreen(i), majorHeight);
            applet.text(i/100.0f + "s", xToScreen(i) - 5, 22);
        }

        for (float i = 0; i < screenToX(applet.width); i += (minorDistance)) {
            if (i % majorDistance != 0) { // don't draw over major lines
                applet.line(xToScreen(i), 0, xToScreen(i), minorHeight);
            }
        }
    }

    boolean isInRuler(int x, int y) {
        return y <= RULER_HEIGHT && y >= 0;
    }

    
    void mousePressed(int x, int y) {
         {
            if (timeline.getMode() == Timeline.Mode.DRAW) {
                if (screenToX(x) > spline.maximumValue.x) {
                    spline.addVertex(screenToX(x), screenToY(y));
                } else if (screenToX(x) > spline.minimumValue.x) {
                    // only subdivide if we clicked close enough to the curve
                    PVector splineVal = new PVector(x, 0);
                    splineVal.y = yToScreen(spline.getValue(screenToX(splineVal.x)));
                    PVector mouse = new PVector(x, y);
                    if (mouse.dist(splineVal) < 8) {
                        spline.insertVertex(screenToX(x), screenToY(y));
                    }
                }
            } else if (timeline.getMode() == Timeline.Mode.SELECT || timeline.getMode() == Timeline.Mode.TANGENT) {
                draggableSelect(x, y);
            }
        }
    }



    // see if any draggables were clicked on
    void draggableSelect(float x, float y) {
        selectedDraggable = null;

        Draggable closestDraggable = null;
        float minDistance = 0.0f;
        
        PVector mouse = new PVector(x, y);


        for (Draggable draggable : draggables) {
            float dist = mouse.dist(new PVector(xToScreen(draggable.getCoords().x), yToScreen(draggable.getCoords().y)));
            if (dist < draggable.getRadius() + 4.0f && (closestDraggable == null || dist < minDistance) ) {
                closestDraggable = draggable;
                minDistance = dist;
            }
        }

        selectedDraggable = closestDraggable;

        if (selectedDraggable != null) {
            if (selectedDraggable instanceof ControlPointDraggable) { // TODO: nasty, need to rethink draggables
                int index = selectedDraggable.getIndex();
                selectedDraggable.pressed(x, y, applet.modifierActive(), timeline.getMode());
                selectedDraggable = getControlPointDraggableAtIndex(index); // TODO: might want to get rid of this, kind of nasty
            } else {
                selectedDraggable.pressed(x, y, applet.modifierActive(), timeline.getMode());

            }
        }
    }
    
    void dragDraggable(float x, float y) {
        if (selectedDraggable != null) {
            if (selectedDraggable instanceof ControlPointDraggable) {
                int index = selectedDraggable.getIndex();
                selectedDraggable.dragged(x, y, applet.modifierActive(), timeline.getMode());
                selectedDraggable = getControlPointDraggableAtIndex(index); // TODO: might want to get rid of this, kind of nasty
            } else {
                selectedDraggable.dragged(x, y, applet.modifierActive(), timeline.getMode());
            }
            hasDragged = true;
        }
    }

    ControlPointDraggable getControlPointDraggableAtIndex(int index) {
        for (Draggable draggable : draggables) {
            if (draggable instanceof ControlPointDraggable) {
                if (draggable.getIndex() == index) {
                    return (ControlPointDraggable) draggable;
                }
            }
        }

        return null;
    }

    void drawDraggables(PApplet applet) {
        applet.ellipseMode(PApplet.RADIUS);
        applet.rectMode(PApplet.RADIUS);
        for (int i = 0; i < draggables.size(); i++) {
            Draggable draggable = draggables.get(i);
        //for (Draggable draggable : draggables) {
            PVector coords = draggable.getCoords();
            float radius = draggable.getRadius();
            if (draggable.equals(selectedDraggable)) {
                applet.fill(125);
            } else {
                applet.noFill();
            }

            applet.stroke(125);

            if (draggable.hasCircleHandle()) {
                applet.ellipse(xToScreen(coords.x), yToScreen(coords.y), radius, radius);
            } else if (draggable.hasSquareHandle()) {
                applet.rect(xToScreen(coords.x), yToScreen(coords.y), radius, radius);
            }

            draggable.drawExtras(applet, this);
        }

        applet.noFill();
    }

    void mouseDragged(int x, int y) {
            if (timeline.getMode() == Timeline.Mode.DRAW) {
                // TODO: figure out which timeline variable to use
                if (screenToX(x) > spline.maximumValue.x) {
                    if (applet.modifierActive()) {
                        spline.updateLastTangentOnly(screenToX(x), screenToY(y));
                    } else {
                        spline.updateLastTangent(screenToX(x), screenToY(y));
                    }

                    spline.createDraggables();
                }
            } else if (timeline.getMode() == Timeline.Mode.SELECT || timeline.getMode() == Timeline.Mode.TANGENT) {
                dragDraggable(screenToX(x), screenToY(y));
            }
    }

    void mouseReleased(int x, int y) {
        if (selectedDraggable != null) {
            hasDragged = false;
            
        }

        if (removeSmallTangents()) { // don't show tangents that are too close to the anchor
            spline.createDraggables();
        }

        spline.autoAdjustYAxis();

    }
    
    boolean removeSmallTangents() {
        final int MIN_PIXEL_DIST = 10;
        boolean anyRemoved = false;
        for (BezierVertex vertex : spline.vertices) {
            // find the screen coordinates for everything in the vertex
            PVector anchorScreen = new PVector(timeline.xToScreen(vertex.a.x), yToScreen(vertex.a.y));

            if (vertex.hasT1) {
                PVector tangentScreen = new PVector(timeline.xToScreen(vertex.t1.x), yToScreen(vertex.t1.y));
                if (anchorScreen.dist(tangentScreen) < MIN_PIXEL_DIST) {
                    // remove the tangent
                    vertex.hasT1 = false;
                    anyRemoved = true;
                }

            }

            if (vertex.hasT2) {
                PVector tangentScreen = new PVector(timeline.xToScreen(vertex.t2.x), yToScreen(vertex.t2.y));
                if (anchorScreen.dist(tangentScreen) < MIN_PIXEL_DIST) {
                    // remove the tangent
                    vertex.hasT2 = false;

                    anyRemoved = true;
                }
            }
        }

        return anyRemoved;
    }


    public void rename(String newName) {
        if (!newName.equals("") && !timeline.nameExists(newName)) {
            name = newName;
        }
    }

    public void clearDraggables() {
        draggables = new ArrayList<Draggable>();
        selectedDraggable = null;
    }

    public void addDraggable(Draggable draggable) {
        draggables.add(draggable);
    }

    public float getMinY() {
        float min = spline.minimumValue.y;
        float minHandle = spline.getMinimumHandleValues().y;

        if (minHandle < min) {
            return minHandle;
        }

        return min;
    }

    public float getMaxY() {
        float max = spline.maximumValue.y;
        float maxHandle = spline.getMaximumHandleValues().y;

        if (maxHandle < max) {
            return maxHandle;
        }

        return max;
    }

    public float xToScreen(float x) {
        return (x + timeline.getXPan()) * timeline.getXZoom();
    }

    public float yToScreen(float y) {
        return -((y + yPan) * zoom.y);
    }

    public float screenToX(float screenX) {
        return screenX / timeline.getXZoom() - timeline.getXPan();
    }

    public float screenToY(float screenY) {
        return (-(screenY) / zoom.y - yPan);
    }

    public void setXZoom(float zoomX) {
        this.zoom.x = zoomX;
    }

    public void setYPan(float yPan) {
        this.yPan = yPan;
    }

    public void setYZoom(float yZoom) {
        this.zoom.y = yZoom;
    }

    public float getYZoom() {
        return this.zoom.y;
    }

    public int getHeight() {
        return applet.HIGH;
    }

    public TimelineApplet getApplet() {
        return applet;
    }
}
