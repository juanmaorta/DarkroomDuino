/*
 * This file is part of DarkroomDuino
 *
 */

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

void LcdPrintTime(float millis) {
      float seconds = millis / 1000.00;

      int d1 = seconds;
      float f2 = seconds - d1;
      int d2 = trunc(f2 * 100);

      lcd.cursorTo(2,7);
      char c[20];
      if (SERIAL_DEBUG) {
        Serial.println( sprintf(c, "%02d.%02d sec", d1, d2));
      }
      sprintf(c, "%02d.%02d sec", d1, d2);
      lcd.printIn(c); 
}

void LcdPrintStep(int step) {
      lcd.cursorTo(2,0);
      char c[20];
      sprintf(c, "#%02d", step);
      lcd.printIn(c); 
}

void LcdPrintInc() {
     lcd.cursorTo(0,13);
     lcd.printIn(stepStrings[currentIncr]);
} 