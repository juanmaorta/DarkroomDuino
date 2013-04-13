/*
 * This file is part of DarkroomDuino
 *
 *
 */
 

// Runs the controller
void controller_run(){
   int key = keyboard_waitForAnyKey();
  switch (key) {
    case NO_KEY:
      StateMachine.transitionTo(Idle);
      break;
    case KEY_EXPOSE:
      StateMachine.transitionTo(Expose);
      break;
    case KEY_FOCUS:
      StateMachine.transitionTo(Focus);
      break;
    case KEY_UP:
      StateMachine.transitionTo(IncreaseTime);
      break;
    case KEY_DOWN:
      StateMachine.transitionTo(DecreaseTime);
      break;
  }
  StateMachine.update();
}

// State machine utility functions

void idle() {
  /*
  LcdClearLine(0);
  lcd.cursorTo(0,0);
  lcd.printIn("Idle");
  */
  lcd.cursorTo(0,15);
 lcd.printIn("_"); 
  LcdPrintTime(baseTime);

}

void increaseTime() {
  btn_click();
  if (baseTime < 100) {
    baseTime++;
  }
  StateMachine.transitionTo(Idle);
}

void decreaseTime() {
  btn_click();
  if (baseTime > 0) {
    baseTime--;
  }
  StateMachine.transitionTo(Idle);
}

void focus() {
    btn_click();
    if (StateMachine.isInState(Idle) || StateMachine.isInState(Focus)) {
      if (relayState == LOW) {
        cur_mode = MODE_FOCUS;
        digitalWrite(RELAY_PIN,HIGH);
        relayState = HIGH;
        LcdClearLine(0);
        lcd.cursorTo(0,0);
        lcd.printIn("Focus");
         LcdClearLine(2);
      } else {
        cur_mode = MODE_NONE;
        digitalWrite(RELAY_PIN,LOW);
        LcdClearLine(0);
        relayState = LOW;
      }
    }
}

void expose() {
  btn_click();
  if (StateMachine.isInState(Idle) || StateMachine.isInState(Expose)) {
     if (relayState == LOW) {
        cur_mode = MODE_EXPOSE;
        digitalWrite(RELAY_PIN,HIGH);
        relayState = HIGH;
        LcdClearLine(0);
        lcd.cursorTo(0,0);
        lcd.printIn("Expose");
        int cur_time = baseTime; 
        LcdPrintTime(cur_time);
      } else {
        cur_mode = MODE_NONE;
        digitalWrite(RELAY_PIN,LOW);
        LcdClearLine(0);
        LcdClearLine(2);
        relayState = LOW;
      }
    }
}

/*
void set_expose_mode() {
    btn_click();
    if (cur_mode == MODE_NONE || cur_mode == MODE_EXPOSE) {
      
      if (relayState == LOW) {
        cur_mode = MODE_EXPOSE;
        digitalWrite(RELAY_PIN,HIGH);
        relayState = HIGH;
        LcdClearLine(0);
        lcd.cursorTo(0,0);
        lcd.printIn("Expose");

      } else {
        cur_mode = MODE_NONE;
        digitalWrite(RELAY_PIN,LOW);
        LcdClearLine(0);
        LcdClearLine(2);
        relayState = LOW;
      }
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
*/


void up() {}

void down() {}

void modo() {
  btn_click();
}
