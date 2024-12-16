// mỗi lần đo nhịp tim & SPO2 (MAX30102) mất khoảng 4s. chỉnh được thời gian lấy mẫu và độ rộng xung để mỗi lần đo nhanh hơn
// To do: thời gian đo nhiệt độ (MLX90614) -> trả về thời gian một lần đo -> 130ms
// To do: thời gian cần để đo âm thanh (INMP441) ? 
// To do: mất 600ms để hiển thị ảnh động trái tim 
// To do: Tìm ảnh động lúc đo nhiệt độ, âm thanh ?

// To do: logo -> QR Code kết nối app -> báo kết nối thành công trên màn QR Code -> chuyển về menu chính 
//  -> đo SPO2 & nhịp tim -> hiển thị giá trị & hiển thị thông báo gửi thành công về app hoặc gửi lỗi

// Biến lưu vị trí menu từ 0 - tổng số menu. Trong hàm loop dùng switch case theo biến vị trí

#include<Sensor.h>
#include<MenuMaganer.h>
#include<temperature_icon.h>
#include<BLE.h>
#include<ECG_GIF.h>
#include<PCG_GIF.h>

Sensor sensor;

#define BUTTON_UP_PIN 12
#define BUTTON_DOWN_PIN 14
#define BUTTON_SELECT_PIN 15
#define BUTTON_BACK_PIN 27

char btMacAddress[30];
char careport[10] = "CAREPORT:";

void initButton(){
  pinMode(BUTTON_UP_PIN, INPUT_PULLUP);
  pinMode(BUTTON_DOWN_PIN, INPUT_PULLUP);
  pinMode(BUTTON_SELECT_PIN, INPUT_PULLUP);
  pinMode(BUTTON_BACK_PIN, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(BUTTON_UP_PIN), goUpMenu, FALLING);
  attachInterrupt(digitalPinToInterrupt(BUTTON_DOWN_PIN), goDownMenu, FALLING);
  attachInterrupt(digitalPinToInterrupt(BUTTON_SELECT_PIN), goIntoMenu, FALLING);
  attachInterrupt(digitalPinToInterrupt(BUTTON_BACK_PIN), goOutMenu, FALLING);
}

void setup() {
  Serial.begin(9600);
  // Khởi tạo BLE
  BLEDevice::init("ESP32");
  // Lấy địa chỉ MAC Bluetooth
  String macString = BLEDevice::getAddress().toString();
  // copy địa chỉ vào btMacAddress
  strcpy(btMacAddress, careport);
  strcat(btMacAddress, macString.c_str());
  // In địa chỉ MAC ra Serial Monitor
  toUpperCase(btMacAddress);
  Serial.print("Địa chỉ Bluetooth MAC của ESP32: ");
  Serial.println(btMacAddress);

  initMenu();
  scr.HFA_logo();
    // Hiển thị logo
  delay(5000);
  // khởi tạo cảm biến
  sensor.init();
  // Hiển thị menu
  initButton();
  displayMenu(); 
}

void displayGIFHeart(){
  sensor.turnOnHR();
  sensor.getDataHR_SPO2();
  String heartRate = (String)sensor.heartRate;
  String SPO2 = (String)sensor.SPO2;
  for(int i = 0; i < heart_len_frame; i++){
    scr.first();
    do{
      scr.drawBmp(48, 0, 32, 32, heart_array_frame[i]);
      scr.setFont(u8g2_font_7x13_mr).write(0, 30, "   HR        SPO2   ");
      scr.setFont(u8g2_font_6x12_mf).write(21, 50, sensor.heartRateValid == 0 ? "-" : heartRate).write(95,50, sensor.SPO2Valid == 0 ? "-" : SPO2);
      } while(scr.next());
    delay(40);
  } 
}
void displayECG(){
  for(int i = 0; i < ecg_len_frame; i++){
  scr.first();
  do{
    scr.drawBmp(0,0, 128, 64, ecg_array_frame[i]);
    } while(scr.next());
  }  
}
void displayTemp(){
  scr.first();
  do{
    scr.drawBmp(48, 0, 32, 32, epd_bitmap_temp_icon);
    //scr.setFont(u8g2_font_7x13_mr).write(50, 40, 15).write(85, 40, "oC");
  }while(scr.next());
}
void displayPCG(){
  for(int i = 0; i < pcg_len_frame; i++){
  scr.first();
  do{
    scr.drawBmp(0, 0, 128, 64, pcg_array_frame[i]);
    } while(scr.next());
  }  
}
void displayQRCodeConnect(){
  displayQRCode(btMacAddress);
  Serial.println(deviceConnected);
  while(!deviceConnected){
    ble();
    Serial.println(deviceConnected);
    sendData("Chua ket noi");
  }
  sendData("Da ket noi");
}
void displayQRCodeAboutUs(){
  displayQRCode("http://surl.li/zzcavt");
}
void display(void (*func)(), String name){
  while(getNameItemMenu() ==  name){
    func();
    Serial.println(getNameItemMenu());
    if(getNameItemMenu() != "HR & SPO2") sensor.turnOffHR();
  }
}
void loop() {
  displayMenu(); 
  display(displayQRCodeConnect, "Connect App");
  display(displayQRCodeAboutUs, "About us");
  display(displayGIFHeart, "HR & SPO2");
  display(displayECG, "ECG");
  display(displayTemp, "Body Temp");
  display(displayPCG, "PCG Sound");
  // long start = millis();
  // sensor.getDataMax30102();
  // Serial.println(millis() - start);
}
