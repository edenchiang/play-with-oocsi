/**************************************************************************************************
* Author:       I-Tang(Eden) Chiang <i.chiang@tue.nl>
* Date:         Oct. 16, 2025
* Description:  Sample code for checking COM ports
**************************************************************************************************/
import processing.serial.*;

// Create object from Serial class
Serial myPort;

//  Data received from the serial port
String val;

void setup()
{
  // this is the list of ports, not the exact port number, so try to change the index 0 to 1 or 2 etc. 
  // to match the port of the machine if it replies the error message for missing port.
  for (int i = 0; i < Serial.list().length; i++) {
    println("index: " + i + ", port: " + Serial.list()[i]);
  }
}

void draw()
{
  // no drawing
}
