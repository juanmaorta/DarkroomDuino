
#include <TimerOne.h>
#include <Button.h>

#include <Wire.h>
#include <LCDI2C4Bit.h>


// constants won't change. They're used here to 
// set pin numbers:

// Buttons pinout
#define PINS_BTN_MODE           9  //(digital pin)

#define PINS_BTN_incr_up           2  //(digital pin)
#define PINS_BTN_incr_down         3  //(digital pin)

#define PINS_BTN_UP             4  //(digital pin)
#define PINS_BTN_DOWN           5  //(digital pin)

// #define PINS_BTN_CANCEL         6  //(digital pin)
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
#define KEY_incr_up             2 // Left button pressed
#define KEY_UP               3 // Up button pressed
#define KEY_DOWN             4 // Down button pressed
#define KEY_incr_down            5 // Right button pressed
#define KEY_CANCEL           6 // Cancel button pressed
#define KEY_FOCUS            7 // Focus pressed
#define KEY_EXPOSE           8 // Expose button pressed

// Execution modes
#define MODE_IDLE     0 // No mode selected
#define MODE_FOCUS    1 // Focus
#define MODE_EXPOSE   2 // Expose

int cur_mode = MODE_IDLE;
volatile int current_key = NO_KEY;

// Variables will change:

// int buttonState;             // the current reading from the input pin

boolean SERIAL_DEBUG = true;
boolean welcome_beep = true;
int relayState = LOW;         // the current state of the output pin

float baseTime = 2 * 1000.0;        // initial base time (ms)
volatile float expTime = baseTime;
volatile float prevExpTime = baseTime;
volatile int baseStep = 1;

// LCD
int ADDR = 0xA7;
byte x = 0;
byte data = 1;
byte c;

LCDI2C4Bit lcd = LCDI2C4Bit(ADDR,4,20);

Button mode_btn = Button(PINS_BTN_MODE,PULLDOWN);

Button incr_up_btn = Button(PINS_BTN_incr_up,PULLDOWN);
Button incr_down_btn = Button(PINS_BTN_incr_down,PULLDOWN);

Button up_btn = Button(PINS_BTN_UP,PULLDOWN);
Button down_btn = Button(PINS_BTN_DOWN,PULLDOWN);

Button focus_btn = Button(PINS_BTN_FOCUS,PULLDOWN);
Button expose_btn = Button(PINS_BTN_GO,PULLDOWN);

Button keys[7] = {up_btn, down_btn, focus_btn, mode_btn, expose_btn, incr_up_btn, incr_down_btn};

float limitMillis = 0;
float time_increase = 1000; // countdown interval (miliseconds)


// el cálculo de la razón es 2 elevado a 1/3 para incrementos de 1/3

// steps: 1, 1/2, 1/3
double steps[5] = {2, 1.414213562, 1.25992105, 1.189207115, 1.122462048 };
char* stepStrings[]={"1/1", "1/2", "1/3", "1/4", "1/6"};

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

  Timer1.initialize(20000);
  Timer1.attachInterrupt(scanKeyboard);
  
  pinMode(PINS_BTN_FOCUS, INPUT);
}

void scanKeyboard() {
  // int key = NO_KEY;
  
  if(focus_btn.uniquePress()){
    current_key = KEY_FOCUS;
    focus();
  } else if (expose_btn.uniquePress()){
    // set_expose_mode();
    current_key = KEY_EXPOSE;
    set_expose_mode();
    // btn_click();
  } else if(up_btn.uniquePress()){
    // time_up();
    current_key = KEY_UP;
    // btn_click();
  } else if(down_btn.uniquePress()){
    // time_down();
    current_key = KEY_DOWN;
    // btn_click();
  } else if(mode_btn.uniquePress()){
    // modo();
    // btn_click();
    current_key = KEY_MODE; 
  } else if (incr_up_btn.uniquePress()) {
    // btn_click();
    current_key = KEY_UP;
  } else if (incr_down_btn.uniquePress()) {
    // btn_click();
    current_key = KEY_DOWN;
  } else {
    current_key = NO_KEY;
  }
  
  
  /*
  switch (current_key) {
    case NO_KEY:
      idle();
      break;
    case KEY_EXPOSE:
      expose();
      break;
    case KEY_FOCUS:
      focus();
      break;
  }
  */
  
  
}

void loop() {
  if (current_key != NO_KEY) {
    btn_click();
    lcd.cursorTo(0,0);
    char c[20];
    sprintf(c, "k: %02d", current_key);
    lcd.printIn(c);
    
    char d[20];
    sprintf(d, " mode: %02d", cur_mode);
    lcd.printIn(d);
  }
  // LcdPrintTime(expTime);
  // controller_run();
}
