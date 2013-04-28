/*
 * This file is part of DarkroomDuino
 *
 *
 */

#include <math.h>
 
 // Runs the controller
 
// Runs the controller
void controller_run(){}
void set_expose_status() {}
void cancel() {}

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

void set_expose_status() {}

void cancel() {}


void time_up() {
  if (baseStep == 1) {
    btn_click();
    if (baseTime < 100000.00) {
      baseTime += 1000.00;
      expTime = baseTime;
    }
  }
}

void time_down() {
  if (baseStep == 1) {
    btn_click();
    if (baseTime > 1000.00) {
      baseTime -= 1000.00;
      expTime = baseTime;
    }
  }
}

void incr_up() {
  if (baseStep == 1) {
    btn_click();
    if (currentIncr < 4) {
      currentIncr++;
    } else {
      currentIncr = 0;
    }
    factor = steps[currentIncr];
    if (SERIAL_DEBUG) {
      Serial.print("incrementos ");
      Serial.print(currentIncr);
      Serial.print("; factor: ");
      Serial.println(factor);
    }
  }
}

void incr_down() {
  btn_click();
  /*
  btn_click();
  if (currentIncr > 0) {
    currentIncr--;
  } else {
    currentIncr = 5;
  }
  factor = steps[currentIncr];
  if (SERIAL_DEBUG) {
    Serial.print("incrementos ");
    Serial.print(currentIncr);
    Serial.print("; factor: ");
    Serial.println(factor);
  }
  */
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
