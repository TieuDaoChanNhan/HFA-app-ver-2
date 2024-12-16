import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/graph_data_page/view.dart';
import 'package:health_for_all/pages/medical_data/index.dart';
import 'package:health_for_all/pages/medical_data_homepage/widget/GreyBox.dart';
import 'package:health_for_all/pages/overall_medical_data_history/view.dart';
import 'package:health_for_all/pages/type_med_history/view.dart';

class MedicalDataHome extends StatelessWidget {
  MedicalDataHome({super.key, this.time, this.user});
  final String? time;
  final UserData? user;
  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dữ liệu sức khỏe'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/HFA_small_icon.png'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Obx(
              () => Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildButtons(context),
                  const SizedBox(height: 16),
                  _buildGreyBoxRow1(
                    appController.state.medicalData['3'] != ""
                        ? appController.state.medicalData['3']['value']
                        : "",
                    appController.state.medicalData['3'] != ""
                        ? DatetimeChange.timestamptoHHMMDDMMYYYY(
                            appController.state.medicalData['3']['time'])
                        : "",
                    appController.state.medicalData['4'] != ""
                        ? appController.state.medicalData['4']['value']
                        : "",
                    appController.state.medicalData['4'] != ""
                        ? DatetimeChange.timestamptoHHMMDDMMYYYY(
                            appController.state.medicalData['4']['time'])
                        : "",
                  ),
                  const SizedBox(height: 16),
                  _buildGreyBoxRow2(
                    appController.state.medicalData['0'] != ""
                        ? appController.state.medicalData['0']['value']
                        : "",
                    appController.state.medicalData['0'] != ""
                        ? DatetimeChange.timestamptoHHMMDDMMYYYY(
                            appController.state.medicalData['0']['time'])
                        : "",
                    appController.state.medicalData['2'] != ""
                        ? appController.state.medicalData['2']['value']
                        : "",
                    appController.state.medicalData['2'] != ""
                        ? DatetimeChange.timestamptoHHMMDDMMYYYY(
                            appController.state.medicalData['2']['time'])
                        : "",
                  ),
                  const SizedBox(height: 16),
                  _buildGreyBoxRow3(
                    appController.state.medicalData['5'] != ""
                        ? appController.state.medicalData['5']['value']
                        : "",
                    appController.state.medicalData['5'] != ""
                        ? DatetimeChange.timestamptoHHMMDDMMYYYY(
                            appController.state.medicalData['5']['time'])
                        : "",
                    appController.state.medicalData['6'] != ""
                        ? appController.state.medicalData['6']['value']
                        : "",
                    appController.state.medicalData['6'] != ""
                        ? DatetimeChange.timestamptoHHMMDDMMYYYY(
                            appController.state.medicalData['6']['time'])
                        : "",
                  ),
                  const SizedBox(height: 16),
                  _buildGreyBoxRow4(
                    appController.state.medicalData['1'] != ""
                        ? appController.state.medicalData['1']['value']
                        : "",
                    appController.state.medicalData['1'] != ""
                        ? DatetimeChange.timestamptoHHMMDDMMYYYY(
                            appController.state.medicalData['1']['time'])
                        : "",
                    appController.state.medicalData['9'] != ""
                        ? appController.state.medicalData['9']['value']
                        : "",
                    appController.state.medicalData['9'] != ""
                        ? DatetimeChange.timestamptoHHMMDDMMYYYY(
                            appController.state.medicalData['9']['time'])
                        : "",
                  ),
                  const SizedBox(height: 16),
                  _buildGreyBoxRow5(
                    appController.state.medicalData['7'] != ""
                        ? appController.state.medicalData['7']['value']
                        : "",
                    appController.state.medicalData['7'] != ""
                        ? DatetimeChange.timestamptoHHMMDDMMYYYY(
                            appController.state.medicalData['7']['time'])
                        : "",
                    appController.state.medicalData['8'] != ""
                        ? appController.state.medicalData['8']['value']
                        : "",
                    appController.state.medicalData['8'] != ""
                        ? DatetimeChange.timestamptoHHMMDDMMYYYY(
                            appController.state.medicalData['8']['time'])
                        : "",
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(202, 196, 208, 1),
            width: 1,
          ),
          bottom: BorderSide(
            color: Color.fromRGBO(202, 196, 208, 1),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Icons.monitor_heart_outlined,
                size: 24,
                color: Color.fromRGBO(73, 69, 79, 1),
              ),
              SizedBox(width: 8),
              Text(
                "Dữ liệu y tế",
                style: TextStyle(
                  color: Color.fromRGBO(73, 69, 79, 1),
                ),
              ),
            ],
          ),
          Text(
            time != "" ? time! : "Chưa cập nhật",
            style: const TextStyle(
              color: Color.fromRGBO(121, 116, 126, 1),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildButton(
            onTap: () {
              Get.to(() => OverallMedicalDataHistoryPage());
            },
            icon: Icons.widgets_outlined,
            label: "Tất cả",
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildButton(
            onTap: () {
              Get.to(() => MedicalDataPage());
            },
            icon: Icons.add_circle_outline,
            label: "Thêm",
          ),
        )
      ],
    );
  }

  Widget _buildButton(
      {required VoidCallback onTap,
      required IconData icon,
      required String label}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromRGBO(234, 221, 255, 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(icon, size: 40, color: const Color.fromRGBO(101, 85, 143, 1)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color.fromRGBO(33, 0, 93, 1),
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreyBoxRow1(
      String value1, String time1, String value2, String time2) {
    print(time1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              print(time1);
              Get.to(() => TypeMedHistory("Nhịp tim"));
            },
            child: GreyBox(
              title: 'Nhịp tim',
              iconpath: 'assets/medical_data_Home_images/heart-rate.png',
              value: value1 != "" ? value1 : "--",
              unit: 'lần/phút',
              time: time1 == '' ? "Chưa cập nhật" : time1,
              warning: time1 == '' ? true : false,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => TypeMedHistory('SPO2'));
            },
            child: GreyBox(
              title: 'SPO2',
              iconpath: 'assets/medical_data_Home_images/spo2.png',
              value: value2 != "" ? value2 : "--",
              unit: '%',
              time: time2 == '' ? "Chưa cập nhật" : time2,
              warning: time2 == '' ? true : false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreyBoxRow2(
      String value1, String time1, String value2, String time2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => TypeMedHistory('Huyết áp'));
            },
            child: GreyBox(
              title: 'Huyết áp',
              iconpath: 'assets/medical_data_Home_images/blood-pressure.png',
              value: value1 != "" ? value1 : "--",
              unit: 'mmHg',
              time: time1 == '' ? "Chưa cập nhật" : time1,
              warning: time1 == '' ? true : false,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => TypeMedHistory('Đường huyết'));
            },
            child: GreyBox(
              title: 'Đường huyết',
              iconpath: 'assets/medical_data_Home_images/blood sugar.png',
              value: value2 != "" ? value2 : "--",
              unit: 'mg/dL',
              time: time2 == '' ? "Chưa cập nhật" : time2,
              warning: time2 == '' ? true : false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreyBoxRow3(
      String value1, String time1, String value2, String time2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => TypeMedHistory('HRV'));
            },
            child: GreyBox(
              title: 'HRV',
              iconpath: 'assets/medical_data_Home_images/favorite_border.png',
              value: value1 != "" ? value1 : "--",
              unit: 'ms',
              time: time1 == '' ? "Chưa cập nhật" : time1,
              warning: time1 == '' ? true : false,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => GraphDataPage("ECG - Điện tâm đồ"));
            },
            child: GreyBox(
              title: 'ECG - Điện tâm đồ',
              iconpath: 'assets/medical_data_Home_images/ecg-outline.png',
              value: value2 != "" ? value2 : "--",
              unit: ' ',
              time: time2 == '' ? "Chưa cập nhật" : time2,
              warning: time2 == '' ? true : false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreyBoxRow4(
      String value1, String time1, String value2, String time2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => TypeMedHistory('Thân nhiệt'));
            },
            child: GreyBox(
              title: 'Thân nhiệt',
              iconpath: 'assets/medical_data_Home_images/thermometer.png',
              value: value1 != "" ? value1 : "--",
              unit: '°C',
              time: time1 == '' ? "Chưa cập nhật" : time1,
              warning: time1 == '' ? true : false,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => TypeMedHistory('Axit Uric'));
            },
            child: GreyBox(
              title: 'Axit Uric',
              iconpath: 'assets/medical_data_Home_images/Axit Uric.png',
              value: value2 != "" ? value2 : "--",
              unit: 'mg/dL',
              time: time2 == '' ? "Chưa cập nhật" : time2,
              warning: time2 == '' ? true : false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreyBoxRow5(
      String value1, String time1, String value2, String time2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => TypeMedHistory('Cân nặng'));
            },
            child: GreyBox(
              title: 'Cân nặng',
              iconpath: 'assets/medical_data_Home_images/scale.png',
              value: value1 != "" ? value1 : "--",
              unit: 'Kg',
              time: time1 == '' ? "Chưa cập nhật" : time1,
              warning: time1 == '' ? true : false,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => GraphDataPage('PCG'));
            },
            child: GreyBox(
              title: 'PCG',
              iconpath:
                  'assets/medical_data_Home_images/medical_information.png',
              value: value2 != "" ? value2 : "--",
              unit: '--',
              time: time2 == '' ? "Chưa cập nhật" : time2,
              warning: time2 == '' ? true : false,
            ),
          ),
        ),
      ],
    );
  }
}
