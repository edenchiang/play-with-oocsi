# Remote Servo Controller

A demo of controlling a servo remotely with a pot meter via Arduino Uno, OOCSI, and Processing app.

## Setup

### Hardware

- Arduino UNO x 2
- Potential meter x 1
- Servo x 1
- Capacitor x 1, 25V 100uF (optional)
- Jumper wires x n
- Breadboards x 2 (max)

### Software

- [Arduino IDE](https://www.arduino.cc/en/software/) 2.3.4 or later, but not 2.3.5
- [Processing 4.4.8](https://processing.org/) or later version
- [OOCSI library](https://github.com/iddi/oocsi-processing)

### Configuration

- URL of OOCSI server
- Channel of OOCSI for communication
- Unique OOCSI agent name
- **COM port name for serial communication**, this can be checked in Processing app

## FAQ

- Nothing happened to my servo?

  Few things to check:

  - First thing to check is make sure the Processing apps are communicating via the **same channel**!!

  - Second, check the **COM port**, make sure the COM ports for each Arduino board is the same as linked in eash Processing app.

  - Third, check the type of the data as reading messages from OOCSI, in this case, it should be an int.

## Reference

- [ChannelSender](https://github.com/iddi/oocsi-processing/tree/master/dist/oocsi/examples/Connectivity/ChannelSender), the example code in OOCSI library for sending messages
- [ChannelReceiver](https://github.com/iddi/oocsi-processing/tree/master/dist/oocsi/examples/Connectivity/ChannelReceiver), the example code in OOCSI library for sending messages
- [Serial port check in Processing app](https://processing.org/reference/libraries/serial/Serial_list_.html)
- [Writing data to serial port with Arduino UNO](https://processing.org/reference/libraries/serial/Serial_write_.html)
- [Reading data from serial port with Arduino UNO](https://processing.org/reference/libraries/serial/Serial_readStringUntil_.html)
