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
  int d1 = seconds;
  float f2 = seconds - d1;

  int centena = 0;
  int decena = 0;
  int unidad = 0;
  int decimal = trunc(f2 * 10);


  if (d1 > 99) {
    centena = d1/100;
    decena = (d1/100.0 - centena) * 10;
    unidad = (d1/10.0 - d1/10) * 10;
    // decena = centena / 10;
    // unidad = d1 - decena * 10;
  } else if (d1 > 9) {
    decena = d1/10;
    unidad = d1 - decena * 10;
  } else {
    unidad = d1;
  }

  if (centena > 0) {
    lc.setChar(0,3,centena,false);
  } else {
    lc.setChar(0,3,' ',false);
  }
  if (decena > 0) {
    lc.setChar(0,2,decena,false);
  } else {
    lc.setChar(0,2,' ',false);
  }
  lc.setChar(0,1,unidad,true);
  lc.setChar(0,0,decimal,false);
    
    /*
      

      int d1 = seconds;
      float f2 = seconds - d1;
      int d2 = trunc(f2 * 100);

      lcd.cursorTo(2,7);
      char c[20];
      // if (SERIAL_DEBUG) {
      //   Serial.println( sprintf(c, "%02d.%02d sec", d1, d2));
      // }
      sprintf(c, "%02d.%02d sec", d1, d2);
      lcd.printIn(c);
      */
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
