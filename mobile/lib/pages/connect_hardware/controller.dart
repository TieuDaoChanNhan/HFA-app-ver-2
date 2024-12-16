import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/API/firebase_messaging_api.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/common/entities/ecg_entity.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/connect_hardware/state.dart';
import 'connection_page.dart';

class ConnectHardwareController extends GetxController {
  final state = ConnectHardwareState();
  StreamSubscription? streamSubscription; // To manage the stream
  StreamSubscription? notificationSubscription; // To manage the stream
  final writeDataController = TextEditingController();
  final readDataController = TextEditingController();
  var scannedDevices = <ScanResult>[].obs;
  Rx<BluetoothCharacteristic?> readCharacteristic =
      Rx<BluetoothCharacteristic?>(null);
  Rx<BluetoothCharacteristic?> writeCharacteristic =
      Rx<BluetoothCharacteristic?>(null);
  bool isFoundreadCharacteristic = false;
  bool isFoundwriteCharacteristic = false;
  RxString remoteId = "".obs;
  final appController = Get.find<ApplicationController>();
  String receivedData = "";
  List<String> receivedIndex = [];

  RxString storageDataReceive = "".obs;
  RxList<String> storageDataSend = <String>[].obs;
  // Start scanning for BLE devices
  Future<void> scanDevice() async {
    log('Scanning for devices...');
    scannedDevices.clear();

    // Subscribe to scan results
    streamSubscription = FlutterBluePlus.onScanResults.listen(
      (results) async {
        if (results.isNotEmpty) {
          ScanResult r = results.last; // Get the last scanned device
          log('Found device: ${r.device.remoteId}: "${r.advertisementData.advName}"');
          scannedDevices.add(r);
          Get.back();
          // Add the device to the list
        }
      },
      onError: (e) => log('Scan error: $e'),
    );
    FlutterBluePlus.cancelWhenScanComplete(streamSubscription!);

    await FlutterBluePlus.adapterState
        .where((state) => state == BluetoothAdapterState.on)
        .first;

    await FlutterBluePlus.startScan(
      withRemoteIds: [remoteId.value],
    );

    // Wait until scanning stops
    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    streamSubscription?.cancel();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      log('Connecting to ${device.remoteId}');
      await device.connect();
      log('Connected to ${device.remoteId}');

      List<BluetoothService> services = await device.discoverServices();
      log('Services discovered: ${services.length}');

      for (BluetoothService service in services) {
        log('Service UUID: ${service.uuid}');

        for (BluetoothCharacteristic char in service.characteristics) {
          // log('Characteristic UUID: ${char.uuid}, properties: ${char.properties.notify}');

          // Sử dụng đặc tính có notify để nhận dữ liệu
          if (char.properties.notify && !isFoundreadCharacteristic) {
            log('Found the notify characteristic');
            readCharacteristic = Rx<BluetoothCharacteristic>(char);
            // Kích hoạt chế độ notify
            enableNotifications();
            isFoundreadCharacteristic = true;
          }

          // Sử dụng đặc tính có write để gửi dữ liệu
          if (char.properties.write && !isFoundwriteCharacteristic) {
            log('Found the write characteristic');
            writeCharacteristic = Rx<BluetoothCharacteristic>(char);
            isFoundwriteCharacteristic = true;
            writeCharacteristic.value!.write("hello".codeUnits);
          }
          if (isFoundreadCharacteristic && isFoundwriteCharacteristic) {
            break;
          }
        }
        if (isFoundreadCharacteristic && isFoundwriteCharacteristic) {
          break;
        }
      }
    } catch (e) {
      log('Error connecting to device: $e');
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void processData() {
    try {
      // Safely extract medId, dataValue, and interval from the decoded data
      int medId = int.parse(receivedIndex[0]);
      receivedIndex.removeAt(0);
      int interval = int.parse(receivedIndex[0]);
      receivedIndex.removeAt(0);
      List<double> index = receivedIndex.map((e) => double.parse(e)).toList();
      double value = 0;
      for (int i = 0; i < index.length; i++) {
        value += index[i];
      }
      value /= index.length;
      value = double.parse(value.toStringAsFixed(2));
      DateTime now = DateTime.now();

      log("MedId: $medId, Indexes: $index, Interval: $interval");

      // Add the date, time, and id to the respective RxList properties
      state.medDate.add(formatDate(now));
      state.medTime.add(formatTime(now));
      state.medId.add(medId);
      state.medPass.add(now);
      state.medIndex.add(index);
      state.medValue.add(value.toString());

      // Safely convert dynamic values to doubles, ignoring invalid values
    } catch (e) {
      log("Error processing data: $e");
      // Optionally handle the error more specifically if needed
    }
  }

  Future<void> enableNotifications() async {
    try {
      // Cancel any existing notification subscription
      notificationSubscription?.cancel();

      // Enable notifications on the characteristic
      await readCharacteristic.value?.setNotifyValue(true);
      log('Notifications enabled.');

      // Listen for data sent via notify from ESP32
      // receivedData = "";
      notificationSubscription =
          readCharacteristic.value?.onValueReceived.listen((data) {
        receivedData = String.fromCharCodes(data);
        // String tmp = String.fromCharCodes(data);
        // log('Length: $receivedData');
        if (receivedData != "}" && receivedData != ",") {
          log('ReceivedData: $receivedData');
          receivedIndex.add(receivedData);
        }
        // Log received data for debugging
        // log('Received data: $tmp');

        // Check if the last character is '}', indicating the end of the JSON message
        if (receivedData == "}") {
          try {
            // log('Received data chunk: $receivedData');
            log("Start decoding");
            // Decode the JSON string and process the data
            processData();
          } catch (e) {
            log('Error decoding JSON data: $e');
          } finally {
            // Reset receivedData after processing
            receivedIndex.clear();
          }
        }
      }, onError: (error) {
        log('Error receiving data: $error');
      });
    } catch (e) {
      log('Failed to enable notifications: $e');
    }
  }

  Future<void> disableNotifications() async {
    if (readCharacteristic.value != null) {
      await readCharacteristic.value!.setNotifyValue(false);
    }
  }

  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    await disableNotifications();
    await device.disconnect();
    log('Disconnected from ${device.remoteId}');
  }

