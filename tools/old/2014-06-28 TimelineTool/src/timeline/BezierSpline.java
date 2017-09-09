package timeline;

import java.util.List;
import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PVector;
import timeline.tool.ControlPointDraggable;
import timeline.tool.TangentDraggable;
import timeline.tool.TimelineVariable;

public class BezierSpline implements TimelineShape {
    public List<BezierVertex> vertices = new ArrayList<BezierVertex>();
    List<PVector> values = new ArrayList<PVector>();

    public PVector minimumValue = new PVector();
    public PVector maximumValue = new PVector();

    private static final float timeStep = 0.0001f;

    private TimelineVariable timeline;

    /**
     * Subdivide the spline at the location specified by the user.
     * 
     * @param x x-coordinate where the user clicked
     * @param y y-coordinate where the user clicked
     */
    public void insertVertex(float x, float y) {
        float t = getTFromX(x);

        int segmentNumber = (int) t;
        float t_segment = t - segmentNumber;


        BezierVertex v = vertices.get(segmentNumber + 1);
        BezierVertex v_prev = vertices.get(segmentNumber);

        // use de Casteljau's algorithm to find the tangents for the new point
        // q0, q1, q2 are the points determined by p0-p3 & t
        PVector q0 = new PVector(
                        v_prev.a.x + t_segment * (v_prev.t2.x - v_prev.a.x),
                        v_prev.a.y + t_segment * (v_prev.t2.y - v_prev.a.y));

        PVector q1 = new PVector(
                        v_prev.t2.x + t_segment * (v.t1.x - v_prev.t2.x),
                        v_prev.t2.y + t_segment * (v.t1.y - v_prev.t2.y));

        PVector q2 = new PVector(
                        v.t1.x + t_segment * (v.a.x - v.t1.x),
                        v.t1.y + t_segment * (v.a.y - v.t1.y));

        // now we can find the tangents
        PVector t1 = new PVector(
                        q0.x + t_segment * (q1.x - q0.x),
                        q0.y + t_segment * (q1.y - q0.y));

        PVector t2 = new PVector(
                        q1.x + t_segment * (q2.x - q1.x),
                        q1.y + t_segment * (q2.y - q1.y));

        // now find the exact location of the new anchor (should be very close
        // to the x-value that the user clicked on)
        PVector a = new PVector(
                        t1.x + t_segment * (t2.x - t1.x),
                        t1.y + t_segment * (t2.y - t1.y));


        // we also need to adjust the tangents for the previous and next vertices
        v_prev.t2 = q0;
        v.t1 = q2;

        vertices.add(segmentNumber + 1, new BezierVertex(a, t1, t2));

        update();
        createDraggables();
    }

    public void removeControlPoint(int index) {
        vertices.remove(index);
        update();
        createDraggables();
    }

    /**
     * Precompute points along the spline and cache them
     */
    void calculateValues() {
        values = new ArrayList<PVector>();

        for (int i = 1; i < vertices.size(); i++) {
            BezierVertex v_prev = vertices.get(i - 1);
            BezierVertex v = vertices.get(i);

            // calculate the constants
            PVector c = calculateC(v, v_prev);

            PVector b = calculateB(v, v_prev, c);

            PVector a = calculateA(v, v_prev, c, b);

            // calculate the points
            float x = 0;
            float y = 0;
            for (float t = 0; t <= 1.0; t += timeStep) {
                x = a.x * t * t * t + b.x * t * t + c.x * t + v_prev.a.x;
                y = a.y * t * t * t + b.y * t * t + c.y * t + v_prev.a.y;
                values.add(new PVector(x, y));
            }
        }
    }

    void calculateMinAndMax() {
        if (vertices.size() > 0) {
            PVector anchor = vertices.get(0).a;
            minimumValue.x = anchor.x;
            minimumValue.y = anchor.y;
            maximumValue.x = anchor.x;
            maximumValue.y = anchor.y;
        }

        for (PVector p : values) {
            if (p.x > maximumValue.x) {
                maximumValue.x = p.x;
            }

            if (p.y > maximumValue.y) {
                maximumValue.y = p.y;
            }

            if (p.x < minimumValue.x) {
                minimumValue.x = p.x;
            }

            if (p.y < minimumValue.y) {
                minimumValue.y = p.y;
            }
        }
    }

