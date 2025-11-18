#include <temp_pb.h>

#include <pb_common.h>
#include <pb.h>
#include <pb_encode.h>
#include <pb_decode.h>


void setup(){...}
void loop() {
...
long timestamp = millis()
  Serial.println("reading humidity/temp...");
  float hum = dht.readHumidity();
  float tmp = dht.readTemperature();
  float hiCel = dht.computeHeatIndex(tmp, hum, false);
    
  pb_TempEvent temp = pb_TempEvent_init_zero;
  temp.deviceId = 12;
  temp.eventId = 100;
  temp.humidity = hum;
  temp.tempCel = tmp;
  temp.heatIdxCel = hiCel;
  
  sendTemp(temp);
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
