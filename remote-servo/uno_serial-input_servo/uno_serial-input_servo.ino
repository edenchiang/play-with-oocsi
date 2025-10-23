/********************************************************************************************
 * Author:       I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:         Oct. 20, 2025
 * Description:  Code for receiving data from OOCSI and send the angle data to Arduino UNO 
 *               via the serial port, and the UNO move servo to the specific angle
 * Reference:
 *     - Reading data from serial port
 *       https://processing.org/reference/libraries/serial/Serial_readStringUntil_.html
 *     - Moving servo
 *       https://docs.arduino.cc/learn/electronics/servo-motors/
 *
 ********************************************************************************************/
 // include servo library
 #include <Servo.h>

// create Servo object to control a servo
Servo myservo;

// last angle from serial port
int lastAngle = 0;

void setup() {
  // opens serial port, sets data rate to 9600 bps
  Serial.begin(9600);

  // init servo, link it to pin 9
  myservo.attach(9);
}

void loop() {

  // triggered as serial port has something is coming in
  while (Serial.available() > 0) {

    // read incoming data as integer
    int angle = Serial.read();

    // if angle is different from lastAngle, set lastAngle as angle
    // and move servo to angle
    if (lastAngle != angle) {
      myservo.write(angle);
      lastAngle = angle;
    }
  }
}