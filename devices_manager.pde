int keyboard_waitForAnyKey() {
  int key = NO_KEY;
  if(focus_btn.uniquePress()){
    key = KEY_FOCUS;
  }
  
  if(expose_btn.uniquePress()){
    key = KEY_EXPOSE;
  }
  
  if(up_btn.uniquePress()){
    key = KEY_UP;
  }
  
  if(down_btn.uniquePress()){
    key = KEY_DOWN;
  }
  
  if(mode_btn.uniquePress()){
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

void LcdPrintTime(int time) {
      lcd.cursorTo(2,10);
      char c[20];
      sprintf(c, "%3d.0\"", time);
      lcd.printIn(c); 
}
