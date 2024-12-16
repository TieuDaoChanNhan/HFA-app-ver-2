#include <Adafruit_MLX90614.h>
#include <DFRobot_MAX30102.h>
#include <AceSorting.h>

// 0x3C // ssd1306
// 0x57 // max30102
// 0x5A // mlx90614

Adafruit_MLX90614 mlx90614 = Adafruit_MLX90614();
DFRobot_MAX30102 max30102;

const int N = 200;
float dataTemp[N];

class Sensor
{
public:
  float AmbientTempC;
  float ObjectTempC;

  int32_t SPO2; //SPO2
  int8_t SPO2Valid; //Flag to display if SPO2 calculation is valid
  int32_t heartRate; //Heart-rate
  int8_t heartRateValid; //Flag to display if heart-rate calculation is valid 
  Sensor(){}
  void init(){ // call on setup
    if(!mlx90614.begin(0x5A)){
      Serial.println("Error connecting to MLX sensor. Check wiring");
      return;
    }
    else if(!max30102.begin()){
      Serial.println("MAX30102 was not found");
      return;
    }
  }
  void turnOnHR(){    // gọi khi dùng cảm biến MAX30102 
    max30102.sensorConfiguration(
      /*ledBrightness=*/50, 
      /*sampleAverage=*/SAMPLEAVG_4, 
      /*ledMode=*/MODE_MULTILED, 
      /*sampleRate=*/SAMPLERATE_100, 
      /*pulseWidth=*/PULSEWIDTH_411, 
      /*adcRange=*/ADCRANGE_16384
    );
    // Đặt tốc độ lấy mẫu
    max30102.setSampleRate(100);  // Ví dụ: 100 mẫu/giây
    // Đặt kích thước LED Pulse Width (giảm để lấy dữ liệu nhanh hơn)
    max30102.setPulseWidth(69);   // 69us để có tốc độ nhanh hơn
  }
  void turnOffHR(){
    max30102.shutDown();
  }
  void getDataTemp(){    
    AmbientTempC = mlx90614.readAmbientTempC();
    ObjectTempC = mlx90614.readObjectTempC();
    if (isnan(AmbientTempC) || isnan(ObjectTempC)) {
      Serial.println("Error reading temperature data");
      return;
    } else {
      Serial.print("\tAmbient: "); Serial.print(AmbientTempC);
      Serial.print("\tObject: "); Serial.println(ObjectTempC);
    }
  }
  float readTemp(){
    for(int i = 0; i< N; i++){
      dataTemp[i] = mlx90614.readObjectTempC();    
    }
    ace_sorting::bubbleSort(dataTemp, N);
    float sum = 0;
    for(int i = 0.2 * N; i < 0.8 * N; i++){
      sum += dataTemp[i];

    }
    return sum / (0.6 * N);
  }
  void getDataHR_SPO2(){
    max30102.heartrateAndOxygenSaturation(/**SPO2=*/&SPO2, 
                                          /**SPO2Valid=*/&SPO2Valid, 
                                          /**heartRate=*/&heartRate, 
                                          /**heartRateValid=*/&heartRateValid);
    Serial.print("heartRate=");  Serial.print(heartRate); 
    Serial.print(", heartRateValid=");   Serial.print(heartRateValid);
    Serial.print("; SPO2=");   Serial.print(SPO2);
    Serial.print(", SPO2Valid=");    Serial.println(SPO2Valid);
  }
};




