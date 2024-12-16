import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/common/entities/alarm_entity.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/pages/alarm/controller.dart';
import 'package:health_for_all/pages/following/controller.dart';
import 'package:health_for_all/pages/notification/controller.dart';
import 'package:health_for_all/pages/profile/controller.dart';

class AddAlarm extends StatefulWidget {
  final UserData user;
  final List<String> relativesIds;
  const AddAlarm({super.key, required this.user, required this.relativesIds});

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  final alarmController = Get.find<AlarmController>();
  final profileController = Get.find<ProfileController>();
  final followingController = Get.find<FollowingController>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Image.asset(
                "assets/images/warning_add.png",
                width: 32,
                height: 32,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                "Thêm cảnh báo",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          body(),
        ],
      ),
    );
  }

  Widget myTextField(String name, String hint, TextEditingController controller,
      {bool? readOnly}) {
    return SizedBox(
      child: TextField(
        controller: controller,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          labelText: name,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.outline,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        // drop(),
        // dropRelatives(),
        // const SizedBox(
        //   height: 24,
        // ),
        drop_alt(),
        // dropalt(),
        const SizedBox(
          height: 24,
        ),
        myTextField(
          "Đơn vị",
          "Đơn vị",
          alarmController.unitController,
          readOnly: true,
        ),
        const SizedBox(
          height: 24,
        ),
        myTextField(
          "Ngưỡng cao",
          "Ngưỡng cao",
          alarmController.highThresholdController,
        ),
        const SizedBox(
          height: 24,
        ),
        myTextField(
          "Ngưỡng thấp",
          "Ngưỡng thấp",
          alarmController.lowThresholdController,
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {
                alarmController.clearData();
                Get.back();
              },
              child: Text(
                "Đóng",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {
                alarmController.addAlarm(context, widget.user.id!);
              },
              child: Text(
                "Xác nhận",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget drop() {
    String? mySelection;
    final List<Map> medData = getMedData();
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
          isDense: true,
          hint: const Text("Chọn loại dữ liệu"),
          value: mySelection,
          onChanged: (newValue) {
            setState(() {
              mySelection = newValue;
            });
          },
          items: medData.map((Map map) {
            return DropdownMenuItem<String>(
              value: map["name"].toString(),
              child: Row(
                children: [
                  Image.asset(
                    map["image"],
                    width: 25,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(map["name"].toString()),
                  ),
                ],
              ),
            );
          }).toList(), // Convert the Iterable to a List
        ),
      ),
    );
  }

  final List<String> list = List.generate(
      10,
      (index) =>
          Item.getTitle(index)); // Use Item.getTitle to populate the list

  Widget dropRelatives() {
    return DropdownMenu(
      width: MediaQuery.of(context).size.width - 70,
      hintText: "Chọn người nhà",
      onSelected: (UserData? value) {
        alarmController.selectedRelative.value = value!;
        log(alarmController.selectedRelative.value.name!);
      },
      dropdownMenuEntries: followingController.state.relatives
          .map<DropdownMenuEntry<UserData>>((UserData value) {
        return DropdownMenuEntry<UserData>(value: value, label: value.name!);
      }).toList(),
    );
  }

  Widget drop_alt() {
    return DropdownMenu(
      width: MediaQuery.of(context).size.width - 70,
      hintText: "Chọn loại dữ liệu",
      onSelected: (String? value) {
        // if (checkavability(value!) == false) {}

        alarmController.seletedTypeId.value = list.indexOf(value!).toString();
        log(alarmController.seletedTypeId.value);
        alarmController.unitController.text = Item.getUnit(list.indexOf(value));
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }

  String? _selectedItem;
  String? _previousSelectedItem;

  Widget dropalt() {
    return DropdownButton<String>(
      value: _selectedItem,
      hint: const Text("Chọn loại dữ liệu"),
      icon: const Icon(Icons.arrow_downward),
      items: list.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) async {
        if (await checkavability(newValue!) == false) {
          // Show an alert dialog to notify the user
          showForbiddenItemDialog();

          // Revert to the previous selection
          setState(() {
            _selectedItem = _previousSelectedItem;
          });
        } else {
          // Update previous selection and set the new value
          setState(() {
            _previousSelectedItem = newValue;
            _selectedItem = newValue;
            alarmController.seletedTypeId.value = newValue;
          });
        }
      },
    );
  }

  void showForbiddenItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chỉ số đã được lựa chọn'),
          content: const Text(
              'Chỉ số đã được đặt cảnh báo, vui lòng lựa chọn chỉ số khác hoặc xóa cảnh báo'),
          actions: <Widget>[
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  List<Map> getMedData() {
    return List.generate(10, (index) {
      return {
        "id": index,
        "image": Item.getIconPath(index),
        "name": Item.getTitle(index),
        "unit": Item.getUnit(index),
      };
    });
  }

  Future<bool> checkavability(String value) async {
    List<AlarmEntity> alarms = await alarmController
        .fetchAlarms(alarmController.selectedRelative.value.id!);
    for (int i = 0; i < alarms.length; i++) {
      if (list.indexOf(value).toString() == alarms[i].typeId) {
        return false;
      }
    }
    return true;
  }
  // List<Map> MedData = getMedData();
}
