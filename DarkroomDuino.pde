#include <Button.h>

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


int button_pins[5] = { PINS_BTN_UP, PINS_BTN_DOWN, PINS_BTN_MODE, PINS_BTN_FOCUS, PINS_BTN_GO };
int num_buttons = 5;


const int RELAY_PIN =  11;      // the number of the LED pin
const int BUZZER_PIN =  12;      // the number of the LED pin
const int CLICK_LENGTH = 1; // miliseconds for click audio feedback


// Keycodes
#define NO_KEY               0 // No keys pressed
#define KEY_MODE             1 // Mode button pressed
#define KEY_LEFT             2 // Left button pressed
#define KEY_UP               3 // Up button pressed
#define KEY_DOWN             4 // Down button pressed
#define KEY_RIGHT            5 // Right button pressed
#define KEY_CANCEL           6 // Cancel button pressed
#define KEY_FOCUS            7 // Focus pressed
#define KEY_EXPOSE           8 // Expose button pressed

// Execution modes
#define MODE_IDLE     0 // No mode selected
#define MODE_FOCUS    1 // Focus
#define MODE_EXPOSE   2 // Expose

int cur_mode = MODE_IDLE;

// Variables will change:

// int buttonState;             // the current reading from the input pin

boolean SERIAL_DEBUG = true;
int welcome_beep = true;
int relayState = LOW;         // the current state of the output pin

int baseTime = 16;        // initial base time (ms)

// LCD
int ADDR = 0xA7;
byte x = 0;
byte data = 1;
byte c;

LCDI2C4Bit lcd = LCDI2C4Bit(ADDR,4,20);

Button up_btn = Button(PINS_BTN_UP,PULLDOWN);
Button down_btn = Button(PINS_BTN_DOWN,PULLDOWN);

Button focus_btn = Button(PINS_BTN_FOCUS,PULLDOWN);
Button mode_btn = Button(PINS_BTN_MODE,PULLDOWN);
Button expose_btn = Button(PINS_BTN_GO,PULLDOWN);

Button keys[5] = {up_btn, down_btn, focus_btn, mode_btn, expose_btn};

float limitMillis = 0;
long time_increase = 1000; // countdown interval (miliseconds)

void setup() {
  Wire.begin(); // join i2c bus (address optional for master)
 
  // initialize output pins
  pinMode(RELAY_PIN, OUTPUT);
  pinMode(BUZZER_PIN, OUTPUT);

  lcd.init();
  lcd.backLight(true);
  lcd.clear();

  // Welcome message and beeps  
  lcd.cursorTo(0,0);
  lcd.printIn("DkroomDuino 0.1");
  lcd.cursorTo(2,0);
  lcd.printIn("Ready!");
  delay(1820);

  if (welcome_beep) {
    digitalWrite(BUZZER_PIN, HIGH);
    delay(40);
    digitalWrite(BUZZER_PIN, LOW);
    delay(100);
    digitalWrite(BUZZER_PIN, HIGH);
    delay(40);
    digitalWrite(BUZZER_PIN, LOW);
  }
  
  if (SERIAL_DEBUG) {
     Serial.begin(115200); 
  }
  lcd.clear();
}

void loop() {
  controller_run();
}
