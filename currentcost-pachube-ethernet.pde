/*
 * Send CurrentCost readings from CC128 to Pachube using the Arduino Ethernet Shield
 * 2010-01-01 Francesco Anselmo
 */

// please fill in the variables and defines below according you your settings

#define rxPin 4                             // read only on pin 4 to get data from CC128
#define txPin 300                           // set write to non-existent pin (300)

#define SHARE_FEED_ID             9095     // this is the Pachube feed ID for data upload
#define UPDATE_INTERVAL           6000     // interval used to update data, in milliseconds
#define RESET_INTERVAL            10000     // interval used to reset the connection if needed, in milliseconds

#define PACHUBE_API_KEY            "INSERT YOUR PACHUBE API KEY HERE" // Pachube API key 

byte mac[] = { 
  0xCC, 0xAC, 0xBE, 0xEF, 0xFE, 0x91 };     // make sure this mac address is unique on your network

byte ip[] = { 
  192, 168, 1, 42 };                         // no DHCP so we set our own static IP address

// you shouldn't have to change anything below this line

byte remoteServer[] = { 
  209,40,205,190 };                         // pachube.com IP address

#include <Ethernet.h>
#include <string.h>
#include <NewSoftSerial.h>
#include <stdio.h>                          // for functions sprintf and strlen

// set up the software serial port
NewSoftSerial currentcost(rxPin, txPin);

char startTime[] = "<time>";
char startPwr[] = "<ch1><watts>";
char startTmpr[] = "<tmpr>";
char endChar = '<';

char readChar = 0xFF;

int sizePwr = sizeof(startPwr)-1;
int sizeTmpr = sizeof(startTmpr)-1;
int sizeTime = sizeof(startTime)-1;

int statePwr = sizePwr;
int stateTmpr = sizeTmpr;
int stateTime = sizeTime;

int newstate = 0;

char TimeChr[32] = ""; 
long PwrNum = 0;
double TmprDouble = 0.0;
long TmprNum = 0;
long TmprDecimal = 0;
 
unsigned int PwrSize = 0;
unsigned int TmprSize = 0;
unsigned int DataSize = 0;

char Time[32] = "";
char Pwr[16] = "";
char Tmpr[16] = "";
char TimeBuffer[32] = "";
char TmprBuffer[16] = "";
char PwrBuffer[64] = "";
char DataSizeBuffer[8] = "";

//
#define DEBUG // uncomment this line for extra debug information

#ifdef DEBUG
#define DEBUG_PRINT(x) Serial.print(x)
#define DEBUG_PRINTLN(x) Serial.println(x)
#else
#define DEBUG_PRINT(x)
#define DEBUG_PRINTLN(x)
#endif

void setup() {
  currentcost.begin(57600);    // connect to currentcost to get power and temperature data
  Serial.begin(115200);        // connect to the serial port for debugging info
  setupEthernet();             // setup ethernet connection
  delay(2000);
}

void loop () {
  pachube_in_out();
}



