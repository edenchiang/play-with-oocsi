import nl.tue.id.oocsi.*;

/**************************************************************************************************
 * Author:       I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:         Oct. 20, 2025
 * Description:  Code for sending data continually for testing the receiver side.
 * Reference:
 *     - ChannelSender, the example code in OOCSI library for sending messages
 *     - Reading Serial port as input:
 *          https://processing.org/reference/libraries/serial/Serial_readStringUntil_.html
 *          https://github.com/edenchiang/PlayWithDataFoundry/tree/master/examples/Teensy_ArduinoUNO_with_Processing
 *
 **************************************************************************************************/

OOCSI oocsi;
int[] angles = {0, 30, 60, 120, 150, 180};

void setup() {
  size(200, 200);
  background(120);

  // connect to OOCSI server running on the same machine (localhost)
  // with "senderName" to be my channel others can send data to
  // (for more information how to run an OOCSI server refer to: https://iddi.github.io/oocsi/)
  oocsi = new OOCSI(this, "auto-sender-counter", "OOCSI_SERVER_URL");
}

int counter = 0;
void draw() {
  // send to OOCSI ...
  oocsi
    // on channel "testchannel"...
  .channel("CHANNEL_TO_COMMUNICATE")
    // data labeled "color"...
    .data("angle", angles[counter])
      // data labeled "position"...
      //.data("position", mouseY)
        // send finally
        .send();

  if (counter < 5)  counter++;
  else  counter = 0;
  delay(1000);
}
