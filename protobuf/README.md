# Sources

* [Modulino Thermo Tutorial](https://courses.arduino.cc/plugandmake/lessons/modulino-thermo/)
* [_Efficient IoT with the ESP8266, Protocol Buffers..._](https://medium.com/grpc/efficient-iot-with-the-esp8266-protocol-buffers-grafana-go-and-kubernetes-a2ae214dbd29)
* [Author's project GitHub](https://github.com/vladimirvivien/iot-dev/tree/master/esp8266/esp8266-dht11-temp) (for more detailed information)
* [Arduino API](https://docs.arduino.cc/learn/programming/reference/)

The first thing we needed to do was define our event properties and generate our `.proto` file: 

```C
syntax = "proto2";

message TempEvent {
    required uint32 deviceId = 1;
    required uint32 timestamp = 2;
    required bool status = 3;
    
    required float temp = 4;
    required float humidity = 5;
    required uint32 batteryLevel = 6;
}
```

This file is used to generate code that both our arduino will use to send gRPC messages and for the server to receive and parse those messages. We spent a lot of time getting those various libraries in place so that we could add the following lines to our program.

```C
#include <temp.pb.h>

#include <pb_common.h>
#include <pb.h>
#include <pb_encode.h>
#include <pb_decode.h>
```

We also learned how to setup our Modulino devices and sensors. 

```C
// other includes 
#include <Modulino.h>

// Create object instance
ModulinoThermo thermo;

void setup() {
  Serial.begin(9600);

  // Call all necessary .begin() function
  Modulino.begin();
  thermo.begin();
}

void loop() {
  float celsius = thermo.getTemperature();
  float fahrenheit = (celsius * 9 / 5) + 32;
  float humidity = thermo.getHumidity();
  // code to send messages
}
```

We then had to assemble our message object and pass it along to the function that transmitted the message. We used the following code as an example, but we need to adapt it to our own message. 

```C
// ... setup code
void loop() {
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
```
