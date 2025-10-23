/********************************************************************************************
 * Modified by:   I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:          Nov. 20, 2025
 * Description:   Controlling a servo position using a potentiometer (variable resistor)
 *                by Michal Rinott <http://people.interaction-ivrea.it/m.rinott>
 * Reference:
 *                modified on 8 Nov 2013
 *                by Scott Fitzgerald
 *                http://www.arduino.cc/en/Tutorial/Knob
 *
 ********************************************************************************************/

#include <Servo.h>

Servo myservo;  // create Servo object to control a servo

int potpin = A0;  // analog pin used to connect the potentiometer
int val;          // variable to read the value from the analog pin

void setup() {
  Serial.begin(9600);
  myservo.attach(9);  // attaches the servo on pin 9 to the Servo object
}

int lastPosition = val;
void loop() {
  // reads the value of the potentiometer (value between 0 and 1023)
  val = analogRead(potpin);
  // scale it for use with the servo (value between 0 and 180)
  val = map(val, 0, 1023, 0, 180);

  // if val is different from lastPosition, set lastPosition as val
  // and send val to serial port
  if (val != lastPosition) {
    // sets the servo position according to the scaled value
    myservo.write(val);
    lastPosition = val;
    Serial.println(val);
  }

  // waits for the servo to get there
  delay(100);
}
