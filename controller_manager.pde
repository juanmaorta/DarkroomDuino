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
      idle();
      break;
    case KEY_EXPOSE:
      expose();
      break;
    case KEY_FOCUS:
      focus();
      break;
  }
  
  if (cur_mode == MODE_EXPOSE) {
     // keeps timer
     int finaltime = countdown(baseTime);
     if (finaltime == 0) {
       set_expose_mode();

      digitalWrite(BUZZER_PIN, HIGH);
      delay(40);
      digitalWrite(BUZZER_PIN, LOW);
      delay(100);
      digitalWrite(BUZZER_PIN, HIGH);
      delay(40);
      digitalWrite(BUZZER_PIN, LOW);

      baseStep ++;
     
     } else {
       // Serial.println(finaltime);
       // LcdPrintStep(baseStep);
       LcdPrintTime(finaltime);
     }
  }
}

void idle() {
   if (cur_mode == MODE_IDLE) {
     LcdClearLine(0);
     lcd.cursorTo(0,15);
     lcd.printIn("_");
     LcdPrintTime(baseTime);
   }
}

void focus() {
    btn_click();
    if (cur_mode == MODE_IDLE || cur_mode == MODE_FOCUS) {
      if (relayState == LOW) {
        cur_mode = MODE_FOCUS;
        digitalWrite(RELAY_PIN,HIGH);
        relayState = HIGH;
        LcdClearLine(0);
        lcd.cursorTo(0,0);
        lcd.printIn("Focus");
         LcdClearLine(2);
      } else {
        cur_mode = MODE_IDLE;
        digitalWrite(RELAY_PIN,LOW);
        LcdClearLine(0);
        relayState = LOW;
      }
    }
}

void expose() {
  float cur_time = baseTime; 
  LcdPrintTime(cur_time);
}

void set_expose_mode() {
    btn_click();
    if (cur_mode == MODE_IDLE || cur_mode == MODE_EXPOSE) {
      if (relayState == LOW) {
        cur_mode = MODE_EXPOSE;
        digitalWrite(RELAY_PIN,HIGH);
        relayState = HIGH;
        LcdClearLine(0);
        lcd.cursorTo(0,0);
        lcd.printIn("Exposing");
      } else {
        cur_mode = MODE_IDLE;
        digitalWrite(RELAY_PIN,LOW);
        LcdClearLine(0);
        LcdClearLine(2);
        relayState = LOW;
        limitMillis = 0;
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
  if (baseTime < 100000.00) {
    baseTime += 1000.00;
  }
}

void down() {
  btn_click();
  if (baseTime > 0) {
    baseTime -= 1000.00;
  }
}

void modo() {
  btn_click();
}

float countdown(float seconds) {
  float currentMillis = millis();
  // unsigned int limitMillis = seconds * 1000;
  if (limitMillis == 0) {
    limitMillis = currentMillis + seconds;
  }
  if (currentMillis >= limitMillis) {
    return 0; 
  } else {
    return limitMillis - currentMillis;
  }
}
