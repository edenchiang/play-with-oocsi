/********************************************************************************************
 * Author:       I-Tang (Eden) Chiang <edenchiang12657@gmail.com>
 * Date:         Oct. 28, 2025
 * Description:  Code for receiving data from OOCSI and send the angle data to Arduino UNO
 *               via the serial port, and the UNO move servo to the specific angle
 * Reference:
 *     - Reading data from serial port
 *       https://processing.org/reference/libraries/serial/Serial_readStringUntil_.html
 *     - Moving servo
 *       https://docs.arduino.cc/learn/electronics/servo-motors/
 *     - Read analog input
 *       https://docs.arduino.cc/tutorials/uno-rev3/AnalogReadSerial/
 *     - Writing data to serial port
 *       https://processing.org/reference/libraries/serial/Serial_write_.html
 *
 ********************************************************************************************/
// include servo library
#include <Servo.h>

// create Servo object to control a servo
Servo myservo;

// analog pin used to connect the potentiometer
int potpin = A0;
// variable to read the value from the analog pin
int val;

// build-in LED setup
unsigned long LEDMS = 0;

// last angle from serial port
int lastAngle = 0;

// flow control
bool hasSerialInput = false;
unsigned long lastSerialInputMS = 0;

void setup() {
  // opens serial port, sets data rate to 9600 bps
  Serial.begin(9600);
  lastSerialInputMS = millis();

  // init build-in LED
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  LEDMS = millis();

  // init servo, link it to pin 9
  myservo.attach(9);
}

void loop() {

  // triggered as serial port has something is coming in (from Processing)
  while (Serial.available() > 0) {
    // keep builtin LED HIGH for remote mode
    digitalWrite(LED_BUILTIN, HIGH);

    // read incoming data as integer
    int angle = Serial.read();

    // if angle is different from lastAngle, set lastAngle as angle
    // and move servo to angle
    if (lastAngle != angle) {
      // move servo
      myservo.write(angle);
      // update lastAngle
      lastAngle = angle;
      // update lastSerialInputMS
      lastSerialInputMS = millis();
      // switch to remote mode
      hasSerialInput = true;
    }
  }

  // if nothing is coming in over 3 seconds, seitch back to local mode
  if (hasSerialInput && (millis() - lastSerialInputMS) >= 3000) {
    // switch to local mode
    hasSerialInput = false;
    // check potentiometer and move servo if necessary
    checkVal();
  }

  // check only if it's in local mode
  if (!hasSerialInput) {
    // toggle LED for loca mode
    toggleLED();
    // check potentiometer and move servo if necessary
    checkVal();
  }

  // waits for the servo to get there
  delay(100);
}

// read potentiometer as val and interact with servo if the value is different from lastAngle
void checkVal() {
  // reads the value of the potentiometer (value between 0 and 1023)
  val = analogRead(potpin);
  // scale it for use with the servo (value between 0 and 180)
  val = map(val, 0, 1023, 0, 180);

  // if val is different from lastPosition, set lastPosition as val
  // and send val to serial port
  if (val != lastAngle) {
    lastAngle = val;
    myservo.write(val);
    Serial.println(val);
  }
}

// toggle LED status every 250ms
void toggleLED() {
  unsigned long curMS = millis();
  if (curMS - LEDMS > 250) {
    digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
    LEDMS = curMS;
  }
}