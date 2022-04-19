// @file ControlLoop_TempHumid.c 
// @author Clayden Boyd
// @brief lays out the methods for STM mc to control the temp and humidity 
// 1 or 0
#define HEATERPORT
#define HEATERADDR
#define HUMIDPORT
#define HUMIDADDR
// integer values
#define BOXTEMP // number from sensor port
#define BOXHUMID // numb from sensor port 
#define ONTIME  // ms to wait before comparing the temperature again -- may need different timings for humidiifier and heat pad 
// timer stuff
void taskTempControl();
void taskHumidityControl()

int main() {
  while(1) {
    taskTempControl(); 
    taskHumidityControl();
    delay(1)
  }
  return 0;
}

// compares the temperature within the terrarium to the set value
// and turns on the heat pad for a set amount of time or turns it off
// before comparing againg
void taskTempControl() {
  if (setTemp < BOXTEMP) {
    HEATERPORT |= 1<<HEATERADDR;
  } else {
    HEATERPRT &= ~(1<<HEATERADDR;  
  } 
  delay(ONTIME)
}

// compares the humidity within the terrarium to the set value
// and turns on the humidifier for a set amount of time or turns it off
// before comparing againg
void taskHUMIDControl() {
  if (setHumid < BOXHUMID) {
    HEATERPORT |= 1<<HEATERADDR;
  } else {
    HEATERPRT &= ~(1<<HEATERADDR;  
  } 
  delay(ONTIME)
}
