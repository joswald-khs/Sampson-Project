JSONArray data;
float[] temps, hums;
int[] rooms;

void setup() {
  size(800, 500);
  data = loadJSONArray("data.json");

  int n = data.size();
  temps = new float[n];
  hums = new float[n];
  rooms = new int[n];

  for (int i = 0; i < n; i++) {
    JSONObject entry = data.getJSONObject(i);
    rooms[i] = entry.getInt("station_id");
    temps[i] = entry.getFloat("temperature");
    hums[i] = entry.getFloat("humidity");
  }
}

void draw() {
  background(255);
  drawAxes();
  drawLines();
  drawHoverInfo();
}

void drawAxes() {
  stroke(0);
  line(80, 420, 700, 420); // X-axis
  line(80, 60, 80, 420);   // Left Y-axis (Temp)
  line(700, 60, 700, 420); // Right Y-axis (Humidity)

  fill(0);
  textAlign(CENTER);
  text("Room", 390, 460);
  textAlign(CENTER, CENTER);
  text("Temperature (°C)", 30, 240);
  text("Humidity (%)", 760, 240);
}

void drawLines() {
  float minTemp = min(temps);
  float maxTemp = max(temps);
  float minHum = min(hums);
  float maxHum = max(hums);

  int n = temps.length;
  float xStep = (700 - 80) / float(n - 1);

  noFill();

//Temperature line (red)
  stroke(255, 0, 0);
  beginShape();
  for (int i = 0; i < n; i++) {
    float x = 80 + i * xStep;
    float y = map(temps[i], minTemp, maxTemp, 420, 60);
    vertex(x, y);
  }
  endShape();

// Humidity line (blue)
  stroke(0, 0, 255);
 beginShape();
  for (int i = 0; i < n; i++) {
    float x = 80 + i * xStep;
     float y = map(hums[i], minHum, maxHum, 420, 60);
   vertex(x, y);
  }
  endShape();

// X-axis labels
  fill(0);
  textAlign(CENTER);
  for (int i = 0; i < n; i++) {
    float x = 80 + i * xStep;
    text(rooms[i], x, 440);
  }
}

void drawHoverInfo() {
  float minTemp = min(temps);
  float maxTemp = max(temps);
  float minHum = min(hums);
  float maxHum = max(hums);
  float xStep = (700 - 80) / float(temps.length - 1);

  for (int i = 0; i < temps.length; i++) {
    float x = 80 + i * xStep;
    float yTemp = map(temps[i], minTemp, maxTemp, 420, 60);
    float yHum = map(hums[i], minHum, maxHum, 420, 60);

    if (dist(mouseX, mouseY, x, yTemp) < 8) {
      fill(255, 200, 200);
      stroke(200, 0, 0);
      ellipse(x, yTemp, 10, 10);
      fill(0);
      textAlign(LEFT);
      text("Temp: " + nf(temps[i], 1, 1) + "°C (Room " + rooms[i] + ")", mouseX + 10, mouseY - 10);
    }

    if (dist(mouseX, mouseY, x, yHum) < 8) {
      fill(200, 200, 255);
      stroke(0, 0, 200);
      ellipse(x, yHum, 10, 10);
      fill(0);
      textAlign(LEFT);
      text("Hum: " + nf(hums[i], 1, 1) + "% (Room " + rooms[i] + ")", mouseX + 10, mouseY - 10);
    }
  }
}
