package timeline.tool;

import processing.core.PApplet;
import processing.core.PVector;
import timeline.BezierSpline;
import timeline.BezierVertex;

public class ControlPointDraggable implements Draggable {
    private BezierVertex vertex;
    private BezierSpline spline;
    private int index;

    public ControlPointDraggable(BezierSpline spline, int index) {
        this.index = index;
        this.spline = spline;
        this.vertex = spline.vertices.get(index);
    }

    public PVector getCoords() {
        return vertex.a;
    }

    public float getRadius() {
        return 3.0f;
    }

    public void dragged(float x, float y, boolean modifierOn, Timeline.Mode mode) {
        if (mode == Timeline.Mode.SELECT) {
            spline.moveControlPoint(index, x, y);
        } else if (mode == Timeline.Mode.TANGENT) {
            vertex.hasT1 = true;
            vertex.hasT2 = true;

            if (x > vertex.a.x) {
                spline.updateTangent2(index, x, y);
            } else if (x < vertex.a.x) {
                spline.updateTangent1(index, x, y);
            }

            spline.createDraggables();
        }
    }

    public void pressed(float x, float y, boolean modifierOn, Timeline.Mode mode) {
        if (mode == Timeline.Mode.TANGENT) {
            vertex.hasT1 = false;
            vertex.hasT2 = false;

            spline.createDraggables();
        }
    }

    public boolean hasSquareHandle() {
        return true;
    }

    public boolean hasCircleHandle() {
        return false;
    }

    public void drawExtras(PApplet applet, TimelineVariable timeline) {
        return; // nothing extra
    }

    public void delete(PApplet applet) {
        spline.removeControlPoint(index);
        applet.redraw();
    }

    public int getIndex() {
        return index;
    }

}