    public BezierSpline(TimelineVariable timeline) {
        this.timeline = timeline;
    }

    // use when anything changes in the spline and values must be recalculated
    public void update() {
        calculateValues();
        calculateMinAndMax();
    }

    public void autoAdjustYAxis() {
        // only autoadjust if we have enough points to have a range
        if (vertices.size() < 2) {
            return;
        }

        // find the min and max values on the y-axis.
        // this includes both handles and the actual spline
        float y_min = getMinimumHandleValues().y;
        float y_max = getMaximumHandleValues().y;

        if (minimumValue.y < y_min) {
            y_min = minimumValue.y;
        }

        if (maximumValue.y > y_max) {
            y_max = maximumValue.y;
        }

        float range = y_max - y_min;
        float y_center = range / 2.0f + y_min;
        
        float zoom = 1;

        if (range != 0) {
            zoom = (timeline.getHeight()) / range;
        }

        y_max += 6/zoom;
        y_min -= 8/zoom;

        range = y_max - y_min;
        zoom = (timeline.getHeight()) / range;

        timeline.setYPan(-(y_max));

        timeline.setYZoom(zoom);
    }

    public void createDraggables() {
        timeline.clearDraggables();
        for (int i = 0; i < vertices.size(); i++) {
            timeline.addDraggable(new ControlPointDraggable(this, i));

            BezierVertex vertex = vertices.get(i);
            // tangents
            if (vertex.hasT1) {
                timeline.addDraggable(new TangentDraggable(this, i, true));
            }

            if (vertex.hasT2) {
                timeline.addDraggable(new TangentDraggable(this, i, false));
            }
        }
    }


    public void drawOnApplet(PApplet applet) {
        applet.stroke(0);
        applet.beginShape();

        // first vertex is just a vertex, not a BezierVertex
        if (vertices.size() > 0) {
            BezierVertex v = vertices.get(0);
            applet.vertex(timeline.xToScreen(v.a.x), timeline.yToScreen(v.a.y));
            for (int i = 1; i < vertices.size(); i++) {
                //System.out.println("Drawing vertex " + i);
                BezierVertex v_prev = vertices.get(i - 1);
                v = vertices.get(i);

                // bezierVertex represents a segment of a Processing bezier curve
                // args: (starting tangent, ending tangent, end point)
                applet.bezierVertex(
                        timeline.xToScreen(v_prev.t2().x),
                        timeline.yToScreen(v_prev.t2().y),
                        timeline.xToScreen(v.t1().x),
                        timeline.yToScreen(v.t1().y),
                        timeline.xToScreen(v.a.x),
                        timeline.yToScreen(v.a.y));
            }


        }

        applet.endShape();
    }

    // TODO
    public void drawBoundingBox(PApplet applet) {
    }

    public void addVertex(float x, float y) {
        // make sure this vertex is to the right of the previous one
        if (vertices.size() == 0 || x > vertices.get(vertices.size() - 1).a.x) {
            vertices.add(new BezierVertex(x, y));
            
            // check the previous control point's second tangent
            // it needs to be to the left of the new control point
            if (vertices.size() > 1) {
                BezierVertex previousVertex = vertices.get(vertices.size() - 2);
                if (previousVertex.t2.x >= x) {
                    previousVertex.t2.x = x - 0.001f;
                }
            }

            update();
            createDraggables();
        }


    }
    
    private PVector calculateSymmetricTangent(PVector anchor, PVector tangent) {
        PVector symmetricTangent = new PVector(tangent.x, tangent.y);
        
        symmetricTangent.sub(anchor);
        symmetricTangent.mult(-1);
        symmetricTangent.add(anchor);
        
        return symmetricTangent;
    }

    public void updateTangent1(int index, float x, float y) {
        BezierVertex vertex = vertices.get(index);

        updateTangent1Only(index, x, y);

        PVector symmetricTangent = calculateSymmetricTangent(vertex.a, vertex.t1);
        updateTangent2Only(index, symmetricTangent.x, symmetricTangent.y);
    }

    public void updateTangent2(int index, float x, float y) {
        BezierVertex vertex = vertices.get(index);
        
        updateTangent2Only(index, x, y);
        
        PVector symmetricTangent = calculateSymmetricTangent(vertex.a, vertex.t2);
        updateTangent1Only(index, symmetricTangent.x, symmetricTangent.y);
    }

