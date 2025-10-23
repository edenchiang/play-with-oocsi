/**************************************************************************************************
 * Author:       I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:         Oct. 20, 2025
 * Description:  Code for sending data, which is fetched via the serial port and sent by Arduino
 *               device
 * Reference:
 *     - ChannelSender, the example code in OOCSI library for sending messages
 *     - Reading Serial port as input:
 *          https://processing.org/reference/libraries/serial/Serial_readStringUntil_.html
 *          https://github.com/edenchiang/PlayWithDataFoundry/tree/master/examples/Teensy_ArduinoUNO_with_Processing
 *
 **************************************************************************************************/
import processing.serial.*;
import nl.tue.id.oocsi.*;


// Create object from Serial class
Serial myPort;

// create OOCSI object
OOCSI oocsi;

void setup() {
  // basic setup for canvas
  size(200, 200);
  background(120);

  // get correct port name for creating connection
  String portName = Serial.list()[3];

  // print port name for checking if necessary
  println(portName);

  // init Serial object
  myPort = new Serial(this, portName, 9600);

  // connect to OOCSI server running on the same machine (localhost)
  // with "senderName" to be my channel others can send data to
  // (for more information how to run an OOCSI server refer to: https://iddi.github.io/oocsi/)
  oocsi = new OOCSI(this, "oocsi-sender-agent-uno", "OOCSI_SERVER_URL");
}

void sendMessage(int angle) {
  // send to OOCSI ...
  oocsi
    // on channel "testchannel"...
    .channel("CHANNEL_TO_COMMUNICATE")
    // data labeled "color"...
    .data("angle", angle)
    // send finally
    .send();
}

// continually check serial input and send message to OOCSI if new input happens
void draw() {
  // If data is available in serial port, read it and keep it in val
  if ( myPort.available() > 0) {
    // read the whole line
    String val = myPort.readStringUntil('\n');
    if (val != null) {
      // only send message as val is not null
      // convert val to interger and save it to angle
      int angle = int(val.substring(0, val.length() - 2));

      // send OOCSI message only if the angle changes
      if (angle >= 0 && angle <= 180) {
        sendMessage(int(angle));
      }
    }
  }
}