  void clearData() {
    storageDataReceive.value = "";
    isFoundreadCharacteristic = false;
    isFoundwriteCharacteristic = false;
    writeCharacteristic = Rx<BluetoothCharacteristic?>(null);
    readCharacteristic = Rx<BluetoothCharacteristic?>(null);
    storageDataSend.clear();
    state.medDate.clear();
    state.medId.clear();
    state.medPass.clear();
    state.medTime.clear();
    state.medValue.clear();
  }

  // Send data to the connected device's characteristic
  Future<void> sendData() async {
    log('Sending data...${writeCharacteristic.value}');
    if (writeCharacteristic.value != null) {
      log('Sending data...');
      String data = writeDataController.text;
      List<int> bytesToSend = data.codeUnits; // Convert text to bytes
      try {
        await writeCharacteristic.value!
            .write(bytesToSend); // Write the bytes to the characteristic
        log('Data sent: $data');
      } catch (e) {
        log('Error sending data: $e');
      }
    } else {
      log('No characteristic available to send data.');
    }
  }

  Future syncMedData(DateTime time, String typeId, String value, String unit,
      BuildContext context) async {
    // isLoading = true.obs;
    Get.dialog(const Center(child: CircularProgressIndicator()));
    final data = MedicalEntity(
      userId: appController.state.profile.value?.id,
      time: Timestamp.fromDate(time),
      typeId: typeId,
      value: value,
      unit: unit,
    );

    log(data.toString());
    await FirebaseApi.addDocument("medicalData", data.toFirestoreMap());
    checkAlarms(data.toFirestoreMap());
    appController.getUpdatedLatestMedical();
    // isLoading = false.obs;
    Get.back();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: const Text('Đã đồng bộ dữ liệu'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  Future checkAlarms(Map<String, dynamic> data) async {
    try {
      log("gửi");
      // Truy vấn tất cả các document trong collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('alarms').where('userId', isEqualTo: appController.state.profile.value!.id).get();

      // Chuyển đổi kết quả thành một danh sách các Map (dữ liệu JSON)
      List<Map<String, dynamic>> documents = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      int typeId = int.parse(data["typeId"]);
      for (var i in documents) {
        if (i['enable'] == false) continue;
        if (data["typeId"] != i["typeId"]) continue;
        int low = int.parse(i["lowThreshold"]);
        int high = int.parse(i["highThreshold"]);
        if (typeId == 0) {
          String value = data['value'];
          List<String> parts = value.split('/');
          int systolic = int.parse(parts[0]);
          int diastolic = int.parse(parts[1]);
          value = i['highThreshold'];
          parts = value.split('/');
          int highSystolic = int.parse(parts[0]);
          int highDiastolic = int.parse(parts[1]);
          value = i['lowThreshold'];
          parts = value.split('/');
          int lowSystolic = int.parse(parts[0]);
          int lowDiastolic = int.parse(parts[1]);
          if (systolic<lowSystolic||systolic>highSystolic||diastolic<lowDiastolic||diastolic>highDiastolic) sendAlarm(typeId, value);
        } else {
          int value = int.parse(data['value']);
          if (value < low || value > high) sendAlarm(typeId, value.toString());
        }
      }
    } catch (e) {
      print('Lỗi khi lấy documents: $e');
      return [];
    }
  }

  void sendAlarm(int type, String value) {
    FirebaseMessagingApi.sendMessage(
      appController.state.profile.value!.fcmtoken!,
      'Cảnh báo',
      "Chỉ số ${Item.getTitle(type)} $value ${Item.getUnit(type)} của bạn đang ở ngoài ngưỡng an toàn",
      'alarm',
      '/alarm',
      appController.state.profile.value!.id!,
      'alarm',
    );
  }

  Future syncEcgData(DateTime time, String typeId, List<String> index,
      String value, String unit, BuildContext context) async {
    Get.dialog(const Center(child: CircularProgressIndicator()));

    final data = MedicalEntity(
      userId: appController.state.profile.value?.id,
      time: Timestamp.fromDate(time),
      value: value,
      unit: unit,
      typeId: typeId,
      index: index,
    );

    log(data.toString());
    await FirebaseApi.addDocument("medicalData", data.toFirestoreMap());
    // appController.getUpdatedLatestMedical();
    Get.back();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: const Text('Đã đồng bộ dữ liệu ECG'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back(); // Dismiss the dialog
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  @override
  void onClose() {
    streamSubscription
        ?.cancel(); // Cancel the stream when the controller is disposed
    notificationSubscription?.cancel();
    super.onClose();
  }
}
