/*
 * This file is part of DarkroomDuino
 *
 */

#include <math.h>
 
// Runs the controller
void controller_run(){}
void set_expose_status() {}
void cancel() {}

void scanKeyboard() {
  if(focus_btn.uniquePress()){
    
    btn_click();
    current_key = KEY_FOCUS;
    // focus();
    if (cur_status == STATUS_IDLE) {
      cur_status = STATUS_FOCUS;
    } else if (cur_status == STATUS_FOCUS ){
      cur_status = STATUS_IDLE;
    }
  } else if (expose_btn.uniquePress()){
    
    btn_click();
    current_key = KEY_EXPOSE;
    if (cur_status == STATUS_IDLE) {
      cur_status = STATUS_EXPOSE;
    } else if (cur_status == STATUS_EXPOSE) {
      // cancel
      cur_status = STATUS_IDLE;
      expTime = baseTime;
      limitMillis = 0;
    }
  } else if(up_btn.uniquePress()){
    
    btn_click();
    current_key = KEY_UP;
    time_up();
  } else if(down_btn.uniquePress()){
    
    btn_click();
    current_key = KEY_DOWN;
    time_down();
  } else if(mode_btn.uniquePress()){
    
    btn_click();
    current_key = KEY_MODE; 
    if (cur_status == STATUS_IDLE) {
      if (cur_mode < 1) {
        cur_mode++;
      } else {
        cur_mode = 0;
      }
    }
  } else if (incr_up_btn.uniquePress()) {
    
    btn_click();
    current_key = KEY_INCR_UP;
    if (cur_status == STATUS_IDLE && cur_mode == TEST_MODE) {
      incr_up();
    }
  } else if (ok_btn.uniquePress()) {
    
    btn_click();
    current_key = KEY_OK;
    /*
    if (cur_status == STATUS_IDLE && cur_mode == TEST_MODE) {
      incr_down();
    }
    */
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
      } else {
        cur_status = STATUS_IDLE;
        digitalWrite(RELAY_PIN,LOW);
        relayState = LOW;
       }
    }
    
}

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
