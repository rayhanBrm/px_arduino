#include <SoftwareSerial.h>

#define K           0.005163
#define CELLS       4
#define MAX_CELLS   12
const byte rxPin = 11;
const byte txPin = 12;

float volt, totalVoltage;
String condition;

double cell_const[MAX_CELLS] = 
{
  0.00517,
  0.004023,
  0.003734,
  0.003734,
  6.6,
  6.6,
  6.6,
  6.6,
  6.6,
  6.6,
  6.6,
  6.6
};

const int WARNING_LED = 9;
SoftwareSerial Serial2(rxPin,txPin);

void setup() 
{
  Serial.begin(57600);
  Serial2.begin(115200);
  pinMode(WARNING_LED, OUTPUT); 
}

void loop() {
  double battVolt = 0.0;
  double prevVolt = 0.0;
  
  for(int i = 0; i < CELLS; i++){
    double cellVolt = analogRead(i) * cell_const[i];
    //double cellVolt = analogRead(i);
    //DEBUNGGING
    /*
    Serial.print("Cell ");
    Serial.print(i+1);
    Serial.print(" = ");
    Serial.print(cellVolt);
    Serial.println();*/
    //cellVolt *= cell_const[i];
    battVolt += cellVolt;
    delay(500);
    } 
    //Serial.print("VOLTAGE:");
    Serial.println(battVolt);
    
    //Serial.println();
    delay(500);
        
  
}
