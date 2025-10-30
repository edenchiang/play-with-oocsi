import nl.tue.id.oocsi.*;

/**************************************************************************************************
 * Author:      I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:        Oct. 15, 2025
 * Description: This is the receiver part of a simple demo for how OOCSI works, which combines the 
 *              basic example of MousePress in Processing and the examples of ChannelSender and 
 *              ChannelReceiver in OOCSI library. 
 *              Feel free to modify the code as you want! Enjoy.
 * Reference:
 *     - ChannelReceiver, the example code in OOCSI library for sending messages
 *       https://github.com/iddi/oocsi-processing/tree/master/dist/oocsi/examples/Connectivity/ChannelReceiver
 *     - MousePress, example code of Processing, where to find: [Example] -> [Basics] -> [Input]
 *     - Processing documentation: https://processing.org/reference
 *
 **************************************************************************************************/

int mouseX_in = 0;
int mouseY_in = 0;
color cross_color;
boolean hasNewData = false;

void setup() {
  size(640, 360);
  noSmooth();
  fill(126);
  background(102);
  //frameRate(10);

  // connect to OOCSI server running on the same machine (localhost)
  // with "receiverName" to be my channel others can send data to
  // (for more information how to run an OOCSI server refer to: https://iddi.github.io/oocsi/)
  OOCSI oocsi = new OOCSI(this, "cross-receiver-agent", "OOCSI_SERVER_URL");

  // subscribe to channel "CHANNEL_TO_COMMUNICATE" with handler method "handleOOCSIEvent"
  oocsi.subscribe("CHANNEL_TO_COMMUNICATE", "handleOOCSIEvent");
  // ... or the handler method name can be the same as channel name, for example:
  // oocsi.subscribe("testchannel", "testchannel");
}

void draw() {
  if (hasNewData) {
    // if there is new data coming in, set color according to the data, and 
    // reset "hasNewData" for accepting new data
    stroke(cross_color);
    hasNewData = false;
  }

  // draw cross
  line(mouseX_in-66, mouseY_in, mouseX_in+66, mouseY_in);
  line(mouseX_in, mouseY_in-66, mouseX_in, mouseY_in+66);
}

// handler method
void handleOOCSIEvent(OOCSIEvent event) {
  // check incoming data
  String mouseContent = event.getInt("mouseX", 0) + ", " +
    event.getInt("mouseY", 0) + ", " +
    event.getInt("color-R", 0) + ", " +
    event.getInt("color-G", 0) + ", " +
    event.getInt("color-B", 0) + ", " +
    event.getInt("color-L", 0);

  // show the data in console
  println(mouseContent);

  // assign the new X position by the incoming data
  mouseX_in = event.getInt("mouseX", 0);

  // assign the new Y position by the incoming data
  mouseY_in = event.getInt("mouseY", 0);

  // assign the new fill color (RGBA values) of cross by incoming data
  cross_color = color(event.getInt("color-R", 0), event.getInt("color-G", 0), event.getInt("color-B", 0), event.getInt("color-L", 0));

  // set "hasNewData" to true to set color and draw cross in draw()
  hasNewData = true;
}
