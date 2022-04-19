#include <stdio.h>
#include <time.h>
#include "main.h"
#include "stm32f4xx_hal_gpio.h"
#include "phases.h"
#include "Peripherals/DHT_wrap.h"

/*************************
    Global Variables
 ************************/
float temp_avg;
float humi_avg;

// retrieve commands from pi if relevant
void phase1() {
	printf ("Phase1: Read commands from Pi!\r\n");
}

// decode commands, set the target values
void phase2() {
	printf ("Phase2: Decode commands from Pi!\r\n");
}

// DHT structs store temperature and humidity
DHT_DataTypedef data1, data2, data3, data4;

// read sensor data, determine actuator flag values
void phase3() {
	printf ("Phase 3: Read sensor data!\r\n");
	HAL_Delay(2000); // Sensor needs delay of at least 2 seconds before new read

	// read DHTs
	DHT_GetData (&data1, 1);
	printf ("Temperature: %f\r\n", data1.Temperature);
	printf ("Humidity: %f\r\n", data1.Humidity);
//	DHT_GetData (&data2, 2);
//	printf ("Temperature: %f\r\n", data2.Temperature);
//	printf ("Humidity: %f\r\n", data2.Humidity);
//	DHT_GetData (&data3, 3);
//	printf ("Temperature: %f\r\n", data3.Temperature);
//	printf ("Humidity: %f\r\n", data3.Humidity);
//	DHT_GetData (&data4, 4);
//	printf ("Temperature: %f\r\n", data4.Temperature);
//	printf ("Humidity: %f\r\n", data4.Humidity);
//
//	// calculate averages
//	temp_avg = (data1.Temperature + data2.Temperature + data3.Temperature + data4.Temperature) / 4;
//	humi_avg = (data1.Humidity + data2.Humidity + data3.Humidity + data4.Humidity) / 4;

}

// command actuators / control units
void phase4() {
	printf ("Phase4: Command actuators/control units!\r\n");
}

// package data, send back to pi
void phase5() {
	printf ("Phase5: Send data back to Pi, check for updated commands!\r\n");
}

