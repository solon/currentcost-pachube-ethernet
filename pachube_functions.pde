// Functions to send data to Pachube

char pachube_data[16];

boolean found_status_200 = false;
boolean found_session_id = false;
char *found;
unsigned int successes = 0;
unsigned int failures = 0;
boolean ready_to_update = true;
boolean reading_pachube = false;

boolean request_pause = false;
boolean found_content = false;

unsigned long last_connect;

int content_length;

void pachube_in_out(){

  // read data from CC128
  if (currentcost.available()) {
    cc_read();
  }

  if (millis() < last_connect) last_connect = millis();

  if (request_pause){
    if ((millis() - last_connect) > interval){
      ready_to_update = true;
      reading_pachube = false;
      request_pause = false;
      found_status_200 = false;
      found_session_id = false;

      Serial.flush();
      DEBUG_PRINTLN("Ready to connect: ");
      DEBUG_PRINTLN(millis());
      Serial.flush();
    }
  }

  if (ready_to_update){
    Serial.flush();
    DEBUG_PRINTLN("Connecting ...");
    Serial.flush();
    if (localClient.connect()) {

      // here we assign comma-separated values to 'data', which will update Pachube datastreams
      sprintf(pachube_data, " %lu, %lu.%lu, %s", PwrNum, TmprNum, TmprDecimal, TimeChr);
      Serial.println("~~~~~~~~~~~ pachube_data ~~~~~~~~~~~~~~~");
      Serial.println(pachube_data);
      Serial.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
      
      content_length = strlen(pachube_data);

      Serial.flush();
      DEBUG_PRINT("\nPUT, to update feed: ");
      DEBUG_PRINT(PwrNum);
      DEBUG_PRINT(",");
      DEBUG_PRINT(int(TmprDouble));
      DEBUG_PRINT(",");
      DEBUG_PRINT(int(TimeChr));
      DEBUG_PRINT("-");
      DEBUG_PRINTLN(pachube_data);
      Serial.flush();

      localClient.print("PUT /api/");
      localClient.print(SHARE_FEED_ID);
      localClient.print(".csv HTTP/1.1\nHost: pachube.com\nX-PachubeApiKey: ");
      localClient.print(PACHUBE_API_KEY);

      localClient.print("\nUser-Agent: Arduino (Pachube In Out v1.1)");
      localClient.print("\nContent-Type: text/csv\nContent-Length: ");
      localClient.print(content_length);
      localClient.print("\nConnection: close\n\n");
      localClient.print(pachube_data);
      localClient.print("\n");

      ready_to_update = false;
      reading_pachube = true;
      request_pause = false;
      interval = UPDATE_INTERVAL;

      Serial.flush();
      DEBUG_PRINTLN("finished PUT");
      Serial.flush();

    } 
    else {
      Serial.print("connection failed! ");
      Serial.println(++failures);
      found_status_200 = false;
      found_session_id = false;
      ready_to_update = false;
      reading_pachube = false;
      request_pause = true;
      last_connect = millis();
      interval = RESET_INTERVAL;
      setupEthernet();
    }
  }

  while (reading_pachube){
    while (localClient.available()) {
      checkForResponse();
    } 

    if (!localClient.connected()) {
      disconnect_pachube();
    }
  } 
}

// disconnect after having sent data successfully
void disconnect_pachube(){
  Serial.println("Disconnecting.\n=====\n");
  localClient.stop();
  ready_to_update = false;
  reading_pachube = false;
  request_pause = true;
  last_connect = millis();
  found_content = false;
  resetEthernetShield();
}

void checkForResponse(){  
  char c = localClient.read();
  //Serial.print(c);
  buff[pointer] = c;
  if (pointer < 64) pointer++;
  if (c == '\n') {
    // connection succeeded!
    found = strstr(buff, "200 OK");    
    if (found != 0){
      found_status_200 = true; 
      Serial.flush();
      Serial.println(" ");
      Serial.println("Status 200");
      Serial.print(PwrNum);
      Serial.print(",");
      Serial.print(int(TmprDouble));
      Serial.print(",");
      Serial.print(TimeChr);      
      Serial.print("-");
      Serial.println(pachube_data);
      Serial.flush();
    }
    buff[pointer]=0;
    found_content = true;
    clean_buffer();    
  }

  if (found_status_200){
    found = strstr(buff, "_session=");
    if (found != 0){
      clean_buffer();
      found_session_id = true; 
    }
  }
}


