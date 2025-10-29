/**************************************************************************************************
 * Author:       I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:         Oct. 28, 2025
 * Description:  Sample code for reading data, which is fetched via the serial port and sent by
 *               Arduino devices
 * Reference:
 *     - ChannelReceiver, the example code in OOCSI library for receiving messages
 *     - ChannelSender, the example code in OOCSI library for sending messages
 *     - Code for writing data to serial port:
 *          https://processing.org/reference/libraries/serial/Serial_write_.html
 *     - Reading Serial port as input:
 *          https://processing.org/reference/libraries/serial/Serial_readStringUntil_.html
 *          https://github.com/edenchiang/PlayWithDataFoundry/tree/master/examples/Teensy_ArduinoUNO_with_Processing
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
  noStroke();

  // get correct port name for creating connection
  String portName = Serial.list()[2];

  // print port name for checking if necessary
  println(portName);

  // init Serial object
  myPort = new Serial(this, portName, 9600);

  // connect to OOCSI server running on the same machine (localhost)
  // with "receiverName" to be my channel others can send data to
  // (for more information how to run an OOCSI server refer to: https://iddi.github.io/oocsi/)
  oocsi = new OOCSI(this, "UNIQUE_NAME_FOR_OOCSI_AGENT_####", "OOCSI_SERVER_DOMAIN_NAME");

  // subscribe to channel "data-from-uno" and deal with the data incoming to the channel with
  // event handler of "OOCSIEventHandler". The channel name and handler name are of course
  // free to change, but always remember to update the handler function name, ...
  oocsi.subscribe("UNIQUE_CHANNEL_NAME_HERE", "OOCSIEventHandler");
  println();
}

void sendMessage(int angle) {
  // send to OOCSI ...
  oocsi
    // on channel "testchannel"...
    .channel("UNIQUE_CHANNEL_NAME_HERE")
    // data labeled "angle"...
    .data("angle", angle)
    // send finally
    .send();
}

// mode control: local or remote, default for local mode
boolean hasNewData = false;
// angle comparison
int lastAngle = 0;

void draw() {
  // If data is available in serial port, read it and keep it in val
  if ( myPort.available() > 0) {
    // read the whole line
    String val = myPort.readStringUntil('\n');
    if (val != null && !hasNewData) {

      // only send message as val is not null
      // convert val to interger and save it to angle
      int angle = int(val.substring(0, val.length() - 2));

      // send OOCSI message only if the angle changes
      if (angle >= 0 && angle <= 180) {
        sendMessage(int(angle));
        lastAngle = angle;
        println("pot angle: " + angle);
      }
    }
  }
  delay(100);
}


// OOCSI event handler, triggered as a new message is sending into the channel
void OOCSIEventHandler(OOCSIEvent event) {

  // read angle from incoming data
  int angle = event.getInt("angle", 0);
  println("event angle: " + angle);
  println("lastAngle: " + lastAngle);
  
  // update angle if it's different from lastAngle
  if (lastAngle != angle) {
    // switch to remote mode
    hasNewData = true;
    // update lastAngle
    lastAngle = angle;

    // write angle to serial port (Arduino UNO)
    myPort.write(angle);
    
    // switch mode to local
    hasNewData = false;
  }
}
