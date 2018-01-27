package timeline;

import processing.core.PVector;

public class BezierVertex {
    public PVector a;  // anchor
    public PVector t1; // tangent 1 (incoming)
    public PVector t2; // tangent 2 (leaving)

    /**
     * This flag will be used to indicate when an anchor point does not have
     * active tangents (i.e., when tangents are too close to the anchor, they
     * will disappear until the magical tangent creation tool -- which does
     * not yet exist -- is used).
     */
    public boolean hasT1 = true;
    public boolean hasT2 = true;

    public BezierVertex(PVector a, PVector t1, PVector t2) {
        this.a = a;
        this.t1 = t1;
        this.t2 = t2;
    }

    BezierVertex(float x, float y) {
        a = new PVector(x, y);
        t1 = new PVector(x-0.001f, y);
        t2 = new PVector(x+0.001f, y);
    }

    /**
     * Getter for the t1 vector
     * @return t1 if this vertex has a t1, the value of anchor otherwise
     */
    public PVector t1() {
        if (hasT1) {
            return t1;
        } else {
            return new PVector(a.x, a.y);
        }
    }

    /**
     * Getter for the t2 vector
     * @return t2 if this vertex has a t2, the value of anchor otherwise
     */
    public PVector t2() {
        if (hasT2) {
            return t2;
        } else {
            return new PVector(a.x, a.y);
        }
    }

    // safe setters, only sets tangents if they exist
    public void setT1(float x, float y) {
        if (hasT1) {
            t1.x = x;
            t1.y = y;
        }
    }

    public void setT2(float x, float y) {
        if (hasT2) {
            t2.x = x;
            t2.y = y;
        }
    }
}
