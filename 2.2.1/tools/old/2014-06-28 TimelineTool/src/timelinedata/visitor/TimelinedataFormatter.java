package timelinedata.visitor;

import timelinedata.syntaxtree.*;

public class TimelinedataFormatter extends TreeFormatter {
    public TimelinedataFormatter() {
        super(2, 0);
    }

    public void visit(NodeToken n) {
        super.visit(n);
            // add a space after each token
        add(space());
    }

    public void visit(Goal n) {
        n.nodeOptional.accept(this);
        add(force());
        n.nodeListOptional.accept(this);
    }

    public void visit(Option n) {
        super.visit(n); add(force());
    }

    public void visit(Variable n) {
        n.nodeToken.accept(this);
        n.identifier.accept(this);
        add(indent());
        add(force());
        n.nodeList.accept(this);
        add(outdent());
        add(force());

    }

    public void visit(Vertex n) {
        super.visit(n);
        add(force());
    }

}
