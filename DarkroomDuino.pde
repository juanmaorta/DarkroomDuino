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

// Variables will change:
int ledState = HIGH;         // the current state of the output pin
int buttonState;             // the current reading from the input pin
int lastButtonState = LOW;   // the previous reading from the input pin

// the following variables are long's because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long lastDebounceTime = 0;  // the last time the output pin was toggled
long debounceDelay = 50;    // the debounce time; increase if the output flickers

int reading = LOW;

void setup() {
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
  
  // initialize the pushbutton pin as an input:
  for (int i=0; i < NUM_BUTTONS; i++) {
    pinMode(buttons[i], INPUT);
  }
}

void loop() {
  // read the state of the pushbutton value:
  for (int i = 0; i < NUM_BUTTONS; i++) {
    buttonState = digitalRead(buttons[i]);
  
    // check if the pushbutton is pressed.
    // if it is, the buttonState is HIGH:
    if (buttonState == HIGH) {     
      // turn LED on:    
      digitalWrite(ledPin, HIGH);
      delay(200);
      digitalWrite(ledPin, LOW);
      break;
    }
  }
}

/*
int scanKeyboard() {
  int key = 0;
  for (int i= 0; i < NUM_BUTTONS; i++) {
    
    buttonState = digitalRead(buttons[i]);
    Serial.print(buttonSt);
    if (buttonState == 1) {
      // pressed = true;
      // digitalWrite(ledPin, HIGH);
      // delay(200);
      // digitalWrite(ledPin, LOW);
      key = i+1;
      // break;
    }
  }
  
  return key;
}

void blink(int times) {
    // Serial.println("Pulsado boton " + times); 
    // for (int i = 0; i < times; i++) {
       digitalWrite(ledPin, HIGH);
       delay(200);
       digitalWrite(ledPin, LOW);
       // delay(200);
     // }
     // pressed = false;
}
*/
