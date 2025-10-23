/**************************************************************************************************
 * Author:      I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:        Oct. 15, 2025
 * Description: This is a simple demo for how OOCSI works, which combines the basic
 *              example of MousePress in Processing and the examples of ChannelSender and
 *              ChannelReceiver in OOCSI library.
 *              Feel free to modify the code as you want! Enjoy.
 * Reference:
 *     - ChannelSender, the example code in OOCSI library for sending messages
 *       https://github.com/iddi/oocsi-processing/tree/master/dist/oocsi/examples/Connectivity/ChannelSender
 *     - ChannelReceiver, the example code in OOCSI library for sending messages
 *       https://github.com/iddi/oocsi-processing/tree/master/dist/oocsi/examples/Connectivity/ChannelReceiver
 *     - MousePress, example code of Processing, where to find: [Example] -> [Basics] -> [Input]
 *     - Processing documentation: https://processing.org/reference
 *
 **************************************************************************************************/

// --- import library, always on top, make sure everything is included
import nl.tue.id.oocsi.*;

// --- initiate OOCSI object, you can do something only if you have the relevant object
OOCSI oocsi;

// --- claim public variables
// cross potition to draw
int cross_X = 0;
int cross_Y = 0;

// cross color
color cross_color;

// is there new data coming in?
boolean hasNewData = false;

// --- setup for the application, run one time only
void setup() {
  // --- drawing stuff
  // canvas size
  size(640, 360);

  // draw jagged edges / fonts / images
  noSmooth();

  // color for filling shapes
  fill(126);

  // background color
  background(102);

  // --- OOCSI stuff
  // oocsi = new OOCSI(this, OOCSI-AGENT-IN-SERVER, SERVER-URL);
  // connect to an agent named "OOCSI-AGENT-IN-SERVER" in OOCSI server, the name should be unique!
  oocsi = new OOCSI(this, "cross-agent-YOUR-LOVELY-NAME-WITH-DASH-MAYBE", "OOCSI-SERVER-URL");

  // subscribe / listen to the specific channel and setup the handler for incoming data from the channel
  // you can subscribe / listen to multiple channles at the same time!
  oocsi.subscribe("CHANNEL-TO-COMMUNICATE", "handleOOCSIEvent");
}

// --- nonstop running after setup finished
void draw() {
  if (hasNewData) {
    // if has new data coming in
    // will draw lines with cross_color
    stroke(cross_color);

    // reset new data checker
    hasNewData = false;

    // print text in console window, good for debugging
    // println("new data");
  } else {
    // if no new datacoming in
    if (mousePressed) {
      // if mouse is pressed
      // will draw lines with white color
      stroke(255);

      // update the center of the cross
      cross_X = mouseX;
      cross_Y = mouseY;

      // send message to OOCSI
      sendMessage();
    } else {
      // draw nothing (transparent) as nothing happens
      // stroke(RGB, ALPHA);
      stroke(0, 0);
    }
  }

  // draw lines at the cross center
  line(cross_X-66, cross_Y, cross_X+66, cross_Y);
  line(cross_X, cross_Y-66, cross_X, cross_Y+66);
}

// --- handler for incoming data (callback)
void handleOOCSIEvent(OOCSIEvent event) {
  // incoming data check
  String mouseContent = event.getInt("mouseX", 0) + ", " +
    event.getInt("mouseY", 0) + ", " +
    event.getInt("color-R", 0) + ", " +
    event.getInt("color-G", 0) + ", " +
    event.getInt("color-B", 0) + ", " +
    event.getInt("color-L", 0);

  // print incoming data in console window
  println(mouseContent);

  // assign the new y position from the OOCSI event
  cross_X = event.getInt("mouseX", 0);

  // assign the new y position from the OOCSI event
  cross_Y = event.getInt("mouseY", 0);

  // assign the stroke color for cross with the new data from OOCSI event
  cross_color = color(event.getInt("color-R", 0), event.getInt("color-G", 0), event.getInt("color-B", 0), event.getInt("color-L", 0));

  // yes, we got new data
  hasNewData = true;
}

// --- send to OOCSI ...
void sendMessage() {
  oocsi
    // on channel "some_secrete_channel_name_you_want"...
    .channel("CHANNEL-TO-COMMUNICATE")
    // data labeled "mouseX"...
    .data("mouseX", mouseX)
    // data labeled "mouseY"...
    .data("mouseY", mouseY)
    // data labeled "color-R"...
    .data("color-R", 34)
    // data labeled "color-G"...
    .data("color-G", 199)
    // data labeled "color-B"...
    .data("color-B", 99)
    // data labeled "color-L", alpha value of the color
    .data("color-L", 255)
    // send finally
    .send();
}
