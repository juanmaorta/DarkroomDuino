/*
 * This file is part of DarkroomDuino
 *
 *
 */
 
 // Runs the controller
 
// Runs the controller
void controller_run(){
   int key = keyboard_waitForAnyKey();
  switch (key) {
    case NO_KEY:
      if (cur_mode == MODE_NONE) {
        LcdPrintTime(baseTime);
      }
      break;
    case KEY_EXPOSE:
      expose();
      break;
    case KEY_FOCUS:
      focus();
      break;
  }
}

void focus() {
    btn_click();
    if (cur_mode == MODE_NONE || cur_mode == MODE_FOCUS) {
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
  int cur_time = baseTime; 
  LcdPrintTime(cur_time);
}

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
