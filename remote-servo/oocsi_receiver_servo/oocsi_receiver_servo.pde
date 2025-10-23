/**************************************************************************************************
 * Author:       I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:         Oct. 20, 2025
 * Description:  Code to read data, which is fetched via OOCSI service, and send the angle data to
 *               Arduino via serial port for moving servo motor
 * Reference:
 *     - ChannelReceiver, the example code in OOCSI library for receiving messages
 *     - Code for writing data to serial port:
 *          https://processing.org/reference/libraries/serial/Serial_write_.html
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
  oocsi = new OOCSI(this, "oocsi-receiver-agent-uno", "OOCSI_SERVER_URL");

  // subscribe to channel "data-from-uno" and deal with the data incoming to the channel with
  // event handler of "OOCSIEventHandler". The channel name and handler name are of course
  // free to change, but always remember to update the handler function name, ...
  oocsi.subscribe("CHANNEL_TO_COMMUNICATE", "OOCSIEventHandler");
}

void draw() {
  // optional to do something here
}

// last angle
int lastAngle = 0;

// OOCSI event handler, triggered as a new message is sending into the channel
void OOCSIEventHandler(OOCSIEvent event) {
  // read angle from incoming data
  int angle = event.getInt("angle", 0);

  // update angle if it's different from lastAngle
  if (lastAngle != angle) {
    lastAngle = angle;
    println("angle: " + angle);

    // write angle to serial port (Arduino UNO)
    myPort.write(angle);
  }
}
