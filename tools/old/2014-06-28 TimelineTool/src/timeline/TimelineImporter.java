package timeline;

import java.io.File;
import java.io.InputStream;
import timeline.tool.Timeline;
import timeline.tool.TimelineVariable;
import timelinedata.syntaxtree.*;

public class TimelineImporter {
    static TimelineDataParser parser = null;

    public static Timeline importTimeline(String filename) {
        if (parser == null) {
            parser = new TimelineDataParser(processing.core.PApplet.createInput(new File(filename)));
        } else {
            parser.ReInit(processing.core.PApplet.createInput(new File(filename)));
        }
        try {
            Goal g = parser.Goal();
                TimelineImporterVisitor importerVisitor = new TimelineImporterVisitor();
                g.accept(importerVisitor, null);
                return importerVisitor.timeline;

        } catch(ParseException pe) {
            System.out.println("Bad timeline data file");
            return null;
       }
    }
}
