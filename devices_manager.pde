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
  float seconds = millis / 1000.0;
  char dtostrfbuffer[15];
  if (seconds <= 99.99) {
    dtostrf(seconds,5, 2, dtostrfbuffer);
    lc.setChar(0,0,dtostrfbuffer[4],false);
    lc.setChar(0,1,dtostrfbuffer[3],false);
    lc.setChar(0,2,dtostrfbuffer[1],true);
    lc.setChar(0,3,dtostrfbuffer[0],false);
  } else {
    dtostrf(seconds,5, 1, dtostrfbuffer);
    lc.setChar(0,0,dtostrfbuffer[4],false);
    lc.setChar(0,1,dtostrfbuffer[2],true);
    lc.setChar(0,2,dtostrfbuffer[1],false);
    lc.setChar(0,3,dtostrfbuffer[0],false);
  }
}

void LcdPrintStep(int step) {
      lcd.cursorTo(0,13);
      char c[20];
      sprintf(c, "#%02d", step);
      lcd.printIn(c);
      
      lcd.cursorTo(2,0);
      
      float total = prevExpTime / 1000.00;
      
      char dtostrfbuffer[15];
      dtostrf(total,5, 2, dtostrfbuffer);
      // Serial.println(dtostrfbuffer);
      lcd.printIn("total ");
      lcd.printIn(dtostrfbuffer);
      lcd.printIn("\"");
}

void LcdPrintInc() {
     lcd.cursorTo(0,13);
     lcd.printIn(stepStrings[currentIncr]);
} 
