import java.awt.Color;

Table table;
String[] columnNames = {"timestamp","station id","temperature","humidity"};
String tableLocation = "data.csv";
HashMap<Integer, Float> hueById = new HashMap<Integer, Float>();

int itemSpacing = 10;
int yBeginning = 700;
int xBeginning = 100;
int yEnd = 100;
int xEnd = 700;

int minCircleSize = 1;
int maxCircleSize = 20;

float minTemperature;
float maxTemperature;

float saturation = 1.0f;
float brightness = 1.0f;

void setup() {
  size(800,800);
  table = loadTable(tableLocation, "header");
  colorMode(HSB, 1);
  calculateHues();
}

void draw() {
  drawAxes();
  showData();
  noLoop();
}

void calculateHues() {
  table.sort("station id");
  ArrayList<Integer> stationIds = new ArrayList<Integer>();
  for (TableRow row : table.rows()) {
    int stationId = row.getInt(columnNames[1]);
    if (!stationIds.contains(stationId)) stationIds.add(stationId);
  }
  for (int i = 0; i < stationIds.size(); i++) {
    float stationHue = map(i,0,stationIds.size(),0.0f,1.0f);
    hueById.put(stationIds.get(i), stationHue);
  }
}

void processData(){
}

void showData() {
  table.sort("temperature");
  minTemperature = table.getRow(0).getFloat(columnNames[2]);
  maxTemperature = table.getRow(table.getRowCount() - 1).getFloat(columnNames[2]);
  table.sort("humidity");
  float minHumidity = table.getRow(0).getFloat(columnNames[3]);
  float maxHumidity = table.getRow(table.getRowCount() - 1).getFloat(columnNames[3]);
  table.sort("timestamp");
  int minTS = table.getRow(0).getInt(columnNames[0]);
  int maxTS = table.getRow(table.getRowCount() - 1).getInt(columnNames[0]);
  
  noStroke();
  //create groups for number by group, temp by group, hum by group...
  //int[] groups = {0,0,0,0,0};
  //(maxTS - minTS) / 10;
  System.out.println("showing data");
  for (TableRow row : table.rows()) {
    int timestamp = row.getInt(columnNames[0]);
    int stationId = row.getInt(columnNames[1]);
    float temperature = row.getFloat(columnNames[2]);
    float humidity = row.getFloat(columnNames[3]);
    
    float x = map(timestamp,minTS,maxTS,xBeginning,xEnd);
    float y = map(temperature,minTemperature,maxTemperature,yBeginning,yEnd);
    float circleSize = map(humidity,minHumidity,maxHumidity,minCircleSize,maxCircleSize);
    float hue = hueById.get(stationId);
    fill(hue,saturation,brightness);
    System.out.println(hue);
    circle(x, y, circleSize);
  }
}
void drawAxes() {
  noStroke();
  fill(0,0,1);
  rect(xBeginning,yBeginning,xEnd - xBeginning,yEnd - yBeginning);
  stroke(0,0,0);
  line(xBeginning,yBeginning,xBeginning,yEnd);
  line(xBeginning,yBeginning,xEnd,yBeginning);
  textAlign(CENTER);
  writeAxesNames();
  drawAxesLines();
  //writeAxesNumbers();
}
void writeAxesNames() {
  textSize(16);
  fill(0,0,0);
  text("time (hour)", xBeginning + ((xEnd-xBeginning)/2), yBeginning +((height-yBeginning)/2));
  text("temperature", xBeginning / 2, yEnd +((yBeginning-yEnd)/2));
}
void drawAxesLines() {
  for (int i = 0; i < 25; i ++) {
    int xPosition = xBeginning + ((xEnd-xBeginning)/24)*i;
    line(xPosition,yBeginning + 10,xPosition,yBeginning - 10);
    text(Integer.toString(i), xPosition, yBeginning + 25);
  }
  float range = maxTemperature - minTemperature;
  
  for (float i = minTemperature; i < maxTemperature; i += range/10) {
    float yPosition = yBeginning + ((yBeginning-yEnd)/10)*i;
    line(xBeginning - 10,yPosition,xBeginning + 10,yPosition);
    text(Float.toString(i), xBeginning, yPosition);
  }
}
