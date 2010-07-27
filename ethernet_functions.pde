// Functions to setup the Arduino Ethernet Shield
// http://www.arduino.cc/en/Main/ArduinoEthernetShield

Client localClient(remoteServer, 80);
unsigned int interval;

char buff[64];
int pointer = 0;

void setupEthernet(){
  resetEthernetShield();
  Client remoteClient(255);
  delay(500);
  interval = UPDATE_INTERVAL;

  Serial.flush();
}

void clean_buffer() {
  pointer = 0;
  memset(buff,0,sizeof(buff)); 
}

void resetEthernetShield(){
  Serial.flush();
  DEBUG_PRINTLN("Reset ethernet");
  Serial.flush();

  Ethernet.begin(mac, ip);
  //Ethernet.begin(mac, ip, gateway, subnet);
}

