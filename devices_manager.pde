int keyboard_waitForAnyKey() {
  int key = NO_KEY;
  if(focus_btn.uniquePress()){
    key = KEY_FOCUS;
  }
  
  if(expose_btn.uniquePress()){
    set_expose_mode();
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


void btn_click() {
    digitalWrite(BUZZER_PIN, HIGH);
    delay(CLICK_LENGTH);
    digitalWrite(BUZZER_PIN, LOW);  
}

void LcdClearLine(int r) {
  lcd.cursorTo(r,0);
  for (int i = 0; i < 16; i++) {
    lcd.printIn(" ");
  }
}

/*
void LcdPrintTime(int time) {
      lcd.cursorTo(2,7);
      char c[20];
      sprintf(c, "%3d.0 sec", time);
      lcd.printIn(c); 
}
*/

void LcdPrintTime(float millis) {
      float seconds = millis / 1000.00;
      lcd.cursorTo(2,7);
      char c[20];
      if (SERIAL_DEBUG) {
        Serial.println(seconds);
      }
      sprintf(c, "%f", seconds);
      lcd.printIn(c); 
}

void LcdPrintStep(int step) {
      lcd.cursorTo(2,0);
      char c[20];
      sprintf(c, "step %2d", step);
      lcd.printIn(c); 
}
