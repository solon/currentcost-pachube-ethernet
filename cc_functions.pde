// Functions to get data from CC128

int parseDataTmpr(int oldstate, char chr) {
  newstate = oldstate;
  if (newstate > 0) {
    if (chr == startTmpr[sizeTmpr-newstate]) {
      newstate--;
    } 
    else {
      newstate = sizeTmpr;
    }
  } 
  else if (newstate <= 0) {
    newstate--;
    if (chr == endChar) {
      newstate = sizeTmpr;
    }
  }
  return newstate;
}

int parseDataPwr(int oldstate, char chr) {
  newstate = oldstate;
  if (newstate > 0) {
    if (chr == startPwr[sizePwr-newstate]) {
      newstate--;
    } 
    else {
      newstate = sizePwr;
    }
  } 
  else if (newstate <= 0) {
    newstate--;
    if (chr == endChar) {
      newstate = sizePwr;
    }
  }
  return newstate;
}

int parseDataTime(int oldstate, char chr) {
  newstate = oldstate;
  if (newstate > 0) {
    if (chr == startTime[sizeTime-newstate]) {
      newstate--;
    } 
    else {
      newstate = sizeTime;
    }
  } 
  else if (newstate <= 0) {
    newstate--;
    if (chr == endChar) {
      newstate = sizeTime;
    }
  }
  return newstate;
}


void cc_read(){

  readChar = currentcost.read();

  // get data from CC128
  if (readChar > 31) {
    stateTime = parseDataTime(stateTime, readChar);
    if (stateTime < 0) {
      Time[abs(stateTime)-1] = readChar;
    }
    stateTmpr = parseDataTmpr(stateTmpr, readChar);
    if (stateTmpr < 0) {
      Tmpr[abs(stateTmpr)-1] = readChar;
    }
    statePwr = parseDataPwr(statePwr, readChar);
    if (statePwr < 0) {
      Pwr[abs(statePwr)-1] = readChar;
    }
  }

  // finished collecting data from CC128
  else if (readChar == 13) {

    PwrNum = atol(Pwr);
    TmprNum = atol(Tmpr);
    Serial.print("################################## ");
    Serial.println(Time);
    strcpy(TimeChr, Time);
    TmprDouble = strtod(Tmpr,NULL);
    TmprDecimal = abs((TmprDouble - (int)TmprDouble) * 100); // convert decimal data to integer

    // print debug information
    Serial.flush();
    Serial.println(" ");
    Serial.print("Time: ");
    Serial.print(TimeChr);    
    Serial.println(" ");
    Serial.print("Pwr: ");
    Serial.print(PwrNum);
    Serial.print(" ");
    Serial.print(" Tmpr: ");
    Serial.print(" ");
    Serial.print(TmprDouble);
    Serial.print(" / ");
    Serial.print(TmprNum);
    Serial.print(" ");
    Serial.print(TmprDecimal);
    Serial.println(" ");
    Serial.flush();

  }
}



