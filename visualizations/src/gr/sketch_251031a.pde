
Table data = new Table();

int numberOfStations = 1;
int iterations = 60 * 24;

String[] columnNames = {"time","temp","humid", "outside"};


float[] tempNoiseValues = new float[numberOfStations];
float[] humidityNoiseValues = new float[numberOfStations];

for( int i = 0; i < numberOfStations; i++ ) {
  tempNoiseValues[i] = random(10000);
  humidityNoiseValues[i] = random(10000);
}



for( String columnName : columnNames ) {
  data.addColumn(columnName);
}

for( int i = 0; i < iterations; i++ ) {
  for( int j = 0; j < numberOfStations; j++ ) {
    TableRow newRow = data.addRow();
    newRow.setInt("time", i);   
    float temp = map(noise(tempNoiseValues[j]),0,1,60,80);
    tempNoiseValues[j] += 0.01;
    newRow.setFloat("temp",temp);
    int humidity = int(map(noise(humidityNoiseValues[j]),0,1,20,70));
    humidityNoiseValues[j] += 0.01;    
    newRow.setInt("humid",humidity);
    float outside = map(temp,60,80,0,100);
    newRow.setFloat("outside",outside);

  }
}

saveTable(data, "data.csv");
