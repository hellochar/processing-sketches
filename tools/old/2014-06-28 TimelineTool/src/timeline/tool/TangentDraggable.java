package timeline.tool;

import processing.core.PApplet;
import processing.core.PVector;
import timeline.BezierSpline;
import timeline.BezierVertex;
import timeline.tool.Timeline.Mode;


public class TangentDraggable implements Draggable {
    BezierSpline spline;
    int index;
    BezierVertex vertex;
    boolean t1;
    PVector tangent;

    public TangentDraggable(BezierSpline spline, int index, boolean t1) {
        this.spline = spline;
        this.index = index;
        this.vertex = spline.vertices.get(index);
        this.t1 = t1;

        if (t1) {
            tangent = vertex.t1;
        } else {
            tangent = vertex.t2;
        }
    }

    public PVector getCoords() {
        return tangent;
    }

    public float getRadius() {
        return 3.0f;
    }

    public void dragged(float x, float y, boolean modifierOn, Timeline.Mode mode) {
        if (mode == Timeline.Mode.TANGENT) {
            return; // for now, ignore the tangent tool
        }

        if (t1) {
            if (modifierOn) {
                spline.updateTangent1Only(index, x, y);
            } else {
                spline.updateTangent1(index, x, y);
            }
        } else {
            if (modifierOn) {
                spline.updateTangent2Only(index, x, y);
            } else {
                spline.updateTangent2(index, x, y);
            }
        }
    }

    public boolean hasSquareHandle() {
        return false;
    }

    public boolean hasCircleHandle() {
        return true;
    }

    public void drawExtras(PApplet applet, TimelineVariable timeline) {
        applet.line(
                timeline.xToScreen(tangent.x), timeline.yToScreen(tangent.y),
                timeline.xToScreen(vertex.a.x), timeline.yToScreen(vertex.a.y));
    }

    public void delete(PApplet applet) {
        // reset the selected tangent to the location of the control point
        BezierVertex vertex = spline.vertices.get(index);
        if (t1) {
            vertex.t1 = vertex.a.get();
        } else {
            vertex.t2 = vertex.a.get();
        }

        spline.update();
        spline.createDraggables();
        applet.redraw();
    }

    public void pressed(float x, float y, boolean modifierOn, Mode mode) {
        return; // do nothing
    }

    public int getIndex() {
        return index;
    }

}
