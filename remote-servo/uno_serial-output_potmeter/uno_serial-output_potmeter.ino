/********************************************************************************************
 * Modified by:  I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:         Oct. 20, 2025
 * Description:  Code for sending pot meter data to Processing via the serial port
 * Reference:
 *     - Read analog input
 *       https://docs.arduino.cc/tutorials/uno-rev3/AnalogReadSerial/
 *     - Writing data to serial port
 *       https://processing.org/reference/libraries/serial/Serial_write_.html
 *
 ********************************************************************************************/

// analog pin used to connect the potentiometer
int potpin = A0;
// variable to read the value from the analog pin
int val;

void setup() {
  // init serial port
  Serial.begin(9600);
}

// keep last position (angle)
int lastPosition = val;

void loop() {
  // reads the value of the potentiometer (value between 0 and 1023)
  val = analogRead(potpin);
  // scale it for use with the servo (value between 0 and 180)
  val = map(val, 0, 1023, 0, 180);

  // if val is different from lastPosition, set lastPosition as val
  // and send val to serial port
  if (val != lastPosition) {
    lastPosition = val;
    Serial.println(val);
  }

  // waits for the servo to get there
  delay(100);
}
