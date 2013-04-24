/*
 * This file is part of DarkroomDuino
 *
 *
 */

#include <math.h>
 
 // Runs the controller
 
// Runs the controller
void controller_run(){
  int key = current_key;
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
  
  if (cur_status == STATUS_EXPOSE) {
    // keeps timer
    int finaltime = countdown(expTime);
    if (finaltime == 0) {
      set_expose_status();

      digitalWrite(BUZZER_PIN, HIGH);
      delay(40);
      digitalWrite(BUZZER_PIN, LOW);
      delay(100);
      digitalWrite(BUZZER_PIN, HIGH);
      delay(40);
      digitalWrite(BUZZER_PIN, LOW);

      baseStep ++;
      double term = getTerm((int)baseTime, factor, baseStep);
      
      expTime = term - prevExpTime;
      prevExpTime = term;

      // no puedes sustituir baseTime, si no, no calcurá bien el 
      // term. Hay que exponer usando otra variable y baseTime dejarla fija
      // baseTime = term - baseTime;
    } else {
      // Serial.println(finaltime);
      LcdPrintStep(baseStep);
      LcdPrintTime(finaltime);
    }
  }
}

void idle() {
   if (cur_status == STATUS_IDLE) {
     LcdClearLine(0);
     lcd.cursorTo(0,15);
     lcd.printIn("_");
     LcdPrintTime(expTime);
     LcdPrintInc();
   }
}

void focus() {
    if (cur_status == STATUS_IDLE || cur_status == STATUS_FOCUS) {
      if (relayState == LOW) {
        cur_status = STATUS_FOCUS;
        digitalWrite(RELAY_PIN,HIGH);
        relayState = HIGH;
        // LcdClearLine(0);
        
        // lcd.cursorTo(2,0);
        // lcd.printIn("Focus");
        
        // LcdClearLine(2);
      } else {
        cur_status = STATUS_IDLE;
        digitalWrite(RELAY_PIN,LOW);
        // LcdClearLine(0);
        relayState = LOW;
       }
    }
    
}

void expose() {
  float cur_time = expTime; 
  LcdPrintTime(cur_time);
}

void set_expose_status() {
    if (cur_status == STATUS_IDLE || cur_status == STATUS_EXPOSE) {
      if (relayState == LOW) {
        cur_status = STATUS_EXPOSE;
        digitalWrite(RELAY_PIN,HIGH);
        relayState = HIGH;
        // LcdClearLine(0);
        // lcd.cursorTo(0,0);
        // lcd.printIn("Exposing");
      } else {
        cur_status = STATUS_IDLE;
        digitalWrite(RELAY_PIN,LOW);
        // LcdClearLine(0);
        // LcdClearLine(2);
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


void time_up() {
  btn_click();
  if (baseTime < 100000.00) {
    baseTime += 1000.00;
  }
}

void time_down() {
  btn_click();
  if (baseTime > 1000.00) {
    baseTime -= 1000.00;
  }
}

void incr_up() {
  btn_click();
  if (currentIncr < 4) {
    currentIncr++;
  } else {
    currentIncr = 0;
  }
  factor = steps[currentIncr];
  LcdPrintInc();
}

void incr_down() {
  btn_click();
  if (currentIncr > 0) {
    currentIncr--;
  } else {
    currentIncr = 5;
  }
  factor = steps[currentIncr];
  LcdPrintInc();
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

double getTerm(int init, float razon, int step) {
  double term = init * pow(razon, step - 1);
  if (SERIAL_DEBUG) {
    Serial.print("step ");
    Serial.print(step);
    Serial.print("\t");
    Serial.print(term);
    Serial.print("\t");
    Serial.print(razon);
    Serial.print("\n");
  }
  return term;
}
