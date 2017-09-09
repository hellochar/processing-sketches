package timeline;
import timelinedata.visitor.*;
import timeline.tool.*;
import timelinedata.syntaxtree.*;
import processing.core.PVector;

/**
 * Visits a timeline datafile AST and generates a Timeline object specified
 * by the data
 */
public class TimelineImporterVisitor extends GJVoidDepthFirst<VisitorInfo> {
    Timeline timeline = new Timeline();

    public void visit(Variable n, VisitorInfo info) {
        String name = n.identifier.nodeToken.tokenImage;
        TimelineVariable timelineVariable = new TimelineVariable(timeline, name);
        n.nodeList.accept(this, new VisitorInfo(timelineVariable));
        timeline.addNewVariable(timelineVariable);
        //timeline.timelineVariables.add(timelineVariable);
        timelineVariable.spline.update();
    }

    public void visit(Vertex n, VisitorInfo info) {
        info.timelineVariable.spline.vertices.add(
                new BezierVertex(
                    new PVector(fpLiteralToFloat(n.floatingPointLiteral),
                                fpLiteralToFloat(n.floatingPointLiteral1)),
                    new PVector(fpLiteralToFloat(n.floatingPointLiteral2),
                                fpLiteralToFloat(n.floatingPointLiteral3)),
                    new PVector(fpLiteralToFloat(n.floatingPointLiteral4),
                                fpLiteralToFloat(n.floatingPointLiteral5))  ));
    }

    float fpLiteralToFloat(FloatingPointLiteral fp) {
        return Float.parseFloat(fp.nodeToken.tokenImage);
    }
}

class VisitorInfo {
    public TimelineVariable timelineVariable;
    VisitorInfo(TimelineVariable variable) {
        this.timelineVariable = variable;
    }
}
