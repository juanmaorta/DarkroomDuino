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
  up_btn.process();
  down_btn.process();
  ok_btn.process();

  if (up_btn.isPressed() && up_hold) {
    time_up();
  }

  if (down_btn.isPressed() && down_hold) {
    time_down();
  }

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
  // } else if(up_btn.uniquePress()){
  //   current_key = KEY_UP;
  //   time_up();
  // } else if(down_btn.uniquePress()){
  //   current_key = KEY_DOWN;
  //   time_down();
  } else if(mode_btn.uniquePress()){
    
    btn_click();
    current_key = KEY_MODE; 
    if (cur_status == STATUS_IDLE) {
      if (cur_mode < 1) {
        cur_mode++;
      } else {
        cur_mode = 0;
      }
    } else if (cur_status == STATUS_SELECT_INTERVAL){
      cur_mode = 0;
      cur_status = STATUS_IDLE;
    }
  } else if (incr_up_btn.uniquePress()) {
    
    btn_click();
    current_key = KEY_INCR_UP;
    if (cur_status == STATUS_IDLE && cur_mode == TEST_MODE) {
      incr_up();
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
      } else {
        cur_status = STATUS_IDLE;
        digitalWrite(RELAY_PIN,LOW);
        relayState = LOW;
       }
    }
    
}

void time_up() {
  /*
  static long lasttime;

  if (millis() < lasttime) {
     // we wrapped around, lets just try again
     lasttime = millis();
    
  }
  
  if ((lasttime + BUTTON_HOLD_TIME) > millis()) {
    // not enough time has passed to debounce
    return; 
  }
  // ok we have waited DEBOUNCE milliseconds, lets reset the timer
  lasttime = millis();
  */

  if (baseStep == 1) {
    btn_click();
    if (baseTime < 100000.00) {
      baseTime += 100.00;
      expTime = baseTime;
      intervals[0] = baseTime;
    }
  }
}

void time_down() {
  /*
  static long lasttime;

  if (millis() < lasttime) {
     // we wrapped around, lets just try again
     lasttime = millis();
    
  }
  
  if ((lasttime + BUTTON_HOLD_TIME) > millis()) {
    // not enough time has passed to debounce
    return; 
  }
  // ok we have waited DEBOUNCE milliseconds, lets reset the timer
  lasttime = millis();
  */

  if (baseStep == 1) {
    btn_click();
    if (baseTime > 1000.00) {
      baseTime -= 100.00;
      expTime = baseTime;
      intervals[0] = baseTime;
    }
  }
}

void incr_up() {
  if (baseStep == 1) {
    btn_click();
    if (currentIncr < 5) {
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

void show_intervals() {
  btn_click();
  current_key = KEY_OK;

  if (SERIAL_DEBUG) {
    for (int i = 0; i < baseStep; i++) { 
      if (i == current_displayed_interval) {
        Serial.print("[x] "); 
      } else {
        Serial.print("[ ] "); 
      }
      Serial.print("step ");
      Serial.print(i);
      Serial.print(" :");
      Serial.println(intervals[i]);

    }
    Serial.println(baseStep);
    Serial.println(current_displayed_interval);
  }
 
  if (current_displayed_interval < baseStep - 2) {
    current_displayed_interval ++;
  } else {
    current_displayed_interval = 0;
  }
  cur_status = STATUS_SELECT_INTERVAL;
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