    public void updateTangent1Only(int index, float x, float y) {
        BezierVertex vertex = vertices.get(index);

        // t1 must be left of the current CP
        // t1 must be right of the previous CP
        if (index > 0) {
            BezierVertex previousVertex = vertices.get(index - 1);
            if (x <= previousVertex.a.x) {
                x = vertex.t1.x;
            }
        }

        if (x >= vertex.a.x) {
            x = vertex.t1.x;
        }


        vertex.t1.x = x;
        vertex.t1.y = y;
    }

    public void updateTangent2Only(int index, float x, float y) {
        BezierVertex vertex = vertices.get(index);

        // t2 must be left of the next CP
        // t1 must be right of the current CP
        if (index < vertices.size() - 1) {
            BezierVertex nextVertex = vertices.get(index + 1);
            if (x >= nextVertex.a.x) {
                x = vertex.t2.x;
            }
        }

        if (x <= vertex.a.x) {
            x = vertex.t2.x;
        }

        vertex.t2.x = x;
        vertex.t2.y = y;
    }

    public void updateLastTangent(float x, float y) {
        if (vertices.size() > 0) {
            BezierVertex vertex = vertices.get(vertices.size() - 1);
            if (x <= vertex.a.x) {
                x = vertex.t2.x;
            }

            if (vertices.size() > 1) {
                BezierVertex vertex_prev = vertices.get(vertices.size() - 2);
                if (x - vertex.a.x > vertex.a.x - vertex_prev.a.x) {
                    x = vertex.t2.x;
                }
            }

            updateTangent2(vertices.size() - 1, x, y);
        }
    }

    public void updateLastTangentOnly(float x, float y) {
        if (vertices.size() > 0) {
            updateTangent2Only(vertices.size() - 1, x, y);
        }
    }


    public void moveControlPoint(int index, float x, float y) {
        BezierVertex vertex = vertices.get(index);
        
        // restrict it so that the control point cannot move behind the previous CP
        if (index > 0) {
            BezierVertex previousVertex = vertices.get(index - 1);
            if (x <= previousVertex.a.x) {
                x = vertex.a.x;
            }
        }
        
        if (index < vertices.size() - 1) {
            BezierVertex nextVertex = vertices.get(index + 1);
            if (x >= nextVertex.a.x) {
                x = vertex.a.x;
            }
        }

        float d_x = x - vertex.a.x;
        float d_y = y - vertex.a.y;

        vertex.a.x = x;
        vertex.a.y = y;

        updateTangent1Only(index, vertex.t1.x + d_x, vertex.t1.y + d_y);
        updateTangent2Only(index, vertex.t2.x + d_x, vertex.t2.y + d_y);

        // now check the next and previous tangents to make sure that they are
        // still in valid positions
        if (index > 0) {
            BezierVertex previousVertex = vertices.get(index - 1);
            if (previousVertex.t2.x >= x) {
                previousVertex.t2.x = x - 0.001f;
            }
        }

        if (index < vertices.size() - 1) {
            BezierVertex nextVertex = vertices.get(index + 1);
            if (nextVertex.t1.x <= x) {
                nextVertex.t1.x = x + 0.001f;
            }
        }


        update();
    }

    public int numVertices() {
        return vertices.size();
    }

    public float getValue(float x) {
        // first see if the point is to the left of the spline
        if (x <= minimumValue.x) {
            return values.get(0).y; // take the value of the leftmost point
        } else if (x >= maximumValue.x) { // see if the point is to the right of the spline
            return values.get(values.size()).y; // take the value of the rightmost choice
        } else { // otherwise it's on the spline and we need to look for the closest match
            PVector previousValue = null;
            for(PVector value : values) {
                if (value.x > x) { // once we pass the point we can determine an approximation
                    if (previousValue == null) { // if we have no previous value, the best we
                                                 // can do is return the current value (shouldn't get here)
                        return value.y;
                    } else { // interpolate between the cur value and the previous value
                        return (previousValue.y - value.y) / (previousValue.x - value.x)
                                    * (x - value.x) + previousValue.y;
                    }
                }
                previousValue = value;
            }
        }
        return 0;
    }
    
