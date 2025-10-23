import nl.tue.id.oocsi.*;

/**************************************************************************************************
 * Author:      I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:        Oct. 15, 2025
 * Description: This is the sender part of a simple demo for how OOCSI works, which combines the 
 *              basic example of MousePress in Processing and the examples of ChannelSender and 
 *              ChannelReceiver in OOCSI library. 
 *              Feel free to modify the code as you want! Enjoy.
 * Reference:
 *     - ChannelSender, the example code in OOCSI library for sending messages
 *       https://github.com/iddi/oocsi-processing/tree/master/dist/oocsi/examples/Connectivity/ChannelSender
 *     - MousePress, example code of Processing, where to find: [Example] -> [Basics] -> [Input]
 *     - Processing documentation: https://processing.org/reference
 *
 **************************************************************************************************/

OOCSI oocsi;

void setup() {
  size(640, 360);
  noSmooth();
  fill(126);
  background(102);

  // connect to OOCSI server running on the same machine (localhost)
  // with "senderName" to be my channel others can send data to
  // (for more information how to run an OOCSI server refer to: https://iddi.github.io/oocsi/)
  oocsi = new OOCSI(this, "cross-sender-agent", "OOCSI_SERVER_URL");
}

void sendMessage() {
  // send to OOCSI ...
  oocsi
    // on channel "testchannel"...
    .channel("CHANNEL_TO_COMMUNICATE")
    // data labeled "color"...
    .data("mouseX", mouseX)
    // data labeled "position"...
    .data("mouseY", mouseY)
    .data("color-R", 255)
    .data("color-G", 255)
    .data("color-B", 255)
    // brightness
    .data("color-L", 255)
    // send finally
    .send();
}

void draw() {
  if (mousePressed) {
    stroke(255);
    sendMessage();
  } else {
    stroke(0);
  }
  line(mouseX-66, mouseY, mouseX+66, mouseY);
  line(mouseX, mouseY-66, mouseX, mouseY+66);
}
