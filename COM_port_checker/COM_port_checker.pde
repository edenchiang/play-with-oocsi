/**************************************************************************************************
* Description:  Sample code for checking COM ports
* Reference: https://processing.org/reference/libraries/serial/Serial_list_.html
**************************************************************************************************/
//Example by Tom Igoe
import processing.serial.*;

// The serial port
Serial myPort;       

// List all the available serial ports
printArray(Serial.list());
