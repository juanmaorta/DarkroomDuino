#include <Wire.h>
#include <LCDI2C4Bit.h>


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

const int RELAY_PIN =  13;      // the number of the LED pin

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

// Execution modes
#define NO_MODE              0 // No mode selected
#define F_STOP_STRIP         1 // F-Stop strip test

// Variables will change:
int ledState = HIGH;         // the current state of the output pin
int buttonState;             // the current reading from the input pin
int cur_mode = NO_MODE;

// LCD
int ADDR = 0xA7;
byte x = 0;
byte data = 1;
byte c;
LCDI2C4Bit lcd = LCDI2C4Bit(ADDR,4,20);

void setup() {
  Wire.begin(); // join i2c bus (address optional for master)
  
  // initialize the LED pin as an output:
  pinMode(RELAY_PIN, OUTPUT);
  
  // initialize the pushbutton pin as an input:
  for (int i=0; i < NUM_BUTTONS; i++) {
    pinMode(buttons[i], INPUT);
  }
  
  lcd.init();
  lcd.backLight(true);
  lcd.clear();
  
  lcd.cursorTo(0,0);
  lcd.printIn("DkroomDuino 0.1");
  lcd.cursorTo(2,0);
  lcd.printIn("Bienvenido!");
  delay(2000);
  lcd.clear();
  lcd.cursorTo(0,0);
  lcd.printIn("Pulsa una tecla");
  lcd.cursorTo(2,0);
  // Serial.begin(9600);
}

void loop() {
  int key = scanKeyboard();
  // char[] msg = "";
  
  if (key > NO_KEY) {
    LcdClearLine(2);
    lcd.cursorTo(2,0);

    switch (key) {
      case KEY_CANCEL:
        cancel();
        break;
      case KEY_MODE:
        modo();
        break;
      case KEY_LEFT:
        lcd.printIn("Left");
        break;
      case KEY_UP:
        lcd.printIn("Up");
        break;
      case KEY_DOWN:
        lcd.printIn("Down");
        break;
      case KEY_RIGHT:
        lcd.printIn("Right");
        break;
      case KEY_FOCUS:
        focus();
        break;
      case KEY_GO:
        lcd.printIn("Go!");
        break;
    }
  }
  
  if (cur_mode != 0) {
    // LcdClearLine(2);
    // lcd.cursorTo(2,0);
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
    // Serial.print("Pulsado boton: ");
    // Serial.println(times);
    // for (int i = 0; i < times; i++) {
       digitalWrite(RELAY_PIN, HIGH);
       delay(200);
       digitalWrite(RELAY_PIN, LOW);
       delay(200);
    // }
     // pressed = false;
}

void LcdClearLine(int r) {
  lcd.cursorTo(r,0);
  for (int i = 0; i < 16; i++) {
    lcd.printIn(" ");
  }
}

void focus() {
  // light_on
  lcd.printIn("Focus");
  digitalWrite(RELAY_PIN, HIGH);
  /*
  if (light_on) {
    digitalWrite(RELAY_PIN, HIGH);
    light_on = false;
  } else {
    digitalWrite(RELAY_PIN, HIGH);
    light_on = true;
  }
  */
}

void modo() {
  LcdClearLine(0);
  lcd.cursorTo(0,0);
  lcd.printIn("Modo");
  cur_mode = F_STOP_STRIP;
  LcdClearLine(2);
  lcd.cursorTo(2,0);
  lcd.printIn("2 4 8 16 32 64");
}

void cancel() {
  LcdClearLine(2);
  lcd.cursorTo(2,0);  
  lcd.printIn("Cancelando ...");
  digitalWrite(RELAY_PIN, LOW);
  delay(1000);
}