    public PVector[] getTangentsFromT(float splineT) {
        PVector[] tangents = new PVector[2];
        // find the segment number
        int segmentNumber = (int) splineT;
        
        BezierVertex v = vertices.get(segmentNumber + 1);
        BezierVertex v_prev = vertices.get(segmentNumber);

        // calculate the constants
        PVector c = calculateC(v, v_prev);

        PVector b = calculateB(v, v_prev, c);

        PVector a = calculateA(v, v_prev, c, b);

        float t = splineT - segmentNumber;

        tangents[1] = PVector.add(PVector.mult(a, 3.0f * (float) Math.pow(t, 2.0)), PVector.add(PVector.mult(b, 2 * t), c));
        tangents[0] = PVector.mult(tangents[1], -1);

        return tangents;
    }

    PVector calculateC(BezierVertex v, BezierVertex v_prev) {
        return new PVector(3 * (v_prev.t2.x - v_prev.a.x),
                           3 * (v_prev.t2.y - v_prev.a.y));
    }

    PVector calculateB(BezierVertex v, BezierVertex v_prev, PVector c) {
        return new PVector(3 * (v.t1.x - v_prev.t2.x) - c.x,
                           3 * (v.t1.y - v_prev.t2.y) - c.y);
    }

    PVector calculateA(BezierVertex v, BezierVertex v_prev, PVector c, PVector b) {
        return new PVector(v.a.x - v_prev.a.x - c.x - b.x,
                           v.a.y - v_prev.a.y - c.y - b.y);
    }

    // t-value that results in a point with an x-value closest to the value provided
    public float getTFromX(float x) {
        float t = 0;
        float minDelta = 0;
        float minDeltaT = 0;
        if (values.size() > 0) {
            minDelta = Math.abs(values.get(0).x - x);
        }
        for (int i = 1; i < vertices.size(); i++) {
            BezierVertex v_prev = vertices.get(i - 1);
            BezierVertex v = vertices.get(i);

            // calculate the constants
            PVector c = calculateC(v, v_prev);

            PVector b = calculateB(v, v_prev, c);

            PVector a = calculateA(v, v_prev, c, b);

            // find the closest point to the x-value
            float xCoord = 0;
            for (float splineT = 0; splineT <= 1.0; splineT += timeStep) {
                xCoord = (float) (a.x * Math.pow(splineT, 3) + b.x * Math.pow(splineT, 2) + c.x * splineT + v_prev.a.x);
                float delta = Math.abs(xCoord - x);
                if (delta < minDelta) {
                    minDelta = delta;
                    minDeltaT = splineT + i - 1;
                }
            }
        }

        return minDeltaT;
    }


    // getMinimumHandleValues and the maximum version could be combined as
    // an optimization
    public PVector getMinimumHandleValues() {
        if (vertices.size() > 0) {
            BezierVertex firstVertex = vertices.get(0);
            PVector minValues = new PVector(firstVertex.t1().x, firstVertex.t1().y);
            for (BezierVertex v : vertices) {
                if (v.t1().x < minValues.x) {
                    minValues.x = v.t1().x;
                }
                if (v.t2().x < minValues.x) {
                    minValues.x = v.t2().x;
                }
                if (v.t1().y < minValues.y) {
                    minValues.y = v.t1().y;
                }
                if (v.t2().y < minValues.y) {
                    minValues.y = v.t2().y;
                }
            }

            return minValues;
        } else { // shouldn't ever get here
            return new PVector(0, 0);
        }
    }

    public PVector getMaximumHandleValues() {
        if (vertices.size() > 0) {
            BezierVertex firstVertex = vertices.get(0);
            PVector maxValues = new PVector(firstVertex.t1().x, firstVertex.t1().y);
            for (BezierVertex v : vertices) {
                if (v.t1().x > maxValues.x) {
                    maxValues.x = v.t1().x;
                }
                if (v.t2().x > maxValues.x) {
                    maxValues.x = v.t2().x;
                }
                if (v.t1().y > maxValues.y) {
                    maxValues.y = v.t1().y;
                }
                if (v.t2().y > maxValues.y) {
                    maxValues.y = v.t2().y;
                }
            }

            return maxValues;
        } else { // shouldn't ever get here
            return new PVector(0, 0);
        }
    }
}
