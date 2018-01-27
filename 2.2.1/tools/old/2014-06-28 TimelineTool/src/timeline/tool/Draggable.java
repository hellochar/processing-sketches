package timeline.tool;

import processing.core.PApplet;
import processing.core.PVector;

public interface Draggable {
    int getIndex();
    PVector getCoords();
    float getRadius();
    void dragged(float x, float y, boolean modifierOn, Timeline.Mode mode);
    void pressed(float x, float y, boolean modifierOn, Timeline.Mode mode);
    boolean hasSquareHandle();
    boolean hasCircleHandle();
    void drawExtras(PApplet applet, TimelineVariable timeline); // anything extra the draggable might want to draw
                                                                // (useful for tangents to draw lines, etc)
    void delete(PApplet applet);
}
