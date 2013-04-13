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

/*
// Execution modes
#define NO_MODE              0 // No mode selected
#define F_STOP_STRIP         1 // F-Stop strip test

// Variables will change:

int buttonState;             // the current reading from the input pin
int cur_mode = NO_MODE;
*/
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
  
  lcd.clear();
}

void loop() {
   int key = scanKeyboard();
  if (key == 0) {
      // LcdClearLine(2);
      lcd.cursorTo(2,7);
      char c[20];
      
      sprintf(c, "%3d.0 sec", baseTime);
      
      lcd.printIn(c); 
  }
}

void focus() {
    btn_click();
    if (relayState == LOW) {
      digitalWrite(RELAY_PIN,HIGH);
      relayState = HIGH;
      LcdClearLine(0);
      lcd.cursorTo(0,0);
      lcd.printIn("Focus");
       LcdClearLine(2);
    } else {
      digitalWrite(RELAY_PIN,LOW);
      LcdClearLine(0);
      relayState = LOW;
    } 
}

void expose() {
    btn_click();
    if (relayState == LOW) {
      digitalWrite(RELAY_PIN,HIGH);
      relayState = HIGH;
      LcdClearLine(0);
      lcd.cursorTo(0,0);
      lcd.printIn("Expose");
    } else {
      digitalWrite(RELAY_PIN,LOW);
      LcdClearLine(0);
      LcdClearLine(2);
      relayState = LOW;
    } 
}

void cancel() {
  // btn_click(); 
  LcdClearLine(0);   
  digitalWrite(RELAY_PIN,LOW);
  if (relayState == HIGH) {
    digitalWrite(BUZZER_PIN, HIGH);
    delay(40);
    digitalWrite(BUZZER_PIN, LOW);
  } else {
    btn_click(); 
  }
  relayState = LOW;
}

void btn_click() {
    digitalWrite(BUZZER_PIN, HIGH);
    delay(CLICK_LENGTH);
    digitalWrite(BUZZER_PIN, LOW);  
}

int scanKeyboard() {
  int key = NO_KEY;
  if(focus_btn.uniquePress()){
    focus();
    key = KEY_FOCUS;
  }
  
  if(expose_btn.uniquePress()){
    expose();
    key = KEY_EXPOSE;
  }
  
  if(up_btn.uniquePress()){
    up();
    key = KEY_UP;
  }
  
  if(down_btn.uniquePress()){
    down();
    key = KEY_DOWN;
  }
  
  if(mode_btn.uniquePress()){
    modo();
    key = KEY_MODE; 
  }
  return key;
}

void LcdClearLine(int r) {
  lcd.cursorTo(r,0);
  for (int i = 0; i < 16; i++) {
    lcd.printIn(" ");
  }
}

void up() {
  btn_click();
  if (baseTime < 100) {
    baseTime++;
  }
}

void down() {
  btn_click();
  if (baseTime > 0) {
    baseTime--;
  }
}

void modo() {
  btn_click();
}
