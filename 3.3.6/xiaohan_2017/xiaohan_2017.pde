import java.time.*;
import java.time.format.*;
import java.util.Map;

final String CSV_COLUMN_ACTIVITY_NAME = "activityName";
final String CSV_COLUMN_ACTIVITY_START_DATE = "activityStartDate [ms]";
final String CSV_COLUMN_ACTIVITY_END_DATE = "activityEndDate [ms]";

final DateTimeFormatter MD_FORMATTER = DateTimeFormatter.ofPattern("MMMM dd");

final ZoneOffset ZONE_OFFSET_NOW = OffsetDateTime.now().getOffset();

final int PIXELS_PER_MONTH = 1000;

static HashMap<String, Integer> colorMapping = new HashMap();

static {
  colorMapping.put("Other", 0xff800080);
  colorMapping.put("Chores", 0xfff44274);
  colorMapping.put("Eating/Cooking", 0xff64c11d);
  colorMapping.put("Sleep", 0xff222222);
  colorMapping.put("Relaxing/Socializing", 0xff88619f);
  colorMapping.put("Wellness/Exercise", 0xff3b9bcc);
  colorMapping.put("Personal Projects", 0xff32db97);
  colorMapping.put("Gaming", 0xfff5192b);
  colorMapping.put("Work", 0xffffb76e);
}

Table table;

class Activity {
  long startMs;
  long endMs;
  LocalDateTime start;
  LocalDateTime end;
  String name;

  ArrayList<PShape> shapes = new ArrayList();
  PVector startPoint;
  
  Activity(long startMs, long endMs, String name) {
    this.startMs = startMs;
    this.endMs = endMs;
    this.name = name;
    this.start = LocalDateTime.ofEpochSecond(startMs / 1000, 0, ZONE_OFFSET_NOW);
    this.end = LocalDateTime.ofEpochSecond(endMs / 1000, 0, ZONE_OFFSET_NOW);
    
    // turn every day into a separate rect
    int startDayOfYear = start.getDayOfYear();
    int endDayOfYear = end.getDayOfYear();
    
    startPoint = new PVector(
      map(start.getHour() * 60 + start.getMinute(), 0, 60 * 24, 0, width),
      map(startDayOfYear, 0, 30, 0, PIXELS_PER_MONTH)
    );
    
    for (int dayOfYear = startDayOfYear,
             startMinute = start.getHour() * 60 + start.getMinute(),
             endMinute = (endDayOfYear > dayOfYear) ? 24 * 60 : end.getHour() * 60 + end.getMinute()
    ; dayOfYear <= endDayOfYear
    ; startMinute = endMinute % (24 * 60),
      dayOfYear++,
      endMinute = (endDayOfYear > dayOfYear) ? 24 * 60 : end.getHour() * 60 + end.getMinute()
      ) {
      float xStart = map(startMinute, 0, 60 * 24, 0, width);
      float xEnd = map(endMinute, 0, 60 * 24, 0, width);
      float y = map(dayOfYear, 0, 30, 0, PIXELS_PER_MONTH);
      
      PShape rectShape = createShape(RECT, xStart, y, xEnd - xStart, PIXELS_PER_MONTH / 30);
      rectShape.setStroke(255);
      rectShape.setFill(colorMapping.get(name));
      shapes.add(rectShape);
      if (shapes.size() > 2) {
        println(shapes.size(), " - adding", name, "from ", xStart, "to", xEnd, "on y", y);
      }
    }
  }
  
  public String toString() {
    return "Activity [" + name + "](" + start + " to " + end +")";
  }
}

ArrayList<Activity> activities = new ArrayList();

void setup() {
  size(displayWidth, displayHeight);
  table = loadTable("activities.csv", "header");
//  println(table.getRowCount());
//  printArray(table.getColumnTitles());
  for (TableRow row : table.rows()) {
    String name = row.getString(CSV_COLUMN_ACTIVITY_NAME);
    long startMs = row.getLong(CSV_COLUMN_ACTIVITY_START_DATE);
    long endMs = row.getLong(CSV_COLUMN_ACTIVITY_END_DATE);
    activities.add(new Activity(startMs, endMs, name)); 
  }
  textSize(20);
  //printArray(activities);
  //println(System.getProperty("java.version"));
}

int tx = 0;
int ty = 0;
float scale = 1;

void draw() {
  if (keyPressed) {
    if (key == 'a') { tx -= 10; }
    if (key == 'd') { tx += 10; }
    if (key == 'w') { ty -= 10; }
    if (key == 's') { ty += 10; }
  }
  background(0);
  pushMatrix();
  translate(-tx, -ty);
  scale(scale);
  strokeWeight(10);
  for(Activity a : activities) {
    //if (a.shapes.size() < 2) { continue; }
    for (PShape p : a.shapes) { shape(p); }
    textAlign(LEFT, TOP);
    text(a.name + " - " + a.start.format(MD_FORMATTER), a.startPoint.x, a.startPoint.y);
    //text(a.name, a.startPoint.x, a.startPoint.y);
    //return;
  }
  popMatrix();
  
  float untransformedMouseX = (mouseX + tx) / scale;
  int minuteOfDay = (int) map(untransformedMouseX, 0, width, 0, 24 * 60);
  int hours = minuteOfDay / 60;
  int minutes = minuteOfDay - hours * 60;
  textAlign(LEFT, BOTTOM);
  textSize(20);
  text(nf(hours, 2)+":"+nf(minutes, 2), mouseX, mouseY);
  //saveFrame("xiaohan_2017.png");
  //noLoop();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scale *= pow(2, -e / 15);
}