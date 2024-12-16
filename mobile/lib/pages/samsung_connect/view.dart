import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/pages/samsung_connect/controller.dart';
import 'package:health_for_all/pages/samsung_connect/widget/data_fetched.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carp_serializable/carp_serializable.dart';

class HealthConnect extends StatefulWidget {
  const HealthConnect({super.key});

  @override
  State<HealthConnect> createState() => _HealthConnectState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
  HEALTH_CONNECT_STATUS,
  PERMISSIONS_REVOKING,
  PERMISSIONS_REVOKED,
  PERMISSIONS_NOT_REVOKED,
}

class _HealthConnectState extends State<HealthConnect> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 0;
  List<RecordingMethod> recordingMethodsToFilter = [];
  final healthConnectController = Get.put(SamsungConnectController());

  // All types available depending on platform (iOS ot Android).
  // List<HealthDataType> get types => (Platform.isAndroid)
  //     ? healthConnectController.state.dataTypesAndroid
  //     : (Platform.isIOS)
  //         ? healthConnectController.state.dataTypesIOS
  //         : [];
// // Or specify specific types
  static final types = [
    HealthDataType.WEIGHT,
    // HealthDataType.STEPS,
    // HealthDataType.HEIGHT,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.HEART_RATE,
    // HealthDataType.WORKOUT,
    // HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    // HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    // Uncomment this line on iOS - only available on iOS
    // HealthDataType.AUDIOGRAM
  ];

  // Set up corresponding permissions

  // READ only
  // List<HealthDataAccess> get permissions =>
  //     types.map((e) => HealthDataAccess.READ).toList();

  // Or both READ and WRITE
  List<HealthDataAccess> get permissions => types
      .map((type) =>
          // can only request READ permissions to the following list of types on iOS
          [
            HealthDataType.WALKING_HEART_RATE,
            HealthDataType.ELECTROCARDIOGRAM,
            HealthDataType.HIGH_HEART_RATE_EVENT,
            HealthDataType.LOW_HEART_RATE_EVENT,
            HealthDataType.IRREGULAR_HEART_RATE_EVENT,
            HealthDataType.EXERCISE_TIME,
          ].contains(type)
              ? HealthDataAccess.READ
              : HealthDataAccess.READ_WRITE)
      .toList();

  @override
  void initState() {
    // configure the health plugin before use and check the Health Connect status
    Health().configure();
    Health().getHealthConnectSdkStatus();

    super.initState();
  }

  /// Install Google Health Connect on this phone.
  Future<void> installHealthConnect() async =>
      await Health().installHealthConnect();

  /// Authorize, i.e. get permissions to access relevant health data.
  Future<void> authorize() async {
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have health permissions
    bool? hasPermissions =
        await Health().hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized = await Health()
            .requestAuthorization(types, permissions: permissions);
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    }

    setState(() => _state =
        (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
  }

  /// Gets the Health Connect status on Android.
  Future<void> getHealthConnectSdkStatus() async {
    assert(Platform.isAndroid, "This is only available on Android");

    final status = await Health().getHealthConnectSdkStatus();

    setState(() {
      _contentHealthConnectStatus =
          Text('Health Connect Status: ${status?.name.toUpperCase()}');
      _state = AppState.HEALTH_CONNECT_STATUS;
    });
  }

  Widget _buildDateTimeField(
      BuildContext context,
      String label,
      IconData icon,
      Future<void> Function(BuildContext) onTap,
      TextEditingController controller,
      {required double width}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        readOnly: true,
        onTap: () => onTap(context),
      ),
    );
  }

  void chooseDate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Chọn khoảng thời gian lấy dữ liệu',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateTimeField(
                  context,
                  'Ngày bắt đầu',
                  Icons.event_note,
                  healthConnectController.selectDateStart,
                  healthConnectController.startDateController,
                  width: MediaQuery.of(context).size.width * 0.8),
              _buildDateTimeField(
                  context,
                  'Ngày kết thúc',
                  Icons.event_note,
                  healthConnectController.selectDateEnd,
                  healthConnectController.endDateController,
                  width: MediaQuery.of(context).size.width * 0.8),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Xác nhận'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Fetch data points from the health plugin and show them in the app.
  Future<void> fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);

    // get data within the last 24 hours
    // final now = DateTime.now();
    // final yesterday = now.subtract(const Duration(hours: 24));

    // Clear old data points
    _healthDataList.clear();

    try {
      // fetch health data
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: types,
        startTime: healthConnectController.start,
        endTime: healthConnectController.end.add(const Duration(hours: 24)),
        recordingMethodsToFilter: recordingMethodsToFilter,
      );

      debugPrint('Total number of data points: ${healthData.length}. '
          '${healthData.length > 100 ? 'Only showing the first 100.' : ''}');

      // sort the data points by date
      healthData.sort((a, b) => b.dateTo.compareTo(a.dateTo));

      // save all the new data points (only the first 100)
      _healthDataList.addAll(
          (healthData.length < 100) ? healthData : healthData.sublist(0, 100));

      List<HealthDataPoint> listRemove = [];
      for (var p in _healthDataList) {
        int setType = 0;
        if (p.type.toString() == 'HealthDataType.HEART_RATE') setType = 3;
        if (p.type.toString() == 'HealthDataType.WEIGHT') setType = 7;
        if (p.type.toString() == 'HealthDataType.BLOOD_OXYGEN') setType = 4;
        var check = await FirebaseApi.checkExistDocumentForMed(
            'medicalData',
            'userId',
            healthConnectController.state.profile.value?.id ?? '',
            'typeId',
            setType.toString(),
            'time',
            Timestamp.fromDate(p.dateFrom));
        if (check == true) listRemove.add(p);
      }
      _healthDataList.removeWhere((p) => listRemove.contains(p));
    } catch (error) {
      debugPrint("Exception in getHealthDataFromTypes: $error");
    }

    // filter out duplicates
    _healthDataList = Health().removeDuplicates(_healthDataList);

    for (var data in _healthDataList) {
      debugPrint(toJsonString(data));
    }

    // update the UI to display the results
    setState(() {
      _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
    });
  }

  /// Add some random health data.
  /// Note that you should ensure that you have permissions to add the
  /// following data types.
  Future<void> addData() async {
    final now = DateTime.now();
    final earlier = now.subtract(const Duration(minutes: 20));

    // Add data for supported types
    // NOTE: These are only the ones supported on Androids new API Health Connect.
    // Both Android's Health Connect and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
    // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
    bool success = true;

    // misc. health data examples using the writeHealthData() method
    // success &= await Health().writeHealthData(
    //     value: 1.925,
    //     type: HealthDataType.HEIGHT,
    //     startTime: earlier,
    //     endTime: now,
    //     recordingMethod: RecordingMethod.manual);
    success &= await Health().writeHealthData(
        value: 90,
        type: HealthDataType.WEIGHT,
        startTime: now,
        recordingMethod: RecordingMethod.manual);
    success &= await Health().writeHealthData(
        value: 90,
        type: HealthDataType.HEART_RATE,
        startTime: earlier,
        endTime: now,
        recordingMethod: RecordingMethod.manual);
    // success &= await Health().writeHealthData(
    //     value: 90,
    //     type: HealthDataType.STEPS,
    //     startTime: earlier,
    //     endTime: now,
    //     recordingMethod: RecordingMethod.manual);
    // success &= await Health().writeHealthData(
    //   value: 200,
    //   type: HealthDataType.ACTIVE_ENERGY_BURNED,
    //   startTime: earlier,
    //   endTime: now,
    // );
    success &= await Health().writeHealthData(
        value: 70,
        type: HealthDataType.HEART_RATE,
        startTime: earlier,
        endTime: now);
    // if (Platform.isIOS) {
    //   success &= await Health().writeHealthData(
    //       value: 30,
    //       type: HealthDataType.HEART_RATE_VARIABILITY_SDNN,
    //       startTime: earlier,
    //       endTime: now);
    // } else {
    //   success &= await Health().writeHealthData(
    //       value: 30,
    //       type: HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
    //       startTime: earlier,
    //       endTime: now);
    // }
    // success &= await Health().writeHealthData(
    //     value: 37,
    //     type: HealthDataType.BODY_TEMPERATURE,
    //     startTime: earlier,
    //     endTime: now);
    // success &= await Health().writeHealthData(
    //     value: 105,
    //     type: HealthDataType.BLOOD_GLUCOSE,
    //     startTime: earlier,
    //     endTime: now);
    // success &= await Health().writeHealthData(
    //     value: 1.8,
    //     type: HealthDataType.WATER,
    //     startTime: earlier,
    //     endTime: now);

    // different types of sleep
    // success &= await Health().writeHealthData(
    //     value: 0.0,
    //     type: HealthDataType.SLEEP_REM,
    //     startTime: earlier,
    //     endTime: now);
    // success &= await Health().writeHealthData(
    //     value: 0.0,
    //     type: HealthDataType.SLEEP_ASLEEP,
    //     startTime: earlier,
    //     endTime: now);
    // success &= await Health().writeHealthData(
    //     value: 0.0,
    //     type: HealthDataType.SLEEP_AWAKE,
    //     startTime: earlier,
    //     endTime: now);
    // success &= await Health().writeHealthData(
    //     value: 0.0,
    //     type: HealthDataType.SLEEP_DEEP,
    //     startTime: earlier,
    //     endTime: now);

    // specialized write methods
    success &= await Health().writeBloodOxygen(
      saturation: 98,
      startTime: earlier,
      endTime: now,
    );
    // success &= await Health().writeWorkoutData(
    //   activityType: HealthWorkoutActivityType.AMERICAN_FOOTBALL,
    //   title: "Random workout name that shows up in Health Connect",
    //   start: now.subtract(const Duration(minutes: 15)),
    //   end: now,
    //   totalDistance: 2430,
    //   totalEnergyBurned: 400,
    // );
    // success &= await Health().writeBloodPressure(
    //   systolic: 90,
    //   diastolic: 80,
    //   startTime: now,
    // );
    // success &= await Health().writeMeal(
    //     mealType: MealType.SNACK,
    //     startTime: earlier,
    //     endTime: now,
    //     caloriesConsumed: 1000,
    //     carbohydrates: 50,
    //     protein: 25,
    //     fatTotal: 50,
    //     name: "Banana",
    //     caffeine: 0.002,
    //     vitaminA: 0.001,
    //     vitaminC: 0.002,
    //     vitaminD: 0.003,
    //     vitaminE: 0.004,
    //     vitaminK: 0.005,
    //     b1Thiamin: 0.006,
    //     b2Riboflavin: 0.007,
    //     b3Niacin: 0.008,
    //     b5PantothenicAcid: 0.009,
    //     b6Pyridoxine: 0.010,
    //     b7Biotin: 0.011,
    //     b9Folate: 0.012,
    //     b12Cobalamin: 0.013,
    //     calcium: 0.015,
    //     copper: 0.016,
    //     iodine: 0.017,
    //     iron: 0.018,
    //     magnesium: 0.019,
    //     manganese: 0.020,
    //     phosphorus: 0.021,
    //     potassium: 0.022,
    //     selenium: 0.023,
    //     sodium: 0.024,
    //     zinc: 0.025,
    //     water: 0.026,
    //     molybdenum: 0.027,
    //     chloride: 0.028,
    //     chromium: 0.029,
    //     cholesterol: 0.030,
    //     fiber: 0.031,
    //     fatMonounsaturated: 0.032,
    //     fatPolyunsaturated: 0.033,
    //     fatUnsaturated: 0.065,
    //     fatTransMonoenoic: 0.65,
    //     fatSaturated: 066,
    //     sugar: 0.067,
    //     recordingMethod: RecordingMethod.manual);

    // Store an Audiogram - only available on iOS
    // const frequencies = [125.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0];
    // const leftEarSensitivities = [49.0, 54.0, 89.0, 52.0, 77.0, 35.0];
    // const rightEarSensitivities = [76.0, 66.0, 90.0, 22.0, 85.0, 44.5];
    // success &= await Health().writeAudiogram(
    //   frequencies,
    //   leftEarSensitivities,
    //   rightEarSensitivities,
    //   now,
    //   now,
    //   metadata: {
    //     "HKExternalUUID": "uniqueID",
    //     "HKDeviceName": "bluetooth headphone",
    //   },
    // );

    // success &= await Health().writeMenstruationFlow(
    //   flow: MenstrualFlow.medium,
    //   isStartOfCycle: true,
    //   startTime: earlier,
    //   endTime: now,
    // );

    setState(() {
      _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
    });
  }

  /// Delete some random health data.
  Future<void> deleteData() async {
    final now = DateTime.now();
    final earlier = now.subtract(const Duration(hours: 24));

    bool success = true;
    for (HealthDataType type in types) {
      success &= await Health().delete(
        type: type,
        startTime: earlier,
        endTime: now,
      );
    }

    setState(() {
      _state = success ? AppState.DATA_DELETED : AppState.DATA_NOT_DELETED;
    });
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future<void> fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool stepsPermission =
        await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
    if (!stepsPermission) {
      stepsPermission =
          await Health().requestAuthorization([HealthDataType.STEPS]);
    }

    if (stepsPermission) {
      try {
        steps = await Health().getTotalStepsInInterval(midnight, now,
            includeManualEntry:
                !recordingMethodsToFilter.contains(RecordingMethod.manual));
      } catch (error) {
        debugPrint("Exception in getTotalStepsInInterval: $error");
      }

      debugPrint('Total number of steps: $steps');

      setState(() {
        _nofSteps = (steps == null) ? 0 : steps;
        _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      });
    } else {
      debugPrint("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  /// Revoke access to health data. Note, this only has an effect on Android.
  Future<void> revokeAccess() async {
    setState(() => _state = AppState.PERMISSIONS_REVOKING);

    bool success = false;

    try {
      await Health().revokePermissions();
      success = true;
    } catch (error) {
      debugPrint("Exception in revokeAccess: $error");
    }

    setState(() {
      _state = success
          ? AppState.PERMISSIONS_REVOKED
          : AppState.PERMISSIONS_NOT_REVOKED;
    });
  }

  // UI building below

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Samsung Health Connect",
        ),
        actions: const [
          Icon(
            Icons.help_outline,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            height: 1,
          ),
          if (Platform.isAndroid)
            TextButton(
                onPressed: getHealthConnectSdkStatus,
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                child: const Text("Kiểm tra kết nối Health Connect",
                    style: TextStyle(color: Colors.white))),
          if (Platform
                  .isAndroid /*&&
              Health().healthConnectSdkStatus !=
                  HealthConnectSdkStatus.sdkAvailable*/
              )
            TextButton(
                onPressed: installHealthConnect,
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                child: const Text("Kiểm tra quyền truy cập của Health Connect",
                    style: TextStyle(color: Colors.white))),
          if (Platform.isIOS ||
              Platform.isAndroid &&
                  Health().healthConnectSdkStatus ==
                      HealthConnectSdkStatus.sdkAvailable)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // TextButton(
              //     onPressed: authorize,
              //     style: const ButtonStyle(
              //         backgroundColor:
              //             WidgetStatePropertyAll(Colors.blue)),
              //     child: const Text("Authenticate",
              //         style: TextStyle(color: Colors.white))),
              TextButton(
                  onPressed: fetchData,
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                  child: const Text("Lấy dữ liệu",
                      style: TextStyle(color: Colors.white))),
              const SizedBox(
                width: 12,
              ),
              TextButton(
                  onPressed: chooseDate,
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                  child: const Text("Chọn ngày lấy dữ liệu",
                      style: TextStyle(color: Colors.white))),
              // SizedBox(
              //   width: 12,
              // ),
              // TextButton(
              //     onPressed: addData,
              //     style: const ButtonStyle(
              //         backgroundColor: WidgetStatePropertyAll(Colors.blue)),
              //     child: const Text("Add Data",
              //         style: TextStyle(color: Colors.white))),
              // TextButton(
              //     onPressed: fetchStepData,
              //     style: const ButtonStyle(
              //         backgroundColor:
              //             WidgetStatePropertyAll(Colors.blue)),
              //     child: const Text("Fetch Step Data",
              //         style: TextStyle(color: Colors.white))),
              // TextButton(
              //     onPressed: revokeAccess,
              //     style: const ButtonStyle(
              //         backgroundColor:
              //             WidgetStatePropertyAll(Colors.blue)),
              //     child: const Text("Revoke Access",
              //         style: TextStyle(color: Colors.white))),
            ]),
          // TextButton(
          //     onPressed: deleteData,
          //     style: const ButtonStyle(
          //         backgroundColor: WidgetStatePropertyAll(Colors.blue)),
          //     child: const Text("Xóa dữ liệu",
          //         style: TextStyle(color: Colors.white))),
          const Divider(thickness: 3),
          // if (_state == AppState.DATA_READY) _dataFiltration,
          // if (_state == AppState.STEPS_READY) _stepsFiltration,
          Expanded(child: Center(child: _content))
        ],
      ),
    );
  }

  Widget get _dataFiltration => Column(
        children: [
          Wrap(
            children: [
              for (final method in Platform.isAndroid
                  ? [
                      RecordingMethod.manual,
                      RecordingMethod.automatic,
                      RecordingMethod.active,
                      RecordingMethod.unknown,
                    ]
                  : [
                      RecordingMethod.automatic,
                      RecordingMethod.manual,
                    ])
                SizedBox(
                  width: 150,
                  child: CheckboxListTile(
                    title: Text(
                        '${method.name[0].toUpperCase()}${method.name.substring(1)} entries'),
                    value: !recordingMethodsToFilter.contains(method),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          recordingMethodsToFilter.remove(method);
                        } else {
                          recordingMethodsToFilter.add(method);
                        }
                        fetchData();
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
              // Add other entries here if needed
            ],
          ),
          const Divider(thickness: 3),
        ],
      );

  Widget get _stepsFiltration => Column(
        children: [
          Wrap(
            children: [
              for (final method in [
                RecordingMethod.manual,
              ])
                SizedBox(
                  width: 150,
                  child: CheckboxListTile(
                    title: Text(
                        '${method.name[0].toUpperCase()}${method.name.substring(1)} entries'),
                    value: !recordingMethodsToFilter.contains(method),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          recordingMethodsToFilter.remove(method);
                        } else {
                          recordingMethodsToFilter.add(method);
                        }
                        fetchStepData();
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
              // Add other entries here if needed
            ],
          ),
          const Divider(thickness: 3),
        ],
      );

  Widget get _permissionsRevoking => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(20),
              child: const CircularProgressIndicator(
                strokeWidth: 10,
              )),
          const Text('Revoking permissions...')
        ],
      );

  Widget get _permissionsRevoked => const Text('Permissions revoked.');

  Widget get _permissionsNotRevoked =>
      const Text('Failed to revoke permissions');

  Widget get _contentFetchingData => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(20),
              child: const CircularProgressIndicator(
                strokeWidth: 10,
              )),
          const Text('Fetching data...')
        ],
      );

  String convert(String val) {
    String res = "";
    for (int i = val.length - 1; i >= 0; i--) {
      if (val[i] == '.') {
        res = "";
      } else if (RegExp(r'^[0-9]$').hasMatch(val[i]))
        res = val[i] + res;
      else
        break;
    }
    return res;
  }

  String convertToHourMinute(DateTime dateTime) {
    // Define the format "hh:mm" (12-hour format with leading zeros if needed)
    DateFormat formatter = DateFormat('hh:mm');

    // Format the DateTime object
    return formatter.format(dateTime);
  }

  String convertToDayMonthYear(DateTime dateTime) {
    // Define the format "dd/mm/yyyy"
    DateFormat formatter = DateFormat('dd/MM/yyyy');

    // Format the DateTime object
    return formatter.format(dateTime);
  }

  Widget get _contentDataReady => ListView.builder(
      itemCount: _healthDataList.length,
      itemBuilder: (_, index) {
        // filter out manual entires if not wanted
        // if (recordingMethodsToFilter
        //     .contains(_healthDataList[index].recordingMethod)) {
        //   return Container();
        // }
        HealthDataPoint p = _healthDataList[index];
        int setType = 0;
        if (p.type.toString() == 'HealthDataType.HEART_RATE') setType = 3;
        if (p.type.toString() == 'HealthDataType.WEIGHT') setType = 7;
        if (p.type.toString() == 'HealthDataType.BLOOD_OXYGEN') setType = 4;
        print(p.type.toString());
        // if (p.value is AudiogramHealthValue) {
        //   return ListTile(
        //     title: Text("${p.typeString}: ${p.value}"),
        //     trailing: Text('${p.unitString}'),
        //     subtitle: Text('${p.dateFrom} - ${p.dateTo}\n${p.recordingMethod}'),
        //   );
        // }
        // if (p.value is WorkoutHealthValue) {
        //   return ListTile(
        //     title: Text(
        //         "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.name}"),
        //     trailing: Text(
        //         '${(p.value as WorkoutHealthValue).workoutActivityType.name}'),
        //     subtitle: Text('${p.dateFrom} - ${p.dateTo}\n${p.recordingMethod}'),
        //   );
        // }
        // if (p.value is NutritionHealthValue) {
        //   return ListTile(
        //     title: Text(
        //         "${p.typeString} ${(p.value as NutritionHealthValue).mealType}: ${(p.value as NutritionHealthValue).name}"),
        //     trailing:
        //         Text('${(p.value as NutritionHealthValue).calories} kcal'),
        //     subtitle: Text('${p.dateFrom} - ${p.dateTo}\n${p.recordingMethod}'),
        //   );
        // }
        return Container(
          decoration: BoxDecoration(border: Border.all()),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              DataDay(
                date: convertToDayMonthYear(p.dateFrom),
                time: convertToHourMinute(p.dateFrom),
                value: convert(p.value.toString()),
                index: setType,
                pass: p.dateFrom,
              ),
              // Text(convert(p.value.toString())),
              // Text('${p.unitString}'),
              // Text('${p.dateFrom} - ${p.dateTo}\n${p.recordingMethod}'),
            ],
          ),
        );
        // return ListTile(
        //   title: Text("${p.typeString}: ${p.value}"),
        //   trailing: Text('${p.unitString}'),
        //   subtitle: Text('${p.dateFrom} - ${p.dateTo}\n${p.recordingMethod}'),
        // );
      });

  final Widget _contentNoData = const Text('Không có dữ liệu nào từ Samsung Health');

  final Widget _contentNotFetched = SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child:
            const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Hướng dẫn sử dụng",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "1. Bấm vào 'Kiểm tra quyền truy cập Health Connect' để tải health connect nếu bạn chưa có và kiểm tra quyền truy cập chỉ số sức khỏe của app, nếu không có gì xảy ra thì truy cập health connect trong samsung health",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "2. Cho quyền viết và sửa dữ liệu y tế của ứng dụng HFA - Health For All và Samsung Health trong Health Connect",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "3. Bấm vào 'Chọn ngày lấy dữ liệu' để chọn khoảng thời gian lấy dữ liệu từ Samsung Health",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "4. Bấm vào 'Lấy dữ liệu' để lấy dữ liệu từ Samsung Health",
            style: TextStyle(fontSize: 20),
          ),
          // const Text("Press 'Add Data' to add some random health data."),
          // const Text("Press 'Delete Data' to remove some random health data."),
        ]),
      ),
    ),
  );

  final Widget _authorized = const Text('Authorization granted!');

  final Widget _authorizationNotGranted = const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Authorization not given.'),
      Text(
          'For Google Health Connect please check if you have added the right permissions and services to the manifest file.'),
      Text('For Apple Health check your permissions in Apple Health.'),
    ],
  );

  Widget _contentHealthConnectStatus = const Text(
      'No status, click getHealthConnectSdkStatus to get the status.');

  final Widget _dataAdded = const Text('Data points inserted successfully.');

  final Widget _dataDeleted = const Text('Data points deleted successfully.');

  Widget get _stepsFetched => Text('Total number of steps: $_nofSteps.');

  final Widget _dataNotAdded =
      const Text('Failed to add data.\nDo you have permissions to add data?');

  final Widget _dataNotDeleted = const Text('Failed to delete data');

  Widget get _content => switch (_state) {
        AppState.DATA_READY => _contentDataReady,
        AppState.DATA_NOT_FETCHED => _contentNotFetched,
        AppState.FETCHING_DATA => _contentFetchingData,
        AppState.NO_DATA => _contentNoData,
        AppState.AUTHORIZED => _authorized,
        AppState.AUTH_NOT_GRANTED => _authorizationNotGranted,
        AppState.DATA_ADDED => _dataAdded,
        AppState.DATA_DELETED => _dataDeleted,
        AppState.DATA_NOT_ADDED => _dataNotAdded,
        AppState.DATA_NOT_DELETED => _dataNotDeleted,
        AppState.STEPS_READY => _stepsFetched,
        AppState.HEALTH_CONNECT_STATUS => _contentHealthConnectStatus,
        AppState.PERMISSIONS_REVOKING => _permissionsRevoking,
        AppState.PERMISSIONS_REVOKED => _permissionsRevoked,
        AppState.PERMISSIONS_NOT_REVOKED => _permissionsNotRevoked,
      };
}
