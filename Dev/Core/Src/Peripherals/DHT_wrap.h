#ifndef INC_DHT_H_
#define INC_DHT_H_

typedef struct
{
	float Temperature;
	float Humidity;
}DHT_DataTypedef;


void DHT_GetData (DHT_DataTypedef *DHT_Data, uint32_t deviceNum);

#endif /* INC_DHT_H_ */
