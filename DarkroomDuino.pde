  /*
  Button
 
 Turns on and off a light emitting diode(LED) connected to digital  
 pin 13, when pressing a pushbutton attached to pin 2. 
 
 
 The circuit:
 * LED attached from pin 13 to ground 
 * pushbutton attached to pin 2 from +5V
 * 10K resistor attached to pin 2 from ground
 
 * Note: on most Arduinos there is already an LED on the board
 attached to pin 13.
 
 
 created 2005
 by DojoDave <http://www.0j0.org>
 modified 28 Oct 2010
 by Tom Igoe
 
 This example code is in the public domain.
 
 http://www.arduino.cc/en/Tutorial/Button
 */

// constants won't change. They're used here to 
// set pin numbers:

// Buttons pinout
#define PINS_BTN_MODE           9  //(digital pin)
#define PINS_BTN_LEFT           2  //(digital pin)
#define PINS_BTN_UP             3  //(digital pin)
#define PINS_BTN_DOWN           4  //(digital pin)
#define PINS_BTN_RIGHT          5  //(digital pin)
#define PINS_BTN_CANCEL         6  //(digital pin)
#define PINS_BTN_FOCUS          7  //(digital pin)
#define PINS_BTN_GO             8  //(digital pin)

const int buttons[] = {
  PINS_BTN_MODE,
  PINS_BTN_LEFT,
  PINS_BTN_UP,
  PINS_BTN_DOWN,
  PINS_BTN_RIGHT,
  PINS_BTN_CANCEL,
  PINS_BTN_FOCUS,
  PINS_BTN_GO
};

// number of buttons
#define NUM_BUTTONS             8

const int ledPin =  13;      // the number of the LED pin

// Keycodes
#define NO_KEY               0 // No keys pressed
#define KEY_MODE             1 // Mode button pressed
#define KEY_LEFT             2 // Left button pressed
#define KEY_UP               3 // Up button pressed
#define KEY_DOWN             4 // Down button pressed
#define KEY_RIGHT            5 // Right button pressed
#define KEY_CANCEL           6 // Cancel button pressed
#define KEY_FOCUS            7 // Focus pressed
#define KEY_GO               8 // Go button pressed

// Variables will change:
int ledState = HIGH;         // the current state of the output pin
int buttonState;             // the current reading from the input pin

void setup() {
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
  
  // initialize the pushbutton pin as an input:
  for (int i=0; i < NUM_BUTTONS; i++) {
    pinMode(buttons[i], INPUT);
  }
  Serial.begin(9600);
}

void loop() {
  int key = scanKeyboard();
  
  if (key > NO_KEY) {
    if (key == KEY_CANCEL) {
      Serial.println("Cancela!");
    } else {
      blink(key);
    }
  }
    
}

int scanKeyboard() {
  int key = 0;
  for (int i= 0; i < NUM_BUTTONS; i++) {
    buttonState = digitalRead(buttons[i]);
    if (buttonState == 1) {
      key = i+1;
    }
  }
  return key;
}

void blink(int times) {
    Serial.print("Pulsado boton: ");
    Serial.println(times);
    // for (int i = 0; i < times; i++) {
       digitalWrite(ledPin, HIGH);
       delay(200);
       digitalWrite(ledPin, LOW);
       delay(200);
    // }
     // pressed = false;
}
