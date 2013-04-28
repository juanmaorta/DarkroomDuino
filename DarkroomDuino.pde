
#include <MsTimer2.h>
#include <Button.h>

#include <Wire.h>
#include <LCDI2C4Bit.h>


// constants won't change. They're used here to 
// set pin numbers:

// Buttons pinout
#define PINS_BTN_status           2    //(digital pin)

#define PINS_BTN_INCR_UP          5  //(digital pin)
#define PINS_BTN_OK               6  //(digital pin)

#define PINS_BTN_UP               3  //(digital pin)
#define PINS_BTN_DOWN             4  //(digital pin)

#define PINS_BTN_FOCUS            7  //(digital pin)
#define PINS_BTN_GO               8  //(digital pin)


int button_pins[5] = { PINS_BTN_UP, PINS_BTN_DOWN, PINS_BTN_status, PINS_BTN_FOCUS, PINS_BTN_GO };
int num_buttons = 5;


const int RELAY_PIN =     11;      // the number of the LED pin
const int BUZZER_PIN =    12;     // the number of the LED pin

const int CLICK_LENGTH =  1;     // miliseconds for click audio feedback


#define MAJOR_VERSION 0
#define MINOR_VERSION 1

// Keycodes
#define NO_KEY               0 // No keys pressed
#define KEY_MODE             1 // Mode button pressed
#define KEY_INCR_UP          2 // Left button pressed
#define KEY_UP               3 // Up button pressed
#define KEY_DOWN             4 // Down button pressed
#define KEY_OK               5 // Right button pressed
#define KEY_FOCUS            7 // Focus pressed
#define KEY_EXPOSE           8 // Expose button pressed

#define BUTTON_HOLD_TIME     150 // Time to hold up/down buttons to get multiple press

// Execution statuses
#define STATUS_IDLE     0 // No mode selected
#define STATUS_FOCUS    1 // Focus
#define STATUS_EXPOSE   2 // Expose

// Execution modes
#define PRINT_MODE  0
#define TEST_MODE   1

volatile int cur_status = STATUS_IDLE;
volatile int last_status = STATUS_IDLE;
volatile int current_key = NO_KEY;
volatile int last_key = NO_KEY;

boolean SERIAL_DEBUG = true;
boolean WELCOME_BEEP = true;
int relayState = LOW;                                 // the current state of the output pin


// Exposure parameters
const int start_time = 8;
volatile float baseTime = start_time * 1000.0;        // initial base time (ms)
volatile float expTime = baseTime;
volatile float prevExpTime = baseTime;
volatile int baseStep = 1;
float limitMillis = 0;
float time_increase = 1000;                           // countdown interval (miliseconds)



// LCD
int ADDR = 0xA7;
byte x = 0;
byte data = 1;
byte c;

LCDI2C4Bit lcd = LCDI2C4Bit(ADDR,4,20);

// Buttons
Button mode_btn = Button(PINS_BTN_status,PULLDOWN);
Button incr_up_btn = Button(PINS_BTN_INCR_UP,PULLDOWN);
Button ok_btn = Button(PINS_BTN_OK,PULLDOWN);
Button up_btn = Button(PINS_BTN_UP,PULLDOWN);
Button down_btn = Button(PINS_BTN_DOWN,PULLDOWN);
Button focus_btn = Button(PINS_BTN_FOCUS,PULLDOWN);
Button expose_btn = Button(PINS_BTN_GO,PULLDOWN);

Button keys[7] = {up_btn, down_btn, focus_btn, mode_btn, expose_btn, incr_up_btn, ok_btn};




// el cálculo de la razón es 2 elevado a 1/3 para incrementos de 1/3

// steps: 1, 1/2, 1/3
double steps[5] = {2, 1.414213562, 1.25992105, 1.189207115, 1.122462048 };
char* stepStrings[]={"1/1", "1/2", "1/3", "1/4", "1/6"};

int modes[] = {PRINT_MODE, TEST_MODE};
char* modeStrings[] = {"Print     ","Test strip"};
int cur_mode = modes[0];
int last_mode = cur_mode;


volatile int currentIncr = 2;
volatile double factor = steps[currentIncr];
// volatile char* lblIncr = stepStrings[currentIncr];


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
  lcd.printIn("DkroomDuino ");
  char c[2];
  sprintf(c, "%01d.%01d", MAJOR_VERSION, MINOR_VERSION);
  lcd.printIn(c); 

  lcd.cursorTo(2,0);
  lcd.printIn("Ready!");
  delay(1820);

  if (WELCOME_BEEP) {
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

  MsTimer2::set(50, scanKeyboard);
  MsTimer2::start();

  // prints mode label
  lcd.cursorTo(0,0);
  lcd.printIn(modeStrings[0]);
  LcdPrintTime(baseTime);
}

void loop() {
  if (last_status != cur_status) {
    switch (cur_status) {
      case STATUS_FOCUS:
        digitalWrite(RELAY_PIN,HIGH);
        lcd.clear();
        lcd.cursorTo(2,0);
        lcd.printIn("Focus");
        break;
      case STATUS_EXPOSE:
        // digitalWrite(RELAY_PIN,HIGH);
        lcd.cursorTo(2,0);
        if (cur_mode == TEST_MODE) {
          LcdPrintStep(baseStep);
        } else {
          // lcd.printIn("Exp...");
        }
        break;
      case STATUS_IDLE:
        digitalWrite(RELAY_PIN,LOW);
        lcd.clear();
        lcd.cursorTo(0,0);
        lcd.printIn(modeStrings[0]);
        LcdPrintTime(expTime);
        break;
    }
    last_status = cur_status;
  }
  if (cur_status == STATUS_IDLE) {
    lcd.cursorTo(0,0);
    lcd.printIn(modeStrings[cur_mode]);

    if (cur_mode == PRINT_MODE) {
      LcdPrintTime(baseTime);
      baseStep = 1;
      expTime = baseTime;
      prevExpTime = baseTime;
     } else {
      if (baseStep > 1) {
        // LcdPrintTime(expTime);
      } else {
        LcdPrintTime(baseTime);
      }
    }

    if (cur_mode == TEST_MODE) {
      LcdPrintInc();
    } else {
      lcd.cursorTo(0,13);
      lcd.printIn("   ");
      lcd.cursorTo(2,0);
      lcd.printIn("     ");
    }
  }

  if (cur_status == STATUS_EXPOSE) {
    digitalWrite(RELAY_PIN,HIGH);
    // keeps timer
    int finaltime = countdown(expTime);
    if (finaltime == 0) {
      cur_status = STATUS_IDLE;
      digitalWrite(RELAY_PIN,LOW);

      limitMillis = 0;

      digitalWrite(BUZZER_PIN, HIGH);
      delay(40);
      digitalWrite(BUZZER_PIN, LOW);
      delay(100);
      digitalWrite(BUZZER_PIN, HIGH);
      delay(40);
      digitalWrite(BUZZER_PIN, LOW);

      if (cur_mode == TEST_MODE) {
        baseStep ++;
        double term = getTerm((int)baseTime, factor, baseStep);
      
        expTime = term - prevExpTime;
        prevExpTime = term;
      }

    } else {
      // no es final, sigue el timer
      if (cur_mode == TEST_MODE) {
        LcdPrintStep(baseStep);
      }
      LcdPrintTime(finaltime);
    }
  }
}
