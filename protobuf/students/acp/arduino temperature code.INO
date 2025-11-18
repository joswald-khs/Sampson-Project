#include <temp.pb.h>

#include <pb_common.h>
#include <pb.h>
#include <pb_encode.h>
#include <pb_decode.h>
#include <Modulino.h>

// Create object instance
ModulinoThermo thermo;

// Global Variables
float celsius = 0;
float humidity = 0;

void setup(){
  // Initialization of the serial port, modulino object and thermo one

  Serial.begin(115200);
  Modulino.begin();
  thermo.begin();
}

void loop(){
  celsius = thermo.getTemperature();
  humidity = thermo.getHumidity();

  Serial.print("Temperature (C) is: ");
  Serial.println(celsius);

  Serial.print("Humidity (rH) is: ");
  Serial.println(humidity);
  pb_TempEvent temp = pb_TempEvent_init_zero;
  temp.deviceId = 12;
  temp.eventId = 100;
  temp.humidity = hum;
  temp.tempCel = tmp;
  temp.heatIdxCel = hiCel;
  sendTemp(temp);

  delay(1000);
}

void sendTemp(pb_TempEvent e) {
  uint8_t buffer[128];
  pb_ostream_t stream = pb_ostream_from_buffer(buffer, ...);
  
  if (!pb_encode(&stream, pb_TempEvent_fields, &e)){
    Serial.println("failed to encode temp proto");
    return;
  }
  client.write(buffer, stream.bytes_written);
}


// }

// #include <DHT.h>
// #include <ESP8266WiFi.h>WiFiClient client;const char* ssid     = "<SSID-Name>";
// const char* password = "<WIFI Pwd>";
// const char* addr     = "<Server-IP";
// const uint16_t port  = 10101;void setup(){...}void loop() {
// ...
//   Serial.println("reading humidity/temp...");
//   float hum = dht.readHumidity();
//   float tmp = dht.readTemperature();
//   float hiCel = dht.computeHeatIndex(tmp, hum, false);
    

  
// }
