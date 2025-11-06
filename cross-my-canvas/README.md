# Cross Together

A playful Processing app for experiencing OOCSI service

All the users who subscribe and send messages to the same channel can put their customized crosses on everyone's canvas like they are crossing on the same canvas.

<br />

## Setup

### Environment

- [Processing 4.4.8](https://processing.org/) or later version
- [OOCSI library](https://github.com/iddi/oocsi-processing)

### Processing app configuration

Change the following settings in the code, and remember to keep the double quotes for strings:

- Channel of OOCSI for communication: **"CHANNEL-TO-COMMUNICATE"**
- URL of OOCSI server: **"OOCSI-SERVER-URL"**
- Unique OOCSI agent name: **"cross-agent-YOUR-LOVELY-NAME-WITH-DASH-MAYBE"**
- RGBA values of chosen color (These are numbers!! No double quotes are required.)

<br />

## How to use

### I. Centralize mode

In centralize mode, all the crosses with customized color will be sent to the canvas of receiver app from all users (sender). 

On sender side, they have only their own crosses on the canvas. 

On receiver side, all the crosses will overlap to each other on the canvas.

- Files

  - Sender side: `mouse_press_sender`
  - Receiver side: `mouser_press_receiver`

### II. Discreate mode

In this mode, all users will get crosses from all the other users in their own canvas.

Everyone just have to open the Processing file and run, then the crosses will pop up on every canvas.

- File

  - `mouse_press_sender_receiver_sync`

<br />

## Reference

- [ChannelSender](https://github.com/iddi/oocsi-processing/tree/master/dist/oocsi/examples/Connectivity/ChannelSender), the example code in OOCSI library for sending messages
- [ChannelReceiver](https://github.com/iddi/oocsi-processing/tree/master/dist/oocsi/examples/Connectivity/ChannelReceiver), the example code in OOCSI library for sending messages
- MousePress, example code of Processing, find it here: **[Example] -> [Basics] -> [Input]**
- [Processing official documentation](https://processing.org/reference)
